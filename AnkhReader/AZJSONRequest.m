//
//  AZJSONRequest.m
//  AnkhReader
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZJSONRequest.h"

#define API_OK @"ok"
#define API_FAIL @"err"
#define API_RESULT @"result"
#define API_DATA @"data"
#define API_MESSAGE @"message"

@implementation AZJSONRequest

- (id)init {
	if (!(self = [super init]))
		return self;

	[self success:^(AZHTTPRequest *action, id *data) {
		if (![*data isKindOfClass:[NSData class]])
			return action->errorBlock(action, [NSString stringWithFormat:@"API response must be a NSData (%@ returned)", [*data className]]);

		NSError *error = nil;
		id idjson = [NSJSONSerialization JSONObjectWithData:(NSData *)*data options:0 error:&error];

		if (!idjson) {
			action->errorBlock(action, [NSString stringWithFormat:@"API response parse error: %@", [error localizedDescription]]);
			return NO;
		}

		if (![idjson isKindOfClass:[NSDictionary class]]) {
			action->errorBlock(action, @"API call returns non-dictionary result");
			return NO;
		}

		NSDictionary *json = idjson;
		if ([[json objectForKey:API_RESULT] isEqualToString:API_OK]) {
			*data = [json objectForKey:API_DATA];
			return YES;
		}

		if ([[json objectForKey:API_RESULT] isEqualToString:API_FAIL]) {
			id data = [json objectForKey:API_DATA];
			action->errorBlock(action, data ? data : [json objectForKey:API_MESSAGE]);
			return NO;
		}

		action->errorBlock(action, @"API response type is unknown");
		return NO;
	} firstly:YES];

	return self;
}

@end
