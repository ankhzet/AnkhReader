//
//  AZREntitiesRegistry.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntitiesRegistry.h"
#import "AZREntity.h"

#import "AZDataProxyContainer.h"

@implementation AZREntitiesRegistry {
//	NSMutableDictionary *registry;
}

+ (id) getInstance {
	static AZREntitiesRegistry *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
    instance = [AZREntitiesRegistry new];
	});

	return instance;
}

- (id)init {
	if (!(self = [super init]))
		return self;

//	registry = [NSMutableDictionary dictionary];
	return self;
}

- (id) fetch:(NSString *)type entity:(NSNumber *)uid {
	type = [type capitalizedString];
	NSManagedObjectContext *context = [[AZDataProxyContainer getInstance] managedObjectContext];

	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:type
																						inManagedObjectContext:context];
	[fetchRequest setEntity:entity];

	if (uid) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@",uid];

		[fetchRequest setPredicate:predicate];

		[fetchRequest setFetchLimit:1];
	}

	NSError *_error = nil;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&_error];
	if (fetchedObjects == nil) {
		// Handle the error
		return nil;
	}

	if (uid)
		return [fetchedObjects lastObject];

	NSMutableDictionary *fetch = [NSMutableDictionary dictionaryWithCapacity:[fetchedObjects count]];
	for (AZREntity *entity in fetchedObjects)
		fetch[entity.uid] = entity;

	return fetch;
}

- (id) hasEntity:(NSNumber *)uid withType:(NSString *)type {
	return [self fetch:type entity:uid];//registry[type] ? registry[type][uid] : nil;
}

- (id) registerEntity:(AZREntity *)entity {
	NSString *entityType = [[entity class] type];

	AZREntity *old = [self hasEntity:entity.uid withType:entityType];
	if (old)
		return old;

//	NSMutableDictionary *entities = registry[entityType] ? registry[entityType] : (registry[entityType] = [NSMutableDictionary dictionary]);
//
//	entities[entity.uid] = entity;
	entity.registry = self;
	return entity;
}

- (NSDictionary *) entitiesOfType:(NSString *)entityType {
	return [self fetch:entityType entity:nil];//registry[entityType];
}

+ (id) hasEntity:(NSNumber *)uid withType:(NSString *)type {
	return [[self getInstance] hasEntity:uid withType:type];
}

+ (NSDictionary *) entitiesOfType:(NSString *)entityType {
	return [[self getInstance] entitiesOfType:entityType];
}


@end
