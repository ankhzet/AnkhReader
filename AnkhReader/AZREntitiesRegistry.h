//
//  AZREntitiesRegistry.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AZREntity;
@interface AZREntitiesRegistry : NSObject

// yeah, it's a singletone /=
+ (id) getInstance;

- (id) registerEntity:(AZREntity *)entity;
- (id) hasEntity:(NSNumber *)uid withType:(NSString *)type;
- (NSDictionary *) entitiesOfType:(NSString *)entityType;

+ (id) hasEntity:(NSNumber *)uid withType:(NSString *)type;
+ (NSDictionary *) entitiesOfType:(NSString *)entityType;

@end
