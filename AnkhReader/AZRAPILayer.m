//
//  AZRAPILayer.m
//  AnkhReader
//
//  Created by Ankh on 20.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAPILayer.h"
#import "AZRAPIAction.h"

@implementation AZRAPILayer

- (AZRAPIAction *) action:(NSString *)actionName {
	AZRAPIAction *action = [AZRAPIAction actionWithName:actionName];

	return action;
}

@end
