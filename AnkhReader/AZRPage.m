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
	return self;
}

+ (NSString *) type {
	static NSString *const PageTypeIdentifier = @"page";
	return PageTypeIdentifier;
}

+ (instancetype) entity:(NSNumber *)uid fromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	AZRPage *page = [registry hasEntity:uid withType:[self type]];
	if (page)
		return page;

	page = [self newEntity:uid inRegistry:registry];

	page.author = [registry hasEntity:[json objectForKey:@"authorID"] withType:[AZRAuthor type]];
	page.group = [registry hasEntity:[json objectForKey:@"groupID"] withType:[AZRGroup type]];

	page.title = [json objectForKey:@"title"];
	
	NSDictionary *d = [json objectForKey:@"description"];
	page.description = [d objectForKey:@"description"];
	page.size = [[d objectForKey:@"size"] unsignedIntegerValue];

	return page;
}

@end
