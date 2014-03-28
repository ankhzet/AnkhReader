//
//  AZRAuthor.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntity.h"

@interface AZRAuthor : AZREntity

@property (nonatomic) NSString *fio;
@property (nonatomic) NSString *link;
@property (nonatomic) NSNumber *updated;
@property (nonatomic) NSNumber *updateFreq;

@property (nonatomic) NSMutableDictionary *groups;
@property (nonatomic) NSMutableDictionary *pages;
@property (nonatomic) NSMutableDictionary *updates;

+ (NSDictionary *) authorsFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry;

@end
