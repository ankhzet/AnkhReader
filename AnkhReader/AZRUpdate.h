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

@property (nonatomic, retain) AZRAuthor *author;
@property (nonatomic, retain) AZRGroup *group;
@property (nonatomic, retain) AZRPage *page;

@property (nonatomic, retain) NSNumber *kind;
@property (nonatomic, retain) NSNumber *value;
@property (nonatomic, retain) NSNumber *delta;

@property (nonatomic, retain) NSString *pub;

- (BOOL) isNew;
- (BOOL) isDeleted;

+ (NSDictionary *) fetchUpdates:(NSArray *)updates inRegistry:(AZREntitiesRegistry *)registry;

@end
