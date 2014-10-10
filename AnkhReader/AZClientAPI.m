//
//  AZClientAPI.m
//  AZClientAPI
//
//  Created by Ankh on 20.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZClientAPI.h"
#import "AZAPIProvider.h"
#import "AZHTTPRequest.h"

@implementation AZClientAPI

- (id) action:(NSString *)actionName {
	return [AZHTTPRequest actionWithName:actionName];
}

+ (void) onMain:(dispatch_block_t)block synk:(BOOL)synk {
	dispatch_queue_t main = dispatch_get_main_queue();
  if (dispatch_get_current_queue() == main)
		block();
	else
		synk ? dispatch_sync(main, block) : dispatch_async(main, block);
}

- (AZHTTPRequest *) queue:(AZHTTPRequest *)request withType:(AZAPIRequestType)type {
	return [self.apiProvider queueRequest:request withType:type forAPI:self];
}

@end
