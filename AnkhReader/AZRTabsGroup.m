//
//  AZRTabsGroup.m
//  AnkhReader
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRTabsGroup.h"
#import "AZRTabProvider.h"

@implementation AZRTabsGroup {
	NSMutableDictionary *tabs;
	NSTabView *tvTabs;
}

- (id)init {
	if (!(self = [super init]))
		return self;

	tabs = [NSMutableDictionary dictionary];
	return self;
}

- (id) initWithTabView:(NSTabView *)tabView {
	if (!(self = [self init]))
		return self;

	tvTabs = tabView;
	return self;
}

- (AZRTabProvider *) registerTab:(Class)tabProviderClass {
	AZRTabProvider *tabProvider = [tabProviderClass tabProviderForTabs:self withTabView:tvTabs];

	tabs[[tabProvider tabIdentifier]] = tabProvider;
	return tabProvider;
}

- (AZRTabProvider *) tabByID:(NSString *)identifier {
	return tabs[identifier];
}

- (void) navigateTo:(NSString *)tabIdentifier withNavData:(id)data {
	AZRTabProvider *tab = [self tabByID:tabIdentifier];

	if (self.delegate)
		if (![self.delegate tabGroup:self navigateTo:tab])
			return;

	[tvTabs selectTabViewItemWithIdentifier:tabIdentifier];

	[tab navigateTo:data];

	if (self.delegate) [self.delegate tabGroup:self navigatedTo:tab];
}

@end
