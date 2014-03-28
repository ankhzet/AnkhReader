//
//  AZRConfigurableTableCellView.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AZRConfigurableTableCellView : NSTableCellView

- (void) configureForEntity:(id)entity inOutlineView:(NSOutlineView *)view;

@end
