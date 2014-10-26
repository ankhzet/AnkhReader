//
//  AZUtils.m
//  AnkhZet
//
//  Created by Ankh on 01.01.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZUtils.h"

@interface AZUtils ()
@end

@implementation AZUtils

#pragma mark - Common utils

+ (void) notifyErrorMsg:(NSString *)error {
	NSString *okButton = NSLocalizedString(@"Ok", @"Ok button title");
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setMessageText:@"Error"];
	[alert setInformativeText:error];
	[alert addButtonWithTitle:okButton];

	NSLog(@"ERR: %@", error);
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger answer = [alert runModal];

		if (answer == NSAlertAlternateReturn) {
		}
	});

}

// Returns the URL to the application's Documents directory.
+(NSURL *)applicationDocumentsDirectory {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
