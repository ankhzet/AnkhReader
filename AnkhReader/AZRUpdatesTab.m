//
//  AZRUpdatesTab.m
//  AnkhReader
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRUpdatesTab.h"
#import "AZRTabsCommons.h"

#import "AZRAuthorsDataSource.h"
#import "AZRUpdatesDataSource.h"

#import "AZRAPILayer.h"
#import "AZRAPIAction.h"

#import "AZREntitiesRegistry.h"

#import "AZRUpdate.h"
#import "AZRPage.h"
#import "AZRAuthor.h"

@interface AZRUpdatesTab () <AZRAuthorsTableDelegate, AZRUpdatesDataSourceDelegate> {
	AZRAuthorsDataSource *authors;
	AZRUpdatesDataSource *updates;
}

@end

@implementation AZRUpdatesTab

- (NSString *) tabIdentifier {
	return AZRUIDUpdatesTab;
}

- (void) show {
	if (!updates) {
		updates = [AZRUpdatesDataSource new];
		[updates setDelegate:self];
		[self.outlineView setDataSource:updates];
		[self.outlineView setDelegate:updates];
	}
	if (!authors) {
		authors = [AZRAuthorsDataSource new];
		[authors setDelegate:self];
		[self.authorsTableView setDataSource:authors];
		[self.authorsTableView setDelegate:authors];
	}

	[self retriveAuthorsList];
}

- (void) retriveAuthorsList {
	NSDictionary *regAuthors = [[AZREntitiesRegistry getInstance] entitiesOfType:[AZRAuthor type]];
	if (regAuthors.count) {
		authors.data = regAuthors;
		[self.authorsTableView reloadData];
		[self retriveUpdates];

		return;
	}


	AZRAPIAction *authorAction = [[AZRAPILayer new] action:@"authors"];
	[authorAction setParameters:@{@"collumns": @"id,fio,link,time"}];

	[[[authorAction
		 error:^(AZRAPIAction *action, NSString *error) {
			 NSLog(@"Authors not aquired: %@", error);
			 [action execute];
		 }] success:^(AZRAPIAction *action, id data) {
			 dispatch_async(dispatch_get_main_queue(), ^{
				 authors.data = [AZRAuthor authorsFromJSON:data inRegistry:[AZREntitiesRegistry getInstance]];
				 [self.authorsTableView reloadData];

				 [self retriveUpdates];
			 });
		 }] execute];
}

- (void) retriveUpdates {
	[updates filterByAuthor:nil];

	NSDictionary *regUpdates = [[AZREntitiesRegistry getInstance] entitiesOfType:[AZRUpdate type]];
	if (regUpdates.count) {
		updates.data = regUpdates;
		[self.outlineView reloadData];
		[self.outlineView expandItem:nil expandChildren:YES];
		[authors rearrangeBy:AUTHOR_UPDATES_COLLUMN];
		[self.authorsTableView reloadData];

		return;
	}

	AZRAPIAction *updatesAction = [[AZRAPILayer new] action:@"updates"];
	[updatesAction setParameters:@{@"collumns": @"uid,kind,pageID,authorID,groupID,title,group,description,size,delta,pubdate"}];

	[[[updatesAction
		 error:^(AZRAPIAction *action, NSString *error) {
			 NSLog(@"Updates not aquired: %@", error);
			 //			 [action execute];
		 }] success:^(AZRAPIAction *action, id data) {
			 dispatch_async(dispatch_get_main_queue(), ^{
				 [updates fetchUpdates:data inRegistry:[AZREntitiesRegistry getInstance]];
				 [self.outlineView reloadData];
				 [self.outlineView expandItem:nil expandChildren:YES];

				 [authors rearrangeBy:AUTHOR_UPDATES_COLLUMN];
				 [self.authorsTableView reloadData];

			 });
		 }] execute];
}

- (void) objectSelected:(id)object {
	if ([object isKindOfClass:[AZRAuthor class]]) {
		[updates filterByAuthor:[object uid]];
		[self.outlineView reloadData];
		[self.outlineView expandItem:nil expandChildren:YES];
	}
}

- (void) headerClicked {
	[updates filterByAuthor:nil];
	[self.outlineView reloadData];
	[self.outlineView expandItem:nil expandChildren:YES];

}

- (void) updateClicked:(id)entity {
	AZRUpdate *update = entity;
	[self.tabs navigateTo:AZRUIDVersionsTab withNavData:@{@0: update.page.uid}];
}

@end
