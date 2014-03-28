//
//  AZRUpdatesDataSource.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRUpdatesDataSource.h"
#import "AZRConfigurableTableCellView.h"

#import "AZREntitiesRegistry.h"
#import "AZRUpdate.h"
#import "AZRAuthor.h"
#import "AZRGroup.h"
#import "AZRPage.h"

@interface CustomDictionary : NSObject {
@public
	id owner;
@protected
	NSMutableDictionary *dictionary;
}
@end
@implementation CustomDictionary

+ (instancetype) custom:(id)owner {
	CustomDictionary *dictionary = [self new];
	dictionary->owner = owner;
	return dictionary;
}

- (id)init {
	if (!(self = [super init]))
		return self;

	dictionary = [NSMutableDictionary dictionary];
	return self;
}
- (void) setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
	dictionary[key] = object;
}
- (id) objectForKeyedSubscript:(id)key {
	return dictionary[key];
}
- (NSUInteger) count {
	return [dictionary count];
}
- (NSArray *) allKeys {
	return [dictionary allKeys];
}

+ (BOOL) isDictionary:(id)object {
	return [object isKindOfClass:self];
}

@end

@interface AuthorsDictionary : CustomDictionary @end @implementation AuthorsDictionary @end
@interface GroupsDictionary : CustomDictionary @end @implementation GroupsDictionary @end
@interface PagesDictionary : CustomDictionary @end @implementation PagesDictionary @end

@implementation AZRUpdatesDataSource {
	AuthorsDictionary *authorGroups, *baseAuthors;
	NSMutableDictionary *_uPages;
	NSDictionary *updatesArray;
	BOOL filter;
}

- (void) headerClicked {
	[self.delegate headerClicked];
}

- (void) updateClicked:(id)entity {
	[self.delegate updateClicked:entity];
}

- (void) filterByAuthor:(NSNumber *)authorID {
	authorGroups = authorID ? baseAuthors[authorID] : baseAuthors;
	if (!authorGroups)
		authorGroups = baseAuthors;

	filter = baseAuthors != authorGroups;
}

- (void) fetchUpdates:(NSArray *)updates inRegistry:(AZREntitiesRegistry *)registry {
	NSMutableDictionary *authorsToLoad = [NSMutableDictionary dictionary];
	NSMutableDictionary *groupsToLoad = [NSMutableDictionary dictionary];
	NSMutableDictionary *pagesToLoad = [NSMutableDictionary dictionary];
	for (NSDictionary *updateJSON in updates) {
		NSNumber *authorID = [updateJSON objectForKey:@"authorID"];
		NSNumber *groupID = [updateJSON objectForKey:@"groupID"];
		NSNumber *pageID = [updateJSON objectForKey:@"pageID"];

		AZRAuthor *author = [registry hasEntity:authorID withType:[AZRAuthor type]];
		if (!author) authorsToLoad[authorID] = updateJSON;

		AZRGroup *group = [registry hasEntity:groupID withType:[AZRGroup type]];
		if (!group) groupsToLoad[groupID] = updateJSON;

		AZRPage *page = [registry hasEntity:pageID withType:[AZRPage type]];
		if (!page) pagesToLoad[pageID] = updateJSON;

	}

	for (NSNumber *authorID in [authorsToLoad allKeys])
    [registry registerEntity:[AZRAuthor entity:authorID fromJSON:authorsToLoad[authorID] inRegistry:registry]];

	for (NSNumber *groupID in [groupsToLoad allKeys])
    [registry registerEntity:[AZRGroup entity:groupID fromJSON:groupsToLoad[groupID] inRegistry:registry]];

	for (NSNumber *pageID in [pagesToLoad allKeys])
    [registry registerEntity:[AZRPage entity:pageID fromJSON:pagesToLoad[pageID] inRegistry:registry]];

	NSMutableDictionary *allData = [NSMutableDictionary dictionaryWithCapacity:[updates count]];
	for (NSDictionary *updateJSON in updates) {
		AZRUpdate *update = [AZRUpdate entity:[updateJSON objectForKey:@"uid"] fromJSON:updateJSON inRegistry:registry];
		allData[update.uid] = update;
	}
	self.data = allData;
}

- (void) setData:(NSDictionary *)data {
	_data = data;

	_uPages = [NSMutableDictionary dictionary];
	for (AZRUpdate *update in [data allValues]) {
		NSNumber *page = update.page.uid;
		NSMutableArray *pageUpdates = _uPages[page] ? _uPages[page] : (_uPages[page] = [NSMutableArray array]);

		[pageUpdates addObject:update];
	}

	/*
	 author
	 \ group
	   \ update
	   \ update
	 \ group
	   \ update
	 author
	 \ group
	   \ update
	 */
	baseAuthors = [AuthorsDictionary custom:nil];
	for (NSArray *pageUpdates in [_uPages allValues]) {
		for (AZRUpdate *update in pageUpdates) {
			NSNumber *author = update.author.uid;
			Class c = _groupped ? [GroupsDictionary class] : [PagesDictionary class];
			PagesDictionary *pages = baseAuthors[author] ? baseAuthors[author] : (baseAuthors[author] = [c custom:update.author]);

			if (_groupped) {
				NSNumber *group = update.group.uid;
				pages = pages[group] ? pages[group] : (pages[group] = [PagesDictionary custom:update.group]);
			}

			pages[update.uid] = update;
		}
	}

	authorGroups = baseAuthors;
}

- (void) setGroupped:(BOOL)groupped {
	if (groupped == _groupped)
		return;

	_groupped = groupped;
	[self setData:_data];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	AZRConfigurableTableCellView *cellView;

	id entity = item;
	NSString *cellType = @"UpdateCell";

	if (item == outlineView)
		cellType = @"HeaderCell";
	else {
		if ([CustomDictionary isDictionary:item]) {
			CustomDictionary *dictionary = item;
			entity = dictionary->owner;
			if ([entity isKindOfClass:[AZRAuthor class]])
				cellType = @"AuthorCell";
			if ([entity isKindOfClass:[AZRGroup class]])
				cellType = @"GroupCell";
		}
	}

	cellView = [outlineView makeViewWithIdentifier:cellType owner:self];
	[cellView configureForEntity:entity inOutlineView:outlineView];

	return cellView;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if (!item) // if root node
		return [authorGroups count] + (filter ? 1 : 0);

	if ([CustomDictionary isDictionary:item])
		return [item count];

	return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	if (!item) { // root node
		if (filter && !index)
			return outlineView;

		return authorGroups[[authorGroups allKeys][index - (filter ? 1 : 0)]];
	}

	if ([CustomDictionary isDictionary:item])
		return item[[item allKeys][index]];

	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
	return [CustomDictionary isDictionary:item];//[item isKindOfClass:[PagesDictionary class]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	return [CustomDictionary isDictionary:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
	return NO;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowCellExpansionForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	return NO;
}

/* NOTE: this method is optional for the View Based OutlineView.
 */
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if ([CustomDictionary isDictionary:item])
		return ((CustomDictionary *)item)->owner;

	return item;
}

- (void)outlineView:(NSOutlineView *)outlineView sortDescriptorsDidChange:(NSArray *)oldDescriptors {
	
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
	return ([CustomDictionary isDictionary:item] || [item isKindOfClass:[NSOutlineView class]]) ? 20.f : 41.f;
}


@end
