//
//  NSString+AnkhUtils.m
//  AnkhReader
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "NSString+AnkhUtils.h"

@implementation NSString (AnkhUtils)

- (NSString *) cvtHTMLEntities {
	NSRange r = NSMakeRange(0, [self length]);
	NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"\\&([\\w\\d]+);?" options:0 error:nil];

	NSDictionary *known =
	@{
		@"quot": @"\"",
		@"copy": @"©",
		@"lt": @"<",
		@"gt": @">",
		};
	NSSet *knownSet = [NSSet setWithArray:[known allKeys]];
	NSMutableDictionary *entities = [NSMutableDictionary dictionary];

	[regexp enumerateMatchesInString:[self lowercaseString]
													 options:0
														 range:r
												usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
													NSString *match = [self substringWithRange:result.range];
													NSString *cleanTag = [[match stringByReplacingOccurrencesOfString:@";" withString:@""] substringFromIndex:1];
													if ([knownSet member:cleanTag]) {
														NSMutableSet *entList = entities[cleanTag];
														if (!entList) entList = entities[cleanTag] = [NSMutableSet set];
														[entList addObject:match];
													}
												}
	 ];

	NSMutableString *result = [self mutableCopy];
	for (NSString *entity in [entities allKeys])
		for (NSString *occurence in entities[entity])
			[result replaceOccurrencesOfString:occurence withString:known[entity] options:0 range:NSMakeRange(0, [result length])];

	return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
