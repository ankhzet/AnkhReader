//
//  NSColor+AnkhColors.m
//  AnkhReader
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "NSColor+AnkhColors.h"

@interface NSColorHolder : NSObject  {
@public
	NSColor *teal, *dkgreen;
}
@end

@implementation NSColorHolder
- (id)init {
	if (!(self = [super init]))
		return self;

	teal    = [NSColor colorWithCalibratedRed:0.25 green:0.5 blue:0.5 alpha:1.0];
	dkgreen = [NSColor colorWithCalibratedRed:0.f green:0.5f blue:0.f alpha:1.f];
	return self;
}
@end

@implementation NSColor (AnkhColors)

static NSColorHolder *holder;

+ (NSColorHolder *) getHolder {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
    holder = [NSColorHolder new];
	});
	return holder;
}

+ (NSColor *) tealColor {
	return (holder ? holder : [self getHolder])->teal;
}

+ (NSColor *) darkGreenColor {
	return (holder ? holder : [self getHolder])->dkgreen;
}

@end
