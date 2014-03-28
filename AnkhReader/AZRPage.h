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

@property (nonatomic, weak) AZRAuthor *author;
@property (nonatomic, weak) AZRGroup *group;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic) NSUInteger updated;
@property (nonatomic) NSUInteger size;

@property (nonatomic) NSMutableDictionary *updates;

@end
