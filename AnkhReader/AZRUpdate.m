//
//  AZRUpdate.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntities.h"

@implementation AZRUpdate
@synthesize kind, value, pub, delta;
@dynamic author, group, page;

+ (NSString *) type {
	static NSString *const UpdateTypeIdentifier = @"update";
	return UpdateTypeIdentifier;
}

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	ASSIGN_IF_NOTNULL(self.author, REGISTERED_ENTITY(AZRAuthor, registry, json, @"authorID"));
	ASSIGN_IF_NOTNULL(self.group, REGISTERED_ENTITY(AZRGroup, registry, json, @"groupID"));
	ASSIGN_IF_NOTNULL(self.page, REGISTERED_ENTITY(AZRPage, registry, json, @"pageID"));

	ASSIGN_IF_NOTNULL(self.kind, JSON_I(json, @"kind"));

	NSDictionary *desc = JSON_O(json, @"description");
	ASSIGN_IF_NOTNULL(self.value, JSON_I(desc, @"size"));
	ASSIGN_IF_NOTNULL(self.delta, JSON_I(desc, @"delta"));
	ASSIGN_IF_NOTNULL(self.pub, JSON_S(desc, @"pubdate"));
}

- (BOOL) isNew {
	return [self.value integerValue] == [self.delta integerValue];
}

- (BOOL) isDeleted {
	return ![self.value integerValue];
}

+ (NSDictionary *) fetchUpdates:(NSArray *)updates inRegistry:(AZREntitiesRegistry *)registry {
	NSMutableDictionary *authorsToLoad = [NSMutableDictionary dictionary];
	NSMutableDictionary *groupsToLoad = [NSMutableDictionary dictionary];
	NSMutableDictionary *pagesToLoad = [NSMutableDictionary dictionary];
	for (NSDictionary *updateJSON in updates) {
		NSNumber *authorID = [updateJSON objectForKey:@"authorID"];
		NSNumber *groupID = [updateJSON objectForKey:@"groupID"];
		NSNumber *pageID = [updateJSON objectForKey:@"pageID"];

		AZRAuthor *author = [registry hasEntity:authorID withType:[AZRAuthor type]];
		if (!author) authorsToLoad[authorID] = updateJSON;

		AZRGroup *group = [registry hasEntity:groupID withType:[AZRGroup type]];
		if (!group) groupsToLoad[groupID] = updateJSON;

		AZRPage *page = [registry hasEntity:pageID withType:[AZRPage type]];
		if (!page) pagesToLoad[pageID] = updateJSON;

	}

	for (NSNumber *authorID in [authorsToLoad allKeys])
    [registry registerEntity:[AZRAuthor entity:authorID fromJSON:authorsToLoad[authorID] inRegistry:registry]];

	for (NSNumber *groupID in [groupsToLoad allKeys])
    [registry registerEntity:[AZRGroup entity:groupID fromJSON:groupsToLoad[groupID] inRegistry:registry]];

	for (NSNumber *pageID in [pagesToLoad allKeys])
    [registry registerEntity:[AZRPage entity:pageID fromJSON:pagesToLoad[pageID] inRegistry:registry]];

	NSMutableDictionary *allData = [NSMutableDictionary dictionaryWithCapacity:[updates count]];
	for (NSDictionary *updateJSON in updates) {
		AZRUpdate *update = [AZRUpdate entity:[updateJSON objectForKey:@"uid"] fromJSON:updateJSON inRegistry:registry];
		allData[update.uid] = update;
	}
	return allData;
}

- (NSString *) description {
	return [NSString stringWithFormat:@"{Update@%@: [%@] %@ (%@), %@, %@ from %@ }", self.uid, self.kind, self.value, self.delta, self.author, self.page, self.group];
}

@end
