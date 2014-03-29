//
//  AZRPagesAPI.h
//  AnkhReader
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRJSONAPI.h"

@class AZRPage, AZRPageVersion;
@interface AZRPagesAPI : AZRJSONAPI

- (AZHTTPRequest *) aquirePage:(NSUInteger)uid withCompletion:(void(^)(AZRPage *page))block;
- (AZHTTPRequest *) aquirePageVersions:(AZRPage *)page withCompletion:(void(^)(NSDictionary *versions))block;

@end
