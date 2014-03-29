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
	AZRTabsGroup *tabs;
}

@property (weak) IBOutlet NSTabView *tvTabs;

@end

@implementation AZRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

	tabs = [[AZRTabsGroup alloc] initWithTabView:self.tvTabs];
	[tabs registerTab:[AZRLoginTab class]];
	[tabs registerTab:[AZRUpdatesTab class]];
	[tabs registerTab:[AZRVersionsTab class]];

	AZSynkEnabledStorage *storage = [AZSynkEnabledStorage storageWithParameters:@{
																																								kDPParameterModelName:@"AnkhReader",
																																								kDPParameterStorageFile:@"AnkhReader.sqlite",
																																								}];

	[AZDataProxyContainer initInstance:storage];
	[storage subscribeForUpdateNotifications:self selector:@selector(synkNotification:)];
	[storage synkToggled];

	[tabs navigateTo:AZRUIDLoginTab withNavData:nil];
}

- (void) synkNotification:(NSNotification *)notification {
}

- (IBAction)showUpdates:(id)sender {
	[tabs navigateTo:AZRUIDUpdatesTab withNavData:nil];
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

@end
