//
//  AZRVersionCellView.m
//  AnkhReader
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRVersionCellView.h"
#import "AZREntities.h"

@implementation AZRVersionCellView

- (void) configureForEntity:(id)_entity inOutlineView:(NSOutlineView *)view {
	AZRPageVersion *entity = _entity;
	self.tfTimestamp.objectValue = [NSDate dateWithTimeIntervalSince1970:[entity.timestamp unsignedIntegerValue]];
	self.tfSize.objectValue = @([entity.size unsignedIntegerValue] * 1024);
	self.tfSizeZipped.objectValue = @([entity.zipped unsignedIntegerValue] * 1024);
}

@end
