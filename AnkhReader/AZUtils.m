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
	NSLog(@"ERR: %@", error);
}

// Returns the URL to the application's Documents directory.
+(NSURL *)applicationDocumentsDirectory {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
