//
//  AZRGroup.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntity.h"

@class AZRAuthor;
@interface AZRGroup : AZREntity

@property (nonatomic, weak) AZRAuthor *author;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic) NSUInteger index;
@property (nonatomic) BOOL inlined;

@property (nonatomic) NSMutableDictionary *pages;
@property (nonatomic) NSMutableDictionary *updates;

@end
