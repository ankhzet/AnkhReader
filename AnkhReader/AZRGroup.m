//
//  AZRGroup.m
//  AnkhReader
//
//  Created by Ankh on 09.10.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntities.h"

@implementation AZRGroup {
	NSString *_title;
}

@synthesize inlined = _inlined;
@dynamic title, descr, author, pages, updates;

- (void) setTitle:(NSString *)t {
	NSRange r = [t rangeOfString:@"@"];

	if ((self.inlined = (!!r.length) && !r.location))
		t = [t substringFromIndex:1];

	_title = [t isEqualToString:@"<null>"] ? [NSString stringWithFormat:@"Deleted group: {Group@%@: (%@)}", self.uid, self.author.fio] : t;
}

- (NSString *) title {
	return _title;
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
