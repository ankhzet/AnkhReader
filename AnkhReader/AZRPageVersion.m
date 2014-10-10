//
//  AZRPageVersions.m
//  AnkhReader
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRPageVersion.h"
#import "AZREntities.h"

@implementation AZRPageVersion
@synthesize zipped, timestamp, size;
@dynamic page;

+ (NSString *) type {
	static NSString *const PageVersionTypeIdentifier = @"page-version";
	return PageVersionTypeIdentifier;
}

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	ASSIGN_IF_NOTNULL(self.page, REGISTERED_ENTITY(AZRPage, registry, json, @"page"));

	ASSIGN_IF_NOTNULL(self.timestamp, JSON_I(json, @"timestamp"));
	ASSIGN_IF_NOTNULL(self.size, JSON_I(json, @"size"));
	ASSIGN_IF_NOTNULL(self.zipped, JSON_I(json, @"zipped"));
}

+ (NSDictionary *) pageVersionsFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry {
	NSTimeInterval dateRef = 60 * 60 * 24 * (356 * 40 + 10); // 2010
	double denom = 10000000000.;

	NSMutableDictionary *versions = [NSMutableDictionary dictionaryWithCapacity:[json count]];
	for (NSDictionary *versionJSON in json) {
		NSNumber *page = JSON_I(versionJSON, @"page");
		NSNumber *uid = JSON_I(versionJSON, @"timestamp");
		double floatPage = [page unsignedIntegerValue];
		double fracTime = [uid unsignedIntegerValue];
		fracTime = (fracTime - dateRef) / denom;
		uid = @(floatPage + fracTime);
		AZRPageVersion *version = [self entity:uid fromJSON:versionJSON inRegistry:registry];
		versions[version.uid] = version;
	}

	return versions;
}

- (NSString *) description {
	return [NSString stringWithFormat:@"{Version@%@(%@): %@, %@ KB (zipped to %@ KB)}", self.page.uid, self.timestamp, self.page.title, self.size, self.zipped];
}


@end
