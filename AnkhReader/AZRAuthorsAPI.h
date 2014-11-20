//
//  AZRAuthorsAPI.h
//  AnkhReader
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAnkhAPI.h"

@interface AZRAuthorsAPI : AZRAnkhAPI

- (AZHTTPRequest *) aquireAuthors:(NSDictionary *)params withCompletion:(void(^)(id data))block;

@end
