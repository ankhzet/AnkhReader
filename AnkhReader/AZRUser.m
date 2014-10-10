//
//  AZRUser.m
//  AnkhReader
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRUser.h"
#import "AZREntitiesRegistry.h"

@implementation AZRUser
@synthesize nickname, acl;

+ (NSString *) type {
	static NSString *const UserTypeIdentifier = @"user";
	return UserTypeIdentifier;
}

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	ASSIGN_IF_NOTNULL(self.nickname, JSON_S(json, @"login"));
}

+ (NSDictionary *) usersFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry {
	NSMutableDictionary *users = [NSMutableDictionary dictionaryWithCapacity:[json count]];
	for (NSDictionary *userJSON in json) {
		AZRUser *user = [self entity:JSON_I(userJSON, @"id") fromJSON:userJSON inRegistry:registry];
		users[user.uid] = user;
	}

	return users;
}


- (NSString *) description {
	return [NSString stringWithFormat:@"{User@%@: %@}", self.uid, self.nickname];
}

@end
