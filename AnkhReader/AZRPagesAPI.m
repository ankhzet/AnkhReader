//
//  AZRPagesAPI.m
//  AnkhReader
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRPagesAPI.h"
#import "AZAPIProvider.h"

#import "AZREntities.h"

@implementation AZRPagesAPI

- (AZHTTPRequest *) aquirePage:(NSUInteger)uid withCompletion:(void(^)(AZRPage *page))block {
	NSNumber *nuid = @(uid);
	__block AZRPage *page = [AZREntitiesRegistry hasEntity:nuid withType:[AZRPage type]];

	if (page) {
		block(page);
		return nil;
	}

	AZJSONRequest *pageRequest = [self action:@"pages"];
	[pageRequest setParameters:@{@"id": nuid, @"collumn": @"id,author,group,title,description,size"}];
	[[pageRequest success:^(AZHTTPRequest *request, id *data) {
		NSDictionary *pages = [AZRPage pagesFromJSON:*data inRegistry:[AZREntitiesRegistry getInstance]];

		block(pages[page.uid]);
		return YES;
	}] error:^BOOL(AZHTTPRequest *action, NSString *response) {
		block(nil);
		return YES;
	}];

	return [self queue:pageRequest withType:AZAPIRequestTypeDefault];
}

- (AZHTTPRequest *) aquirePageVersions:(AZRPage *)page withCompletion:(void(^)(NSSet *versions))block {
	NSSet *pageVersions = page.versions;

	if (pageVersions.count) {
		block(pageVersions);
		return nil;
	}

	AZJSONRequest *versionsRequest = [self action:@"page-versions"];
	[versionsRequest setParameters:@{@"page": page.uid}];
	[[versionsRequest success:^(AZHTTPRequest *request, id *data) {
		NSArray *versions = [[AZRPageVersion pageVersionsFromJSON:*data inRegistry:[AZREntitiesRegistry getInstance]] allValues];
		block([NSSet setWithArray:versions]);
		return YES;
	}] error:^BOOL(AZHTTPRequest *action, NSString *response) {
		block(nil);
		return YES;
	}];

	return [self queue:versionsRequest withType:AZAPIRequestTypeDefault];
}

@end
