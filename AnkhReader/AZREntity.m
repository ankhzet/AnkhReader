//
//  AZREntity.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntity.h"
#import "AZREntitiesRegistry.h"
#import "AZDataProxyContainer.h"

@implementation AZREntity
@dynamic uid;
@synthesize registry = _registry;

+ (NSString *) type {
	return nil;
}

+ (NSString *) CoreDataEntityName {
	return [[[[self type]
						stringByReplacingOccurrencesOfString:@"-" withString:@" "]
					 capitalizedString]
					stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (instancetype) newEntity:(NSNumber *)uid inRegistry:(AZREntitiesRegistry *)registry {
	AZREntity *entity = [NSEntityDescription insertNewObjectForEntityForName:[self CoreDataEntityName]
																										inManagedObjectContext:[[AZDataProxyContainer getInstance] managedObjectContext]];

	entity.uid = uid;
	return [registry registerEntity:entity];
}

+ (instancetype) entity:(NSNumber *)uid inRegistry:(AZREntitiesRegistry *)registry {
	return [registry hasEntity:uid withType:[self type]];
}

+ (instancetype) entity:(NSNumber *)uid fromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {
	AZREntity *entity = [registry hasEntity:uid withType:[self type]];

	if (!entity)
		entity = [self newEntity:uid inRegistry:registry];

	if (json)
		[entity aquireDataFromJSON:json inRegistry:registry];

	return entity;
}

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry {

}

@end

@implementation AZREntity (Debug)

- (NSString *) description {
	return [NSString stringWithFormat:@"{@%@:%@}", [[self class] type], self.uid];
}

@end
