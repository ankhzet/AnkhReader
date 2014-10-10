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

#import "AZJSONRequest.h"

#import "AZREntities.h"

#import "AZAPIProvider.h"
#import "AZRAuthorsAPI.h"
#import "AZRUpdatesAPI.h"

@interface AZRUpdatesTab () <AZRAuthorsTableDelegate, AZRUpdatesDataSourceDelegate> {
	AZRAuthorsDataSource *authors;
	AZRUpdatesDataSource *updates;

	AZRAuthorsAPI *authorsAPI;
	AZRUpdatesAPI *updatesAPI;
}

@end

@implementation AZRUpdatesTab

- (id)init {
	if (!(self = [super init]))
		return self;

	authorsAPI = [[AZAPIProvider getInstance] API:[AZRAuthorsAPI class]];
	updatesAPI = [[AZAPIProvider getInstance] API:[AZRUpdatesAPI class]];
	return self;
}

- (NSString *) tabIdentifier {
	return AZRUIDUpdatesTab;
}

- (void) show {
	if (!updates) {
		updates = [AZRUpdatesDataSource new];
		updates.groupped = YES;
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
	[authorsAPI aquireAuthors:@{@"collumns": @"id,fio,link,time"} withCompletion:^(NSDictionary *_authors) {
		if (authors.data == _authors)
			return;

		authors.data = _authors;

		[AZClientAPI onMain:^{
			[self.authorsTableView reloadData];
			[self retriveUpdates];
		} synk:NO];
	}];
}

- (void) retriveUpdates {
	[updates filterByAuthor:nil];

	[updatesAPI aquireUpdates:@{@"newer-than":@(24 * 30),@"collumns": @"uid,kind,pageID,authorID,groupID,title,group,description,size,delta,pubdate"} withCompletion:^(NSDictionary *_updates) {
		if (updates.data == _updates)
			return;

		updates.data = _updates;
		[authors rearrangeBy:AUTHOR_UPDATES_COLLUMN];

		[AZClientAPI onMain:^{
			[self.outlineView reloadData];
			[self.outlineView expandItem:nil expandChildren:YES];
			[self.authorsTableView reloadData];
		} synk:NO];
	}];
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
