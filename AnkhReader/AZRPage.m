//
//  AZRPage.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntitiesRegistry.h"
#import "AZRAuthor.h"
#import "AZRGroup.h"
#import "AZRPage.h"

@implementation AZRPage
@synthesize link, updated, size, title, descr;
@dynamic author, group, versions, updates;

+ (NSString *) type {
	static NSString *const PageTypeIdentifier = @"page";
	return PageTypeIdentifier;
}

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	ASSIGN_IF_NOTNULL(self.author, REGISTERED_ENTITY(AZRAuthor, registry, json, @"authorID"));
	ASSIGN_IF_NOTNULL(self.group, REGISTERED_ENTITY(AZRGroup, registry, json, @"groupID"));

	ASSIGN_IF_NOTNULL(self.title, JSON_S(json, @"title"));
	ASSIGN_IF_NOTNULL(self.link, JSON_S(json, @"link"));

	NSDictionary *d = JSON_O(json, @"description") ? JSON_O(json, @"description") : json;
	ASSIGN_IF_NOTNULL(self.descr, JSON_S(d, @"description"));
	ASSIGN_IF_NOTNULL(self.size, JSON_I(d, @"size"));
}

+ (NSDictionary *) pagesFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry {
	NSMutableDictionary *pages = [NSMutableDictionary dictionaryWithCapacity:[json count]];
	for (NSDictionary *pageJSON in json) {
		AZRPage *page = [self entity:JSON_I(pageJSON, @"id") fromJSON:pageJSON inRegistry:registry];
		pages[page.uid] = page;
	}

	return pages;
}

- (NSString *) description {
	return [NSString stringWithFormat:@"{Page@%@: %@ (%@) %lu kB}", self.uid, self.title, self.link, (unsigned long)self.size];
}

@end
