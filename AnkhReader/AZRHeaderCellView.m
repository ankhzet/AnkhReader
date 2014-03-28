//
//  AZRHeaderCellView.m
//  AnkhReader
//
//  Created by Ankh on 22.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRHeaderCellView.h"

@implementation AZRHeaderCellView {
	NSOutlineView *outlineView;
}

- (void) configureForEntity:(id)_entity inOutlineView:(NSOutlineView *)view {
	outlineView = view;
}

- (IBAction) click:(id)sender {
	if ([outlineView.delegate conformsToProtocol:@protocol(AZRHeaderCellDelegate)])
		[(id<AZRHeaderCellDelegate>)outlineView.delegate headerClicked];
}

@end
