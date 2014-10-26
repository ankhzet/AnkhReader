//
//  AZRFlippedView.m
//  AnkhReader
//
//  Created by Ankh on 10.10.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRFlippedView.h"

@implementation AZRFlippedView

- (BOOL) isFlipped {
	return YES;
}

- (void) setFrameSize:(NSSize)newSize {
	[super setFrameSize:newSize];

	for (NSView *v1 in self.subviews)
		if ([v1 isKindOfClass:[NSScrollView class]])
			for (NSView *v2 in v1.subviews)
				for (NSView *v3 in v2.subviews)
					if ([v3 isKindOfClass:[NSView class]]) {
						newSize.height = v3.frame.size.height;
						[v3 setFrameSize:newSize];
						return;
					}
}

@end
