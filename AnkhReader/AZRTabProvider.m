//
//  AZRTabProvider.m
//  AnkhReader
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRTabProvider.h"

@implementation AZRTabProvider {
	__weak NSTabViewItem *tab;
	__weak NSTabView *tabView;
}

+ (instancetype) tabProviderForTabs:(AZRTabsGroup *)tabsGroup withTabView:(NSTabView *)tvTabs {
	return [[self alloc] initForTabs:tabsGroup withTabView:tvTabs];
}

- (id) initForTabs:(AZRTabsGroup *)tabsGroup withTabView:(NSTabView *)tvTabs {
	if (!(self = [self init]))
		return self;

	_tabs = tabsGroup;

	tabView = tvTabs;
	NSTabViewItem *newTab = [[NSTabViewItem alloc] initWithIdentifier:[self tabIdentifier]];
	[tabView addTabViewItem:newTab];
	tab = newTab;

	return self;
}

- (NSString *) tabIdentifier {
	return nil;
}

- (BOOL) loadNIB {
	NSString *nibName = [NSString stringWithFormat:@"tab%@",[[self tabIdentifier] capitalizedString]];

	[[NSBundle mainBundle] loadNibNamed:nibName owner:self topLevelObjects:nil];

	if (!self.view)
		[NSException raise:@"AZRTabProviderViewLoadError" format:@"Did you forget to create tab's view named \"%@.xib\" or set its file owner to this tab class?",nibName];

	return !!self.view;
}

- (void) navigateTo:(NSDictionary *)data {
	if (!self.view)
		[self loadNIB];

	NSView *viewInTab = [tab view];
	[viewInTab setSubviews:@[self.view]];
	[self.view setFrameSize:tabView.frame.size];
	self.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	self.navData = data;
	[self show];
}

- (void) show {

}

@end
