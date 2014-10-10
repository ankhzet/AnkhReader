//
//  AZClientAPI.h
//  AZClientAPI
//
//  Created by Ankh on 20.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AZHTTPRequest.h"

@class AZAPIProvider;

@interface AZClientAPI : NSObject
@property (nonatomic, weak) AZAPIProvider *apiProvider;

+ (void) onMain:(dispatch_block_t)block synk:(BOOL)synk;

- (id) action:(NSString *)actionName;
- (AZHTTPRequest *) queue:(AZHTTPRequest *)request withType:(AZAPIRequestType)type;

@end
