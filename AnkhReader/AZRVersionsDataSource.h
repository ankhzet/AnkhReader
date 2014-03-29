//
//  AZRVersionsDataSource.h
//  AnkhReader
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZRVersionsDataSource : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic) NSArray *data;

- (void) setOrderedData:(NSDictionary *)data;

@end
