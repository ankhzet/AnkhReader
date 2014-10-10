//
//  AZRPage.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntity.h"

@class AZRAuthor, AZRGroup;
@interface AZRPage : AZREntity

@property (nonatomic, retain) AZRAuthor *author;
@property (nonatomic, retain) AZRGroup *group;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *descr;
@property (nonatomic, retain) NSNumber *updated;
@property (nonatomic, retain) NSNumber *size;

@property (nonatomic, retain) NSSet *updates;
@property (nonatomic, retain) NSSet *versions;


+ (NSDictionary *) pagesFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry;


@end
