//
//  AZRUserAPI.h
//  AnkhReader
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZJSONAPI.h"

@class AZRUser;
@interface AZRUserAPI : AZJSONAPI

- (AZHTTPRequest *) loginWithParams:(NSDictionary *)params withCompletion:(void(^)(id data))block;

@end
