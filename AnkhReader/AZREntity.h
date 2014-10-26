//
//  AZREntity.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ClientAPICore/AZClientAPICore.h>

#define ASSIGN_IF_NOTNULL(_property, _new_value) \
(_property) = (!_new_value) ? (_property) : (_new_value)

#define REGISTERED_ENTITY(_type, _registry, _json, _collumn) \
	[(_registry) hasEntity:[(_json) objectForKey:(_collumn)] withType:[_type type]]

@class AZREntitiesRegistry;
@interface AZREntity : NSManagedObject
@property (nonatomic, weak) AZREntitiesRegistry *registry;

@property (nonatomic, retain) NSNumber *uid;

+ (NSString *) type;
+ (instancetype) newEntity:(NSNumber *)uid inRegistry:(AZREntitiesRegistry *)registry;
+ (instancetype) entity:(NSNumber *)uid inRegistry:(AZREntitiesRegistry *)registry;
+ (instancetype) entity:(NSNumber *)uid fromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry;

- (void) aquireDataFromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry;

@end
