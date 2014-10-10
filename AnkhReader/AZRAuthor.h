//
//  AZRAuthor.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntity.h"

@interface AZRAuthor : AZREntity

@property (nonatomic, retain) NSString *fio;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSNumber *updated;
@property (nonatomic, retain) NSNumber *freq;

@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) NSSet *pages;
@property (nonatomic, retain) NSSet *updates;

+ (NSDictionary *) authorsFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry;

@end
