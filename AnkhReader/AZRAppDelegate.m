//
//  AZRAppDelegate.m
//  AnkhReader
//
//  Created by Ankh on 20.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAppDelegate.h"





@interface AZRAppDelegate () {
}


@end

@implementation AZRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

}

- (void) synkNotification:(NSNotification *)notification {
}

- (IBAction)showUpdates:(id)sender {
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
- (IBAction)saveAction:(id)sender {
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

@end
