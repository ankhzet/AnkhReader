//
//  AZRUser.h
//  AnkhReader
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntity.h"

@interface AZRUser : AZREntity

@property (nonatomic) NSString *nickname;

+ (NSDictionary *) usersFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry;

@end
