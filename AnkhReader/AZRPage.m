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

- (void) setAuthor:(AZRAuthor *)author {
	if (_author == author)
		return;

	_author = author;
	_author.pages[self.uid] = self;
}

- (void) setGroup:(AZRGroup *)group {
	if (_group == group)
		return;

	_group = group;
	_group.pages[self.uid] = self;
}

- (id)init {
	if (!(self = [super init]))
		return self;

	_updates = [NSMutableDictionary dictionary];
	_versions = [NSMutableDictionary dictionary];
	return self;
}

+ (NSString *) type {
	static NSString *const PageTypeIdentifier = @"page";
	return PageTypeIdentifier;
}

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	ASSIGN_IF_NOTNULL(self.author, REGISTERED_ENTITY(AZRAuthor, registry, json, @"authorID"));
	ASSIGN_IF_NOTNULL(self.group, REGISTERED_ENTITY(AZRGroup, registry, json, @"groupID"));

	ASSIGN_IF_NOTNULL(self.title, [json objectForKey:@"title"]);
	ASSIGN_IF_NOTNULL(self.link, [json objectForKey:@"link"]);

	NSDictionary *d = [json objectForKey:@"description"] ? [json objectForKey:@"description"] : json;
	ASSIGN_IF_NOTNULL(self.descr, [d objectForKey:@"description"]);
	ASSIGN_IF_NOTNULL(self.size, [[d objectForKey:@"size"] unsignedIntegerValue]);
}

+ (NSDictionary *) pagesFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry {
	NSMutableDictionary *pages = [NSMutableDictionary dictionaryWithCapacity:[json count]];
	for (NSDictionary *pageJSON in json) {
		AZRPage *page = [self entity:[pageJSON objectForKey:@"id"] fromJSON:pageJSON inRegistry:registry];
		pages[page.uid] = page;
	}

	return pages;
}

- (NSString *) description {
	return [NSString stringWithFormat:@"{Page@%@: %@ (%@) %lu kB}", self.uid, self.title, self.link, (unsigned long)self.size];
}

@end
