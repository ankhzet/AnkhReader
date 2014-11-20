//
//  AZRUpdatesDataSource.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AZRHeaderCellView.h"
#import "AZRUpdateTableCellView.h"

@protocol AZRUpdatesDataSourceDelegate <AZRHeaderCellDelegate, AZRUpdateCellDelegate> @end

@class AZREntitiesRegistry;
@interface AZRUpdatesDataSource : NSObject <NSOutlineViewDataSource, NSOutlineViewDelegate, AZRUpdatesDataSourceDelegate>

@property (nonatomic) NSDictionary *data;
@property (nonatomic) NSDictionary *uPages;
@property (nonatomic) id<AZRUpdatesDataSourceDelegate> delegate;

@property (nonatomic) BOOL groupped;
@property (nonatomic) BOOL withRenamed;

- (void) filterByAuthor:(NSNumber *)authorID;

@end
