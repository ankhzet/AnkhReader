//
//  AZRTabProvider.h
//  AnkhReader
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AZRTabsGroup;
@interface AZRTabProvider : NSObject
@property (nonatomic, weak) AZRTabsGroup *tabs;
@property IBOutlet NSView *view;
@property (nonatomic) NSDictionary *navData;

+ (instancetype) tabProviderForTabs:(AZRTabsGroup *)tabsGroup withTabView:(NSTabView *)tvTabs;
- (id) initForTabs:(AZRTabsGroup *)tabsGroup withTabView:(NSTabView *)tvTabs;

- (NSString *) tabIdentifier;

- (void) navigateTo:(NSDictionary *)data;
- (void) show;

@end
