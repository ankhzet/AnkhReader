//
//  AZRAuthor+AnkhUtils.m
//  AnkhReader
//
//  Created by Ankh on 20.11.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAuthor+AnkhUtils.h"
#import "AZRUpdate.h"

@implementation AZRAuthor (AnkhUtils)

- (NSUInteger) usefulUpdatesCount {
	NSUInteger count = 0;
	if (!PREF_BOOL(DEF_UI_HIDE_RENAMED)) {
		count = [self.updates count];
	} else
		for (AZRUpdate *update in self.updates)
			if (![update.kind isEqualToNumber:@(AZRUpdateKindRenamed)])
				count++;

	return count;
}


@end
