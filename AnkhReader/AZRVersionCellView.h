//
//  AZRVersionCellView.h
//  AnkhReader
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRConfigurableTableCellView.h"

@interface AZRVersionCellView : AZRConfigurableTableCellView

@property (weak) IBOutlet NSTextField *tfTimestamp;
@property (weak) IBOutlet NSTextField *tfSize;
@property (weak) IBOutlet NSTextField *tfSizeZipped;

@end
