//
//  AZRHeaderCellView.h
//  AnkhReader
//
//  Created by Ankh on 22.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRConfigurableTableCellView.h"

@protocol AZRHeaderCellDelegate <NSObject>
- (void) headerClicked;
@end

@interface AZRHeaderCellView : AZRConfigurableTableCellView

@property (weak) IBOutlet NSButton *bAll;

- (IBAction) click:(id)sender;

@end
