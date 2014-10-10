//
//  AZRTabsGroup.h
//  AnkhReader
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AZRTabProvider, AZRTabsGroup;

@protocol AZRTabsGroupDelegate <NSObject>

- (BOOL) tabGroup:(AZRTabsGroup *)tabGroup navigateTo:(AZRTabProvider *)tab;
- (void) tabGroup:(AZRTabsGroup *)tabGroup navigatedTo:(AZRTabProvider *)tab;

@end

@interface AZRTabsGroup : NSObject
@property (nonatomic, weak) id<AZRTabsGroupDelegate> delegate;

- (id) initWithTabView:(NSTabView *)tabView;


- (AZRTabProvider *) registerTab:(Class)tabProvider;
- (AZRTabProvider *) tabByID:(NSString *)identifier;

- (void) navigateTo:(NSString *)tabIdentifier withNavData:(id)data;


@end
