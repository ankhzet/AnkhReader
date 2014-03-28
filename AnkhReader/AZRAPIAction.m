//
//  AZRAPIAction.m
//  AnkhReader
//
//  Created by Ankh on 20.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRAPIAction.h"

#define API_ACTION_BASE_URL @"http://ankhzet.ua/api/client/"
#define API_OK @"ok"
#define API_FAIL @"err"
#define API_RESULT @"result"
#define API_DATA @"data"
#define API_MESSAGE @"message"

@interface AZRAPIAction () {
	AZRAPIExecutionCallbackBlock successBlock;
	AZRAPIExecutionErrorBlock errorBlock;
	NSData *aquiredData;
}
@end

@implementation AZRAPIAction

- (id)init {
	if (!(self = [super init]))
		return self;

	successBlock = ^(AZRAPIAction *action, id data) {
		NSLog(@"Aquired data from %@", [action url]);
	};
	errorBlock = ^(AZRAPIAction *action, NSString *error) {
		NSLog(@"API call failed: %@", error);
	};
	return self;
}

- (instancetype) execute {
	__weak AZRAPIAction *weakAction = self;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		AZRAPIAction *action = weakAction;
		NSError *_error = nil;
		aquiredData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self url]]
																				options:0
																					error:&_error];

		if (!aquiredData) {
			if (_error)
				action->errorBlock(action, [NSString stringWithFormat:@"Error retriving API data: %@", [_error localizedDescription]]);
			else
				action->errorBlock(action, @"Error retriving API data");

			return;
		}

		id idjson = [NSJSONSerialization JSONObjectWithData:aquiredData options:0 error:&_error];

		if (!idjson) {
			action->errorBlock(action, [NSString stringWithFormat:@"API response parse error: %@", [_error localizedDescription]]);
			return;
		}

		if (![idjson isKindOfClass:[NSDictionary class]]) {
			action->errorBlock(action, @"API call returns non-dictionary result");
			return;
		}

		NSDictionary *json = idjson;
		if ([[json objectForKey:API_RESULT] isEqualToString:API_OK]) {
			action->successBlock(action, [json objectForKey:API_DATA]);
			return;
		}

		if ([[json objectForKey:API_RESULT] isEqualToString:API_FAIL]) {
			id data = [json objectForKey:API_DATA];
			action->errorBlock(action, data ? data : [json objectForKey:API_MESSAGE]);
			return;
		}

		action->errorBlock(action, @"API response type is unknown");
	});

	return self;
}

- (instancetype) success:(AZRAPIExecutionCallbackBlock)block firstly:(BOOL)first {
	AZRAPIExecutionCallbackBlock oldBlock = successBlock;
	successBlock = ^(AZRAPIAction *action, id data) {
		first ?	block(action, data) : oldBlock(action, data);
		first ?	oldBlock(action, data) : block(action, data);
	};
	return self;
}
- (instancetype) error:(AZRAPIExecutionErrorBlock)block firstly:(BOOL)first {
	AZRAPIExecutionErrorBlock oldBlock = errorBlock;
	errorBlock = ^(AZRAPIAction *action, NSString *error) {
		first ? block(action, error) : oldBlock(action, error);
		first ? oldBlock(action, error) : block(action, error);
	};
	return self;
}

+ (instancetype) actionWithName:(NSString *)name {
	AZRAPIAction *action = [self new];
	action.name = name;
	return action;
}

- (NSString *) url {
	NSString *base = [API_ACTION_BASE_URL stringByAppendingString:self.name];
	if ([self.parameters count]) {
		NSString *delim = [base rangeOfString:@"?"].length ? @"&" : @"?";

		NSMutableArray *parametrized = [NSMutableArray array];
		for (NSString *param in [self.parameters allKeys]) {
			[parametrized addObject:[AZRAPIAction URIFromParam:self.parameters[param] named:param]];
		}

		base = [[base stringByAppendingString:delim] stringByAppendingString:[parametrized componentsJoinedByString:@"&"]];
	}
	return base;
}

+ (NSString *) URIFromParam:(id)param named:(NSString *)name {
	NSString *result;
	BOOL isArray = [param isKindOfClass:[NSArray class]];
	BOOL isDic = [param isKindOfClass:[NSDictionary class]];
	if (isArray || isDic) {
		NSMutableArray *components = [NSMutableArray array];
		if (isArray)
			for (NSString *value in ((NSArray *)param)) {
				[components addObject:[NSString stringWithFormat:@"%@[]=%@", name, value]];
			}
		else
			for (NSString *key in [((NSDictionary *)param) allKeys]) {
				NSString *value = ((NSDictionary *)param)[key];
				[components addObject:[NSString stringWithFormat:@"%@[%@]=%@", name, key, value]];
			}

		result = [components componentsJoinedByString:@"&"];
	} else
		result = [@[name, (NSString *)param] componentsJoinedByString:@"="];

	return result;
}

@end
