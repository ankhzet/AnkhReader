//
//  AZREntity.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AZREntitiesRegistry;
@interface AZREntity : NSObject
@property (nonatomic) NSNumber *uid;
@property (nonatomic, weak) AZREntitiesRegistry *registry;

+ (NSString *) type;
+ (instancetype) newEntity:(NSNumber *)uid inRegistry:(AZREntitiesRegistry *)registry;
+ (instancetype) entity:(NSNumber *)uid inRegistry:(AZREntitiesRegistry *)registry;
+ (instancetype) entity:(NSNumber *)uid fromJSON:(NSDictionary *)json inRegistry:(AZREntitiesRegistry *)registry;

@end
