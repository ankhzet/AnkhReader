//
//  AZRGroup.m
//  AnkhReader
//
//  Created by Ankh on 09.10.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntities.h"

@implementation AZRGroup
@synthesize descr, inlined = _inlined, title = _title;
@dynamic author, pages, updates;

- (void) setTitle:(NSString *)t {
	NSRange r = [t rangeOfString:@"@"];

	if ((self.inlined = (!!r.length) && !r.location))
		t = [t substringFromIndex:1];

	_title = t;
}

+ (NSString *) type {
	static NSString *const GroupTypeIdentifier = @"group";
	return GroupTypeIdentifier;
}

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	ASSIGN_IF_NOTNULL(self.author, REGISTERED_ENTITY(AZRAuthor, registry, json, @"authorID"));

	ASSIGN_IF_NOTNULL(self.title, JSON_S(json, @"group"));
	id d;
	json = [(d = JSON_O(json, @"description")) isKindOfClass:[NSDictionary class]] ? d : json;

	ASSIGN_IF_NOTNULL(self.descr, JSON_S(json, @"description"));
}

- (NSString *) description {
	return [NSString stringWithFormat:@"{Group@%@: %@ (%@)}", self.uid, self.title, self.author.fio];
}

@end
