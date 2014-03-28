//
//  AZRAuthorTableCellView.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AZRConfigurableTableCellView.h"

@interface AZRAuthorTableCellView : AZRConfigurableTableCellView
@property (weak) IBOutlet NSTextField *tfFIO;
@property (weak) IBOutlet NSTextField *tfLink;
@property (weak) IBOutlet NSTextField *tfUpdates;

@end
