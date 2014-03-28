//
//  AZRAuthorTableCellView.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAuthorTableCellView.h"
#import "AZRAuthor.h"

@implementation AZRAuthorTableCellView

- (void) configureForEntity:(id)_entity inOutlineView:(NSOutlineView *)view {
	AZRAuthor *entity = _entity;
	self.tfFIO.stringValue = [entity.fio cvtHTMLEntities];
	self.tfLink.stringValue = [entity.link cvtHTMLEntities];

	NSInteger updates = [entity.updates count];
	self.tfUpdates.stringValue = [@(updates) stringValue];
	[self.tfUpdates setHidden:updates <= 0];
}


@end
