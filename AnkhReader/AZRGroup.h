//
//  AZRGroup.h
//  AnkhReader
//
//  Created by Ankh on 09.10.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AZREntity.h"

@class AZRAuthor, AZRPage, AZRUpdate;

@interface AZRGroup : AZREntity

@property (nonatomic, retain) AZRAuthor *author;

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * descr;

@property (nonatomic) BOOL inlined;

@property (nonatomic, retain) NSSet *pages;
@property (nonatomic, retain) NSSet *updates;

@end

@interface AZRGroup (CoreDataGeneratedAccessors)

- (void)addPagesObject:(AZRPage *)value;
- (void)removePagesObject:(AZRPage *)value;
- (void)addPages:(NSSet *)values;
- (void)removePages:(NSSet *)values;

- (void)addUpdatesObject:(AZRUpdate *)value;
- (void)removeUpdatesObject:(AZRUpdate *)value;
- (void)addUpdates:(NSSet *)values;
- (void)removeUpdates:(NSSet *)values;

@end
