//
//  AZJSONUtils.h
//  AZClientAPI
//
//  Created by Ankh on 09.10.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#ifndef AnkhReader_AZJSONUtils_h
#define AnkhReader_AZJSONUtils_h

extern id        JSON_O(id json, NSString *key);
extern NSString *JSON_S(id json, NSString *key);
extern NSNumber *JSON_I(id json, NSString *key);
extern NSNumber *JSON_F(id json, NSString *key);
extern NSNumber *JSON_B(id json, NSString *key);

#endif
