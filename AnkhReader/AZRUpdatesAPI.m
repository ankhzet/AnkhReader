//
//  AZRUpdatesAPI.m
//  AnkhReader
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRUpdatesAPI.h"
#import "AZAPIProvider.h"

#import "AZREntities.h"

@implementation AZRUpdatesAPI

- (AZHTTPRequest *) aquireUpdates:(NSDictionary *)params withCompletion:(void(^)(id data))block {
	NSDictionary *data = [AZREntitiesRegistry entitiesOfType:[AZRUpdate type]];

	if (data.count) {
		block(data);
		return nil;
	}

	AZJSONRequest *updatesRequest = [self action:@"updates"];
	[updatesRequest setParameters:params];
	[updatesRequest success:^(AZHTTPRequest *request, id *data) {
		block([AZRUpdate fetchUpdates:*data inRegistry:[AZREntitiesRegistry getInstance]]);
		return YES;
	}];

	return [self queue:updatesRequest withType:AZAPIRequestTypeDefault];
}


@end
