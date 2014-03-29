//
//  AZRGroup.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRGroup.h"
#import "AZRAuthor.h"
#import "AZREntitiesRegistry.h"

@implementation AZRGroup {
	NSMutableDictionary *_pages;
}

- (void) setAuthor:(AZRAuthor *)author {
	if (_author == author)
		return;

	_author = author;
	_author.groups[self.uid] = self;
}

- (id)init {
	if (!(self = [super init]))
		return self;

	_pages = [NSMutableDictionary dictionary];
	_updates = [NSMutableDictionary dictionary];
	return self;
}

- (void) setTitle:(NSString *)title {
	NSRange r = [title rangeOfString:@"@"];

	if ((self.inlined = (!!r.length) && !r.location))
		title = [title substringFromIndex:1];

	_title = title;
}

+ (NSString *) type {
	static NSString *const GroupTypeIdentifier = @"group";
	return GroupTypeIdentifier;
}

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	ASSIGN_IF_NOTNULL(self.author, REGISTERED_ENTITY(AZRAuthor, registry, json, @"authorID"));
	
	ASSIGN_IF_NOTNULL(self.title, [json objectForKey:@"group"]);
	ASSIGN_IF_NOTNULL(self.description, [json objectForKey:@"description"]);
}

- (NSString *) description {
	return [NSString stringWithFormat:@"{Group@%@: %@ (%@)}", self.uid, self.title, self.author.fio];
}

@end
