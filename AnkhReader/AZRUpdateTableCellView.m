//
//  AZRUpdateTableCellView.m
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRUpdateTableCellView.h"
#import "AZRUpdate.h"
#import "AZRGroup.h"
#import "AZRPage.h"

@implementation AZRUpdateTableCellView {
	NSOutlineView *outlineView;
	AZRUpdate *entity;
}

- (IBAction) click:(id)sender {
	if ([outlineView.delegate conformsToProtocol:@protocol(AZRUpdateCellDelegate)])
		[(id<AZRUpdateCellDelegate>)outlineView.delegate updateClicked:entity];
}


- (void) configureForEntity:(id)_entity inOutlineView:(NSOutlineView *)view {
	outlineView = view;
	entity = _entity;
	self.tfTitle.stringValue = [[NSString stringWithFormat:@"%@", /*entity.group.title,*/ entity.page.title] cvtHTMLEntities];

	BOOL hasVersions = NO;
	BOOL isGrow = [entity.delta integerValue] > 0;
	NSString *sign = isGrow ? @"+" : @"";
	NSString *size = [NSString stringWithFormat:@"%@%@Кб", sign, entity.delta];
	switch ([entity.kind unsignedIntegerValue]) {
		case AZRUpdateKindPageAdded: {
			self.tfDelta.textColor = [NSColor blueColor];
			size = [NSString stringWithFormat:@"новый (%@)", size];
			hasVersions = YES;
			break;
		}
		case AZRUpdateKindPageSizeDiff: {
			if (entity.isDeleted) {
				self.tfDelta.textColor = [NSColor redColor];
				size = [NSString stringWithFormat:@"удалено (%@)", size];
			} else
				self.tfDelta.textColor = isGrow ? [NSColor darkGreenColor] : [NSColor redColor];
			hasVersions = YES;
			break;
		}
		case AZRUpdateKindDelete:
		case AZRUpdateKindGroupDeleted:
		case AZRUpdateKindPageDeleted: {
			self.tfDelta.textColor = [NSColor redColor];
			size = @"удалено";
			break;
		}
		case AZRUpdateKindRenamed: {
			self.tfDelta.textColor = [NSColor tealColor];
			size = @"переименовано";
			break;
		}
		case AZRUpdateKindPageReGrouped: {
			self.tfDelta.textColor = [NSColor tealColor];
			size = @"перемещено";
			break;
		}
		case AZRUpdateKindGroupInline: {
			self.tfDelta.textColor = [NSColor tealColor];
			size = @"вложенная группа";
			break;
		}
		default:
			break;
	}

	self.tfDelta.stringValue = size;

	self.tfTime.stringValue = entity.pub;

	[self.bDisclosure setHidden:!hasVersions];
}

@end
