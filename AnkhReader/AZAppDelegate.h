//
//  AZAppDelegate.h
//  ErgoProxy
//
//  Created by Ankh on 27.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AZTabsCommons.h"

@interface AZAppDelegate : NSObject <NSApplicationDelegate, AZTabsGroupDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic) AZTabsGroup *tabsGroup;


- (void) registerTabs;
- (NSString *) initialTab;
- (AZTabProvider *) registerTab:(Class)tabProviderClass;

@end
