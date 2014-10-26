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

@interface AZRAppDelegate () <AZTabsGroupDelegate> {
	AZTabsGroup *tabs;
}

@property (weak) IBOutlet NSToolbar *tbToolbar;
@property (weak) IBOutlet NSTabView *tvTabs;

@end

@implementation AZRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	AZSynkEnabledStorage *storage = [AZSynkEnabledStorage storageWithParameters:@{
																																								kDPParameterModelName:@"AnkhReader",
																																								kDPParameterStorageFile:@"AnkhReader.sqlite",
																																								}];

	[AZDataProxyContainer initInstance:storage];
	[storage subscribeForUpdateNotifications:self selector:@selector(synkNotification:)];

	tabs = [[AZTabsGroup alloc] initWithTabView:self.tvTabs];
	[tabs registerTab:[AZRLoginTab class]];
	[tabs registerTab:[AZRUpdatesTab class]];
	[tabs registerTab:[AZRVersionsTab class]];
	[tabs registerTab:[AZRPreferencesTab class]];
	tabs.delegate = self;

	[tabs navigateTo:AZRUIDLoginTab withNavData:nil];

	[storage synkToggled];
}

- (NSToolbarItem *) toolbar:(NSToolbar *)toolbar itemWithIdentifier:(NSString *)identifier {
	NSArray *items = [toolbar items];
	for (NSToolbarItem *i in items)
		if ([[i itemIdentifier] isEqualToString:identifier])
			return i;

	return nil;
}

- (BOOL) tabGroup:(AZTabsGroup *)tabGroup navigateTo:(AZTabProvider *)tab {
	NSToolbarItem *navTo = [self toolbar:self.tbToolbar itemWithIdentifier:[tab tabIdentifier]];
	if (navTo)
		[navTo setEnabled:NO];

	return YES;
}

- (void) tabGroup:(AZTabsGroup *)tabGroup navigatedTo:(AZTabProvider *)tab {
	NSToolbarItem *navTo = [self toolbar:self.tbToolbar itemWithIdentifier:[tab tabIdentifier]];
	if (navTo)
		[navTo setEnabled:YES];

	[self.tbToolbar setSelectedItemIdentifier:[tab tabIdentifier]];
}

- (void) synkNotification:(NSNotification *)notification {
}

- (IBAction)showUpdates:(id)sender {
	[tabs navigateTo:AZRUIDUpdatesTab withNavData:nil];
}

- (IBAction)showPreferences:(id)sender {
	[tabs navigateTo:AZRUIDPreferencesTab withNavData:nil];
}

- (IBAction)actionShowLoginTab:(id)sender {
	[tabs navigateTo:AZRUIDLoginTab withNavData:@(YES)];
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
