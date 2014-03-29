//
//  AZRAuthorsAction.m
//  AnkhReader
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAuthorsAPI.h"
#import "AZAPIProvider.h"

#import "AZREntities.h"

@implementation AZRAuthorsAPI

- (AZHTTPRequest *) aquireAuthors:(NSDictionary *)params withCompletion:(void(^)(id data))block {
	NSDictionary *authorsData = [AZREntitiesRegistry entitiesOfType:[AZRAuthor type]];

	if (authorsData.count) {
		block(authorsData);
		return nil;
	}

	AZJSONRequest *authorsRequest = [self action:@"authors"];
	[authorsRequest setParameters:params];
	[authorsRequest success:^(AZHTTPRequest *request, id *data) {
		block([AZRAuthor authorsFromJSON:*data inRegistry:[AZREntitiesRegistry getInstance]]);
		return YES;
	}];

	return [self queue:authorsRequest withType:AZAPIRequestTypeImperative];
}

@end
