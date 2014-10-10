//
//  AZAPIProvider.h
//  AZClientAPI
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AZHTTPRequest.h"

@class AZClientAPI;
@interface AZAPIProvider : NSObject

+ (instancetype) getInstance;
- (id) API:(Class)apiHandlerClass;

- (AZHTTPRequest *) queueRequest:(AZHTTPRequest *)request withType:(AZAPIRequestType)type forAPI:(AZClientAPI *)api;

- (BOOL) hasWorkingRequests;
- (BOOL) hasPendingRequests;

@end
