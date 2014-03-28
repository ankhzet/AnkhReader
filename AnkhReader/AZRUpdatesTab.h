//
//  AZRUpdatesTab.h
//  AnkhReader
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRTabProvider.h"

@interface AZRUpdatesTab : AZRTabProvider

@property (weak) IBOutlet NSTableView *authorsTableView;
@property (weak) IBOutlet NSOutlineView *outlineView;

@end
