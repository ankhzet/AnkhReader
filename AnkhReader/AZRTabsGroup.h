//
//  AZRTabsGroup.h
//  AnkhReader
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AZRTabProvider;

@interface AZRTabsGroup : NSObject

- (id) initWithTabView:(NSTabView *)tabView;


- (AZRTabProvider *) registerTab:(Class)tabProvider;
- (AZRTabProvider *) tabByID:(NSString *)identifier;

- (void) navigateTo:(NSString *)tabIdentifier withNavData:(id)data;


@end
