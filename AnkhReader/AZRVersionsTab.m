//
//  AZRVersionsTab.m
//  AnkhReader
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRVersionsTab.h"
#import "AZRTabsCommons.h"

#import "AZJSONRequest.h"
#import "AZJSONAPI.h"

#import "AZREntities.h"

#import "AZAPIProvider.h"
#import "AZRPagesAPI.h"

#import "AZRVersionsDataSource.h"

@interface AZRVersionsTab () {
	AZRPage *page;
	AZRPagesAPI *pagesAPI;
	AZRVersionsDataSource *versions;
}
@property (weak) IBOutlet NSTextField *tfAuthor;
@property (weak) IBOutlet NSTextField *tfGroup;
@property (weak) IBOutlet NSTextField *tfPage;
@property (weak) IBOutlet NSTableView *tvVersions;

@end

@implementation AZRVersionsTab

- (id)init {
	if (!(self = [super init]))
		return self;

	pagesAPI = [[AZAPIProvider getInstance] API:[AZRPagesAPI class]];
	return self;
}

- (NSString *) tabIdentifier {
	return AZRUIDVersionsTab;
}

- (void) show {
	NSNumber *uid = self.navData[@0];
	page = [[AZREntitiesRegistry getInstance] hasEntity:uid withType:[AZRPage type]];

	if (!versions) {
		versions = [AZRVersionsDataSource new];
		self.tvVersions.delegate = versions;
		self.tvVersions.dataSource = versions;
		[self.tvVersions reloadData];
	}
	[self pickPage:[uid unsignedIntegerValue]];
}


- (void) pickPage:(NSUInteger)uid {
	[pagesAPI aquirePage:uid withCompletion:^(AZRPage *_page) {
		page = _page;
		[AZClientAPI onMain:^{
			self.tfAuthor.stringValue = [NSString stringWithFormat:@"%@", [page.author.fio cvtHTMLEntities]];
			self.tfGroup.stringValue = [NSString stringWithFormat:@"↳ %@", [page.group.title cvtHTMLEntities]];
			self.tfPage.stringValue = [NSString stringWithFormat:@"↳ %@", [page.title cvtHTMLEntities]];
			if (page) {
				[self retriveVersions];
			} else {
				[AZUtils notifyErrorMsg:@"Page can't be aquired"];
			}
		} synk:NO];

	}];
}

- (void) retriveVersions {
	[pagesAPI aquirePageVersions:page withCompletion:^(NSSet *_versions) {
		[versions setOrderedData:_versions];
		[AZClientAPI onMain:^{
			[self.tvVersions reloadData];
		} synk:NO];
	}];
}

@end
