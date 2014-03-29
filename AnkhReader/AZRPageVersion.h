//
//  AZRPageVersions.h
//  AnkhReader
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRPage.h"

@interface AZRPageVersion : AZREntity

@property (nonatomic, weak) AZRPage *page;

@property (nonatomic) NSUInteger timestamp;
@property (nonatomic) NSUInteger size;
@property (nonatomic) NSUInteger zipped;

+ (NSDictionary *) pageVersionsFromJSON:(NSArray *)json inRegistry:(AZREntitiesRegistry *)registry;

@end
