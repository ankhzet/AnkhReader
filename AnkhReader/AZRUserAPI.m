//
//  AZRLoginAction.m
//  AnkhReader
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRUserAPI.h"

#import "AZREntities.h"

@implementation AZRUserAPI {
	NSArray *cookies;
}

+ (instancetype) userAPI {
	return [self new];
}

- (void) unLogin {
	for (NSHTTPCookie *cookie in cookies) {
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
	}
}

- (AZHTTPRequest *) aquireUser:(NSUInteger)uid withCompletion:(void(^)(id data))block {
	NSNumber *nuid = @(uid);
	AZRUser *user = [AZREntitiesRegistry hasEntity:nuid withType:[AZRUser type]];

	if (user) {
		block(user);
		return nil;
	}

	AZJSONRequest *userRequest = [self action:@"user"];
	[userRequest setParameters:@{@"uid": nuid}];
	[[userRequest success:^(AZHTTPRequest *request, id *data) {
		block([AZRUser entity:nuid fromJSON:*data inRegistry:[AZREntitiesRegistry getInstance]]);
		return YES;
	}] error:^BOOL(AZHTTPRequest *action, NSString *response) {
		block(nil);
		return YES;
	}];

	return [self queue:userRequest withType:AZAPIRequestTypeDefault];
}


- (AZHTTPRequest *) loginWithParams:(NSDictionary *)params withCompletion:(void(^)(id data))block {
	AZJSONRequest *loginRequest = [self action:@"user-login"];
	[loginRequest setParameters:params];
	[[loginRequest success:^(AZHTTPRequest *request, id *data) {
		NSURL *url = request.response.URL;

		NSHTTPCookieStorage *s = [NSHTTPCookieStorage sharedHTTPCookieStorage];

		cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:request.response.allHeaderFields forURL:url];
		[s setCookies:cookies forURL:url mainDocumentURL:[url absoluteRootURL]];

		NSInteger uid = [[[cookies hasCookie:@"user"] value] integerValue];
		if (!uid) {
			[AZUtils notifyErrorMsg:[NSString stringWithFormat:@"Login failed: %@", *data]];
			return NO;
		} else
			[self aquireUser:uid withCompletion:^(AZRUser *user) {
				block(user);
			}];

		return YES;
	}] error:^BOOL(AZHTTPRequest *action, NSString *response) {
		block(nil);
		return YES;
	}];

	return [self queue:loginRequest withType:AZAPIRequestTypeImperative];
}

@end
