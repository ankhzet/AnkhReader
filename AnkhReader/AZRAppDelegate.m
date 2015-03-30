//
//  AZRAppDelegate.m
//  AnkhReader
//
//  Created by Ankh on 20.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAppDelegate.h"

#import "AZSynkEnabledStorage.h"
#import "AZDataProxyContainer.h"

#import "AZRTabsCommons.h"

@interface AZRAppDelegate () {
	NSDictionary *tabMapping;
}

@end

@implementation AZRAppDelegate

- (void) registerTabs {
	AZSynkEnabledStorage *storage = [AZSynkEnabledStorage storageWithParameters:@{
																																								kDPParameterModelName:@"AnkhReader",
																																								kDPParameterStorageFile:@"AnkhReader.sqlite",
																																								}];

	[AZDataProxyContainer initInstance:storage];

	tabMapping = @{
								 @1: AZRUIDLoginTab,
								 @3: AZRUIDUpdatesTab,
								 @4: AZRUIDVersionsTab,
								 @2: AZRUIDPreferencesTab,
								 @5: AZRUIDReaderTab,
								 };

	[self registerTab:[AZRLoginTab class]];
	[self registerTab:[AZRUpdatesTab class]];
	[self registerTab:[AZRVersionsTab class]];
	[self registerTab:[AZRReaderTab class]];
	[self registerTab:[AZRPreferencesTab class]];

	[storage synkToggled];
}

- (NSString *) initialTab {
	return AZRUIDLoginTab;
}

- (void) tabGroup:(AZTabsGroup *)tabGroup navigatedTo:(AZTabProvider *)tab {
	[super tabGroup:tabGroup navigatedTo:tab];

//	for (NSMenuItem *item in self.mNavMenu.itemArray)
//		if (!!item.tag)
//			[item setEnabled:![tabMapping[@(item.tag)] isEqualToString:tab.tabIdentifier]];
}

- (IBAction)showUpdates:(id)sender {
	[self.tabsGroup navigateTo:AZRUIDUpdatesTab withNavData:nil];
}

- (IBAction)showPreferences:(id)sender {
	[self.tabsGroup navigateTo:AZRUIDPreferencesTab withNavData:nil];
}

- (IBAction)actionShowLoginTab:(id)sender {
	[self.tabsGroup navigateTo:AZRUIDLoginTab withNavData:@(YES)];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender {
	NSError *error = nil;

	if (![[[AZDataProxyContainer getInstance] managedObjectContext] commitEditing]) {
		NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
	}

	if (![[[AZDataProxyContainer getInstance] managedObjectContext] save:&error]) {
		[[NSApplication sharedApplication] presentError:error];
	}
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

- (void) applicationWillTerminate:(NSNotification *)notification {
	[self saveAction:nil];
}

@end
