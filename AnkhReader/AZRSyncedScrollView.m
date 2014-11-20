//
//  AZRSyncedScrollView.m
//  AnkhReader
//
//  Created by Ankh on 17.11.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRSyncedScrollView.h"
#import "AZRFlippedView.h"

@implementation AZRSyncedScrollView

- (void) setFrameSize:(NSSize)newSize {
	[super setFrameSize:newSize];

	[self.delegate frame:self sizeChanged:newSize];
}

@end
