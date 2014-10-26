//
//  NSURL+AnkhUtils.m
//  SLEditor
//
//  Created by Ankh on 31.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "NSURL+AnkhUtils.h"

@implementation NSURL (AnkhUtils)

- (NSURL *) absoluteRootURL {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", [self scheme], [self host]]];
}

@end
