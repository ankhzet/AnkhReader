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

#import "AZREntities.h"

#import "AZAPIProvider.h"
#import "AZRAuthorsAPI.h"
#import "AZRUpdatesAPI.h"

@interface AZRUpdatesTab () <AZRAuthorsTableDelegate, AZRUpdatesDataSourceDelegate> {
	AZRAuthorsDataSource *authors;
	AZRUpdatesDataSource *updates;
}

@end

@implementation AZRUpdatesTab

- (NSString *) tabIdentifier {
	return AZRUIDUpdatesTab;
}

- (BOOL) loadNIB {
	if ([super loadNIB]) {
		updates = (id)self.ovUpdates.dataSource;
		authors = (id)self.tvAuthors.dataSource;
		[updates setDelegate:self];
		[authors setDelegate:self];
		return YES;
	} else
		return NO;
}

- (void) updateContents {
	[self retriveAuthorsList];
}

- (void) retriveAuthorsList {
	[AZ_API(RAuthors) aquireAuthors:@{@"collumns": @"id,fio,link,time"} withCompletion:^(NSDictionary *_authors) {
		if (authors.data == _authors) {
			[self showAuthors:NO];
			[self show:nil updates:nil];
			return;
		}

		authors.data = _authors;
		[self showAuthors:YES];
	}];
}

- (void) retriveUpdates {
	[AZ_API(RUpdates) aquireUpdates:@{@"newer-than":@(24 * 30),@"collumns": @"uid,kind,pageID,authorID,groupID,title,group,description,size,delta,pubdate"} withCompletion:^(NSDictionary *_updates) {
		if (updates.data == _updates)
			return;

		[self show:nil updates:_updates];

		[self showAuthors:NO];
	}];
}

- (void) show:(NSNumber *)authorToFilter updates:(NSDictionary *)updatesDict {
	[self delayed:@"show-updates" withBlock:^{
		dispatch_sync_at_background(^{
			NSDictionary *dict = updatesDict ? updatesDict : updates.data;

			updates.data = nil;
			[updates setGroupped:PREF_BOOL(DEF_UI_GROUP_PAGES)];
			[updates setWithRenamed:!PREF_BOOL(DEF_UI_HIDE_RENAMED)];

			updates.data = dict;

			[updates filterByAuthor:authorToFilter];

			dispatch_async_at_main(^{
				[self.ovUpdates reloadData];
				[self.ovUpdates expandItem:nil expandChildren:YES];
			});
		});
	}];
}

- (void) showAuthors:(BOOL)retriveUpdates {
	[self delayed:@"show-authors" withBlock:^{
		[authors rearrangeBy:AUTHOR_UPDATES_COLLUMN];
		[self.tvAuthors reloadData];

		if (retriveUpdates)
			[self retriveUpdates];
	}];
}

- (void) objectSelected:(id)object {
	if ([object isKindOfClass:[AZRAuthor class]])
		[self show:[object uid] updates:nil];
}

- (void) headerClicked {
	[self show:nil updates:nil];
}

- (void) updateClicked:(id)entity {
	AZRUpdate *update = entity;
	[self.tabs navigateTo:AZRUIDVersionsTab withNavData:@{@0: update.page.uid}];
}

@end
