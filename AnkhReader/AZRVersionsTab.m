//
//  AZRVersionsTab.m
//  AnkhReader
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRVersionsTab.h"
#import "AZRTabsCommons.h"

#import "AZRAPIAction.h"
#import "AZRAPILayer.h"

@implementation AZRVersionsTab

- (NSString *) tabIdentifier {
	return AZRUIDVersionsTab;
}

- (void) show {
	NSNumber *uid = self.navData[@0];

	[self pickPage:[uid unsignedIntegerValue]];
}


- (void) pickPage:(NSUInteger)uid {
	AZRAPIAction *versionsAction = [[AZRAPILayer new] action:@"page-versions"];
	[versionsAction setParameters:@{@"page": @(uid)}];

	[[[versionsAction
		 error:^(AZRAPIAction *action, NSString *error) {
			 NSLog(@"Versions not aquired: %@", error);
			 [action execute];
		 }] success:^(AZRAPIAction *action, id data) {
			 dispatch_async(dispatch_get_main_queue(), ^{
				 NSLog(@"versions: %@", data);
				 //				 authors = [AZRAuthorsDataSource new];
				 //				 authors.data = [AZRAuthor authorsFromJSON:data inRegistry:ankhRegistry];
				 //				 [tvAuthors setDataSource:authors];
				 //				 [tvAuthors setDelegate:authors];
				 //				 [authors setDelegate:self];
			 });
		 }] execute];
	
}

@end
