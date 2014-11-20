//
//  AZRJSONDateSource.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAuthorsDataSource.h"
#import "AZRAuthorTableCellView.h"
#import "AZRAuthor.h"
#import "AZRAuthor+AnkhUtils.h"

NSString *const AUTHOR_UID_COLLUMN = @"uid";
NSString *const AUTHOR_UPDATED_COLLUMN = @"updated";
NSString *const AUTHOR_UPDATES_COLLUMN = @"updates";

@implementation AZRAuthorsDataSource {
	NSArray *order;
}

- (void) setData:(NSDictionary *)data {
	_data = data;
	[self rearrangeBy:AUTHOR_UPDATED_COLLUMN];
}

- (void) rearrangeBy:(NSString *)collumn {
	NSMutableArray *updates = [NSMutableArray array];
	for (AZRAuthor *author in [_data allValues]) {
    [updates addObject:@{@"author": author, AUTHOR_UID_COLLUMN: author.uid, AUTHOR_UPDATED_COLLUMN: author.updated, AUTHOR_UPDATES_COLLUMN: @([author usefulUpdatesCount])}];
	}

	NSMutableArray *descriptors = [NSMutableArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:collumn ascending:NO]];
	if (![collumn isEqualToString:AUTHOR_UPDATED_COLLUMN])
		[descriptors addObject:[NSSortDescriptor sortDescriptorWithKey:AUTHOR_UPDATED_COLLUMN ascending:NO]];

	NSArray *sorted = [updates sortedArrayUsingDescriptors:descriptors];
	order = [NSMutableArray arrayWithCapacity:[sorted count]];
	for (NSDictionary *entity in sorted) {
		[(NSMutableArray *)order addObject:entity[AUTHOR_UID_COLLUMN]];
	}
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [self.data count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if ((row < 0) || (row >= [self.data count]))
		return nil;

	id entity = self.data[order[row]];
	return entity;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

	// Get a new ViewCell
	AZRAuthorTableCellView *cellView;

	cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
	id entity = [self tableView:tableView objectValueForTableColumn:tableColumn row:row];
	[cellView configureForEntity:entity inOutlineView:nil];

	return cellView;
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification {
	if (!self.delegate) return;

	NSTableView *tableView = notification.object;
	NSInteger idx = [tableView selectedRow];
	[self.delegate objectSelected:[self tableView:tableView objectValueForTableColumn:nil row:idx]];
}

@end
