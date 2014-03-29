//
//  AZRVersionsDataSource.m
//  AnkhReader
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRVersionsDataSource.h"
#import "AZRVersionCellView.h"

@implementation AZRVersionsDataSource

- (void) setOrderedData:(NSDictionary *)data {
	NSMutableArray *ordered = [NSMutableArray array];

	NSArray *orderedKeys = [[data allKeys] sortedArrayUsingSelector:@selector(compare:)];
	for (NSNumber *idx in [orderedKeys reverseObjectEnumerator]) {
    [ordered addObject:data[idx]];
	}

	self.data = ordered;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [self.data count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if ((row < 0) || (row >= [self.data count]))
		return nil;

	id entity = self.data[row];
	return entity;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

	// Get a new ViewCell
	AZRVersionCellView *cellView;

	cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
	id entity = [self tableView:tableView objectValueForTableColumn:tableColumn row:row];
	[cellView configureForEntity:entity inOutlineView:nil];

	//	if( [tableColumn.identifier isEqualToString:@"author"] ) {
	//		return cellView;
	//	}
	return cellView;
}

/*
- (void) tableViewSelectionDidChange:(NSNotification *)notification {
	if (!self.delegate) return;

	NSTableView *tableView = notification.object;
	NSInteger idx = [tableView selectedRow];
	[self.delegate objectSelected:[self tableView:tableView objectValueForTableColumn:nil row:idx]];
}

 */

@end
