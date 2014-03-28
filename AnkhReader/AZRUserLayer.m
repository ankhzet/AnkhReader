//
//  AZRLoginAction.m
//  AnkhReader
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRUserLayer.h"
#import "AZRAPIAction.h"

@implementation AZRUserLayer

+ (instancetype) userLayer {
	return [self new];
}

- (AZRAPIAction *) loginWithParams:(NSDictionary *)params {
	AZRAPIAction *loginAction = [self action:@"user-login"];
	[loginAction setParameters:params];
	[[loginAction error:^(AZRAPIAction *action, NSString *response) {
		[AZUtils notifyErrorMsg:response];
	} firstly:NO] success:^(AZRAPIAction *action, id data) {
		NSURL *url = action.response.URL;
		NSHTTPCookieStorage *s = [NSHTTPCookieStorage sharedHTTPCookieStorage];
		cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:action.response.allHeaderFields forURL:url];
		[s setCookies:cookies forURL:url mainDocumentURL:[url absoluteRootURL]];
	} firstly:NO];

	return loginAction;
}

@end
