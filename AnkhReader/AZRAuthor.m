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

+ (instancetype) entity:(NSNumber *)uid fromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	AZRAuthor *author = [registry hasEntity:uid withType:[self type]];
	if (author)
		return author;

	author = [self newEntity:uid inRegistry:registry];
	author.fio = [json objectForKey:@"fio"];
	author.link = [json objectForKey:@"link"];
	author.updated = [json objectForKey:@"time"];

	author.updateFreq = @0;

	return author;
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
	return [NSString stringWithFormat:@"{@%@:%@}", self.uid, self.fio];
}

@end
