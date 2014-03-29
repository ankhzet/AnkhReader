//
//  AZRAuthor.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAuthor.h"
#import "AZREntitiesRegistry.h"

@implementation AZRAuthor {
	NSMutableDictionary *_groups, *_pages, *_updates;
}

- (id)init {
	if (!(self = [super init]))
		return self;

	_groups = [NSMutableDictionary dictionary];
	_pages = [NSMutableDictionary dictionary];
	_updates = [NSMutableDictionary dictionary];
	return self;
}

+ (NSString *) type {
	static NSString *const AuthorTypeIdentifier = @"author";
	return AuthorTypeIdentifier;
}

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	ASSIGN_IF_NOTNULL(self.fio, [json objectForKey:@"fio"]);
	ASSIGN_IF_NOTNULL(self.link, [json objectForKey:@"link"]);
	ASSIGN_IF_NOTNULL(self.updated, [json objectForKey:@"time"]);

	self.updateFreq = @0;
}

+ (NSDictionary *) authorsFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry {
	NSMutableDictionary *authors = [NSMutableDictionary dictionaryWithCapacity:[json count]];
	for (NSDictionary *authorJSON in json) {
		AZRAuthor *author = [self entity:[authorJSON objectForKey:@"id"] fromJSON:authorJSON inRegistry:registry];
		authors[author.uid] = author;
	}

	return authors;
}


- (NSString *) description {
	return [NSString stringWithFormat:@"{Author@%@: %@}", self.uid, self.fio];
}

@end
