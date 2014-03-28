//
//  AZRUpdateTableCellView.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRConfigurableTableCellView.h"

@protocol AZRUpdateCellDelegate <NSObject>
- (void) updateClicked:(id)entity;
@end


@interface AZRUpdateTableCellView : AZRConfigurableTableCellView
@property (weak) IBOutlet NSTextField *tfTitle;
@property (weak) IBOutlet NSTextField *tfDelta;
@property (weak) IBOutlet NSTextField *tfTime;

@end
