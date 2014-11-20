//
//  AZRAnkhAPI.m
//  AnkhReader
//
//  Created by Ankh on 20.11.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAnkhAPI.h"
#import "AZJSONRequest.h"

@implementation AZRAnkhAPI

- (id) action:(NSString *)actionName {
	AZJSONRequest *request = [super action:actionName];
	request.url = [NSString stringWithFormat:request.url, PREF_STR(DEF_SERVER_ADDRESS)];
	return request;
}


@end
