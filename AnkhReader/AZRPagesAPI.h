//
//  AZRPagesAPI.h
//  AnkhReader
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAnkhAPI.h"

@class AZRPage, AZRPageVersion;
@interface AZRPagesAPI : AZRAnkhAPI

- (AZHTTPRequest *) aquirePage:(NSUInteger)uid withCompletion:(void(^)(AZRPage *page))block;
- (AZHTTPRequest *) aquirePageVersions:(AZRPage *)page withCompletion:(void(^)(NSSet *versions))block;

@end
