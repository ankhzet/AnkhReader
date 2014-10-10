//
//  AZRAPIAction.m
//  AZClientAPI
//
//  Created by Ankh on 20.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZHTTPRequest.h"
//#import "TFHpple.h"

#define API_USER_AGENT @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20100101 Firefox/12.0"
//@"AnkhZet client v0.1"

@implementation AZHTTPRequest

- (id)init {
	if (!(self = [super init]))
		return self;

	successBlock = ^(AZHTTPRequest *action, id *data) {
//		NSLog(@"Aquired data from %@", [action url]);
		action.finished = YES;
		return YES;
	};
	errorBlock = ^(AZHTTPRequest *action, NSString *error) {
		[AZUtils notifyErrorMsg:error];

//		NSLog(@"API call failed: %@", error);
		action.finished = YES;
		return YES;
	};

	_encoding = NSWindowsCP1251StringEncoding;//NSUTF8StringEncoding;
	_httpMethod = @"GET";
	_isPost = NO;
	_timeout = 30;
	NSURL *url = [NSURL URLWithString:API_ACTION_BASE_URL];
	_referrer = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];

	_successful = NO;
	_finished = NO;
	_expectedBytes = 0;
	_loadedBytes = 0;

	return self;
}

- (void) setHttpMethod:(NSString *)httpMethod {
	if (_httpMethod == httpMethod)
		return;

	_httpMethod = [httpMethod uppercaseString];
	_isPost = [_httpMethod isEqualToString:@"POST"];
}

- (AZHTTPRequest *) execute {
	__weak AZHTTPRequest *weakAction = self;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		AZHTTPRequest *action = weakAction;
		if (!action) {
			return;
		}

		NSString *requestUrl = [action url];
		NSString *requestBody = @"";


		if (action.isPost) {
			NSRange delim = [requestUrl rangeOfString:@"?"];
			if (delim.length) {
				requestBody = [requestUrl substringFromIndex:delim.location + delim.length];
				requestUrl = [requestUrl substringToIndex:delim.location];
			}
			action.referrer = requestUrl;
		}

		CFStringRef cfEncodingStr = nil;
		CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(action.encoding);
		if (cfEncoding != kCFStringEncodingInvalidId) {
			cfEncodingStr = CFStringConvertEncodingToIANACharSetName(cfEncoding);
		}
		NSString *encoding = (__bridge NSString *)cfEncodingStr;

		NSMutableDictionary *headers = [@{
																			@"Referer": action.referrer,
																			@"User-agent": API_USER_AGENT,
																			@"Content-length": [@([requestBody lengthOfBytesUsingEncoding:action.encoding]) stringValue],
																			@"Content-encoding": encoding,
																			@"Pragma": @"no-cache",
																			@"Cache-Control":@"no-cache, max-age=0",
																			} mutableCopy];

		if (action.isPost)
			headers[@"Content-type"] = @"application/x-www-form-urlencoded";

		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]
																																cachePolicy:0
																														timeoutInterval:action.timeout];


		[request setHTTPMethod:action.httpMethod];
		[request setAllHTTPHeaderFields:headers];
		[request setHTTPBody:[requestBody dataUsingEncoding:action.encoding]];

		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:action startImmediately:YES];

		if (!connection) {
			action->errorBlock(action, @"Connection failed");
			return;
		}

		while (!action.finished)
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	});

	return self;
}

- (instancetype) success:(AZRAPIExecutionCallbackBlock)block firstly:(BOOL)first {
	AZRAPIExecutionCallbackBlock oldBlock = successBlock;
	successBlock = ^(AZHTTPRequest *action, id *data) {
		return (BOOL)((first ? block(action, data) : oldBlock(action, data)) && (first ? oldBlock(action, data) : block(action, data)));
	};
	return self;
}
- (instancetype) error:(AZRAPIExecutionErrorBlock)block firstly:(BOOL)first {
	AZRAPIExecutionErrorBlock oldBlock = errorBlock;
	errorBlock = ^(AZHTTPRequest *action, NSString *error) {
		return (BOOL)((first ? block(action, error) : oldBlock(action, error)) && (first ? oldBlock(action, error) : block(action, error)));
	};
	return self;
}
- (instancetype) success:(AZRAPIExecutionCallbackBlock)block {
	return [self success:block firstly:NO];
}
- (instancetype) error:(AZRAPIExecutionErrorBlock)block {
	return [self error:block firstly:NO];
}

+ (instancetype) actionWithName:(NSString *)name {
	AZHTTPRequest *action = [self new];
	action.name = name;
	return action;
}

- (NSString *) url {
	NSString *base = [API_ACTION_BASE_URL stringByAppendingString:self.name];
	if ([self.parameters count]) {
		NSString *delim = [base rangeOfString:@"?"].length ? @"&" : @"?";

		NSMutableArray *parametrized = [NSMutableArray array];
		for (NSString *param in [self.parameters allKeys]) {
			[parametrized addObject:[AZHTTPRequest URIFromParam:self.parameters[param] named:param]];
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse {
//	NSLog(@"%@", response);
	if (![urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
		errorBlock(self, @"Non-http response");
		return;
	}

	self.response = (id)urlResponse;

	switch ([self.response statusCode]) {
		case 301:
		case 302:
		case 304:
			NSLog(@"redirect o_O");
		case 200: {
			self.successful = YES;
			return;
		}
		default:
			break;
	}

	errorBlock(self, [NSString stringWithFormat:@"Unhandled status code: %lu", [self.response statusCode]]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//	NSLog(@"Data conn: %@, %lu", connection, (unsigned long)[data length]);
	if (!aquiredData)
		aquiredData = [data mutableCopy];
	else
		[(NSMutableData *)aquiredData appendData:data];

	self.loadedBytes += [aquiredData length];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	NSLog(@"Finish conn: %@, %lu", connection, [aquiredData length]);

	self.loadedBytes = [aquiredData length];

	if (self.interrupt || !self.successful)
		return;

	id data = aquiredData;
	successBlock(self, &data);
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	errorBlock(self, [NSString stringWithFormat:@"Connection error: %@", [error localizedDescription]]);
}

//-(void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
//	self.expectedBytes = expectedTotalBytes;
//	self.loadedBytes = totalBytesWritten;
//}

@end
