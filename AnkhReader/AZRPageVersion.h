//
//  AZRPageVersions.h
//  AnkhReader
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRPage.h"

@interface AZRPageVersion : AZREntity

@property (nonatomic, retain) AZRPage *page;

@property (nonatomic, retain) NSNumber *timestamp;
@property (nonatomic, retain) NSNumber *size;
@property (nonatomic, retain) NSNumber *zipped;

+ (NSDictionary *) pageVersionsFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry;

@end
