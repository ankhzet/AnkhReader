//
//  AZJSONUtils.m
//  AZClientAPI
//
//  Created by Ankh on 09.10.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZJSONUtils.h"

inline id JSON_O(id json, NSString *key) {
	return [json objectForKey:key];
}

inline NSString *JSON_S(id json, NSString *key) {
	json = [json objectForKey:key];

	if ([json isKindOfClass:[NSString class]])
		return json;

	json = [json description];

	return json;
}

inline NSNumber *JSON_I(id json, NSString *key) {
	json = [json objectForKey:key];

	if ([json isKindOfClass:[NSNumber class]])
		return json;

	if (![json isKindOfClass:[NSString class]])
		json = [json description];

	return @([json integerValue]);
}

inline NSNumber *JSON_F(id json, NSString *key) {
	json = [json objectForKey:key];

	if ([json isKindOfClass:[NSNumber class]])
		return json;

	if (![json isKindOfClass:[NSString class]])
		json = [json description];

	return @([json floatValue]);
}

inline NSNumber *JSON_B(id json, NSString *key) {
	json = [json objectForKey:key];

	if ([json isKindOfClass:[NSNumber class]])
		return json;

	if (![json isKindOfClass:[NSString class]])
		json = [json description];

	return @([json boolValue]);
}

