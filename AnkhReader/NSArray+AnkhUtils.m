//
//  NSArray+AnkhUtils.m
//  SLEditor
//
//  Created by Ankh on 31.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "NSArray+AnkhUtils.h"

@implementation NSArray (AnkhUtils)

- (NSHTTPCookie *) hasCookie:(NSString *)name {
	for (NSHTTPCookie *cookie in self)
		if ([cookie.name caseInsensitiveCompare:name] == NSOrderedSame)
			return cookie;

	return nil;
}

@end
