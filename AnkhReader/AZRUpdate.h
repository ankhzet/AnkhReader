//
//  AZRUpdate.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZREntity.h"

NS_ENUM(NSUInteger, AZRUpdateKind) {
	AZRUpdateKindPageSizeDiff  = 0,
	AZRUpdateKindPageReGrouped = 1,
	AZRUpdateKindDelete        = 2,
	AZRUpdateKindGroupInline   = 3,
	AZRUpdateKindGroupDeleted  = 4,
	AZRUpdateKindPageAdded     = 5,
	AZRUpdateKindPageDeleted   = 6,
	AZRUpdateKindRenamed       = 7,
};

@class AZRPage, AZRGroup, AZRAuthor;
@interface AZRUpdate : AZREntity

@property (nonatomic, weak) AZRAuthor *author;
@property (nonatomic, weak) AZRGroup *group;
@property (nonatomic, weak) AZRPage *page;

@property (nonatomic) NSNumber *kind;

@property (nonatomic) NSNumber *size;
@property (nonatomic) NSNumber *delta;
@property (nonatomic) NSString *pub;

- (BOOL) isNew;
- (BOOL) isDeleted;

@end
