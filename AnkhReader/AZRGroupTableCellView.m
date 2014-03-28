//
//  AZRGroupTableCell.m
//  AnkhReader
//
//  Created by Ankh on 22.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRGroupTableCellView.h"
#import "AZRGroup.h"

@implementation AZRGroupTableCellView

- (void) configureForEntity:(id)_entity inOutlineView:(NSOutlineView *)view {
	AZRGroup *entity = _entity;
	self.tfTitle.stringValue = [entity.title cvtHTMLEntities];
}

@end
