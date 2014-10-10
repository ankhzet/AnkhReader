//
//  AZRAuthor.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAuthor.h"
#import "AZREntitiesRegistry.h"

@implementation AZRAuthor
@synthesize fio, link, freq, updated;
@dynamic groups, pages, updates;

+ (NSString *) type {
	static NSString *const AuthorTypeIdentifier = @"author";
	return AuthorTypeIdentifier;
}

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	ASSIGN_IF_NOTNULL(self.fio, JSON_S(json, @"fio"));
	ASSIGN_IF_NOTNULL(self.link, JSON_S(json, @"link"));
	ASSIGN_IF_NOTNULL(self.updated, JSON_I(json, @"time"));

	self.freq = @0;
}

+ (NSDictionary *) authorsFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry {
	NSMutableDictionary *authors = [NSMutableDictionary dictionaryWithCapacity:[json count]];
	for (NSDictionary *authorJSON in json) {
		AZRAuthor *author = [self entity:JSON_I(authorJSON, @"id") fromJSON:authorJSON inRegistry:registry];
		authors[author.uid] = author;
	}

	return authors;
}


- (NSString *) description {
	return [NSString stringWithFormat:@"{Author@%@: %@}", self.uid, self.fio];
}

@end
