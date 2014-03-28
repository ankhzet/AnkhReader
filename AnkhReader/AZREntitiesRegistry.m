//
//  AZREntitiesRegistry.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntitiesRegistry.h"
#import "AZREntity.h"

@implementation AZREntitiesRegistry {
	NSMutableDictionary *registry;
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

	registry = [NSMutableDictionary dictionary];
	return self;
}

- (id) hasEntity:(NSNumber *)uid withType:(NSString *)type {
	return registry[type] ? registry[type][uid] : nil;
}

- (id) registerEntity:(AZREntity *)entity {
	NSString *entityType = [[entity class] type];

	AZREntity *old = [self hasEntity:entity.uid withType:entityType];
	if (old)
		return old;

	NSMutableDictionary *entities = registry[entityType] ? registry[entityType] : (registry[entityType] = [NSMutableDictionary dictionary]);

	entities[entity.uid] = entity;
	entity.registry = self;
	return entity;
}

- (NSDictionary *) entitiesOfType:(NSString *)entityType {
	return registry[entityType];
}

@end
