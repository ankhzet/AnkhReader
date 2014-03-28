//
//  AZRUpdate.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntitiesRegistry.h"
#import "AZRUpdate.h"
#import "AZRAuthor.h"
#import "AZRGroup.h"
#import "AZRPage.h"

@implementation AZRUpdate

- (void) setAuthor:(AZRAuthor *)author {
	if (_author == author)
		return;

	_author = author;
	_author.updates[self.uid] = self;
}

- (void) setGroup:(AZRGroup *)group {
	if (_group == group)
		return;

	_group = group;
	_group.updates[self.uid] = self;
}

- (void) setPage:(AZRPage *)page {
	if (_page == page)
		return;

	_page = page;
	_page.updates[self.uid] = self;
}

+ (NSString *) type {
	static NSString *const UpdateTypeIdentifier = @"update";
	return UpdateTypeIdentifier;
}

+ (instancetype) entity:(NSNumber *)uid fromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	AZRUpdate *update = [registry hasEntity:uid withType:[self type]];
	if (update)
		return update;

	update = [self newEntity:uid inRegistry:registry];

	update.kind = [json objectForKey:@"kind"];

	update.author = [registry hasEntity:[json objectForKey:@"authorID"] withType:[AZRAuthor type]];
	update.group = [registry hasEntity:[json objectForKey:@"groupID"] withType:[AZRGroup type]];
	update.page = [registry hasEntity:[json objectForKey:@"pageID"] withType:[AZRPage type]];

	NSDictionary *desc = [json objectForKey:@"description"];
	update.size = [desc objectForKey:@"size"];
	update.delta = [desc objectForKey:@"delta"];
	update.pub = [desc objectForKey:@"pubdate"];

	return update;
}

- (BOOL) isNew {
	return [self.size integerValue] == [self.delta integerValue];
}

- (BOOL) isDeleted {
	return ![self.size integerValue];
}


@end
