//
//  AZJSONAPI.m
//  AZClientAPI
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZJSONAPI.h"

@implementation AZJSONAPI

- (id) action:(NSString *)actionName {
	return [AZJSONRequest actionWithName:actionName];
}

@end
