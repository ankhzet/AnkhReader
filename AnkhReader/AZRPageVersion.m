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

+ (NSString *) type {
	static NSString *const PageVersionTypeIdentifier = @"page-version";
	return PageVersionTypeIdentifier;
}

- (void) setPage:(AZRPage *)page {
	if (_page == page)
		return;

	_page = page;
	_page.versions[self.uid] = self;
}

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	ASSIGN_IF_NOTNULL(self.page, REGISTERED_ENTITY(AZRPage, registry, json, @"page"));

	ASSIGN_IF_NOTNULL(self.timestamp, [[json objectForKey:@"timestamp"] unsignedIntegerValue]);
	ASSIGN_IF_NOTNULL(self.size, [[json objectForKey:@"size"] unsignedIntegerValue]);
	ASSIGN_IF_NOTNULL(self.zipped, [[json objectForKey:@"zipped"] unsignedIntegerValue]);
}

+ (NSDictionary *) pageVersionsFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry {
	NSTimeInterval dateRef = 60 * 60 * 24 * (356 * 40 + 10); // 2010
	double denom = 10000000000.;

	NSMutableDictionary *versions = [NSMutableDictionary dictionaryWithCapacity:[json count]];
	for (NSDictionary *versionJSON in json) {
		NSNumber *page = [versionJSON objectForKey:@"page"];
		NSNumber *uid = [versionJSON objectForKey:@"timestamp"];
		double floatPage = [page unsignedIntegerValue];
		double fracTime = [uid unsignedIntegerValue];
		fracTime = (fracTime - dateRef) / denom;
		uid = @(floatPage + fracTime);
		AZRPageVersion *version = [self entity:uid fromJSON:versionJSON inRegistry:registry];
		versions[version.uid] = version;
	}

	return versions;
}


@end
