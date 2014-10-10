//
//  AZAPIProvider.m
//  AZClientAPI
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZAPIProvider.h"
#import "AZClientAPI.h"

#define QUEUE_IMPERATIVE  @0
#define QUEUE_CONSICUTIVE @1
#define QUEUE_CLEANUP     @2

@implementation AZAPIProvider {
	NSMutableDictionary *apis;
	NSMutableDictionary *masterQueue;
	NSMutableArray *workingQueue;
}

+ (instancetype) getInstance {
	static AZAPIProvider *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
    instance = [AZAPIProvider new];
	});

	return instance;
}

- (id)init {
	if (!(self = [super init]))
		return self;

	apis = [NSMutableDictionary dictionary];
	masterQueue = [NSMutableDictionary dictionary];
	workingQueue = [NSMutableArray array];
	return self;
}

- (id) API:(Class)apiHandlerClass {
	AZClientAPI *api = apis[apiHandlerClass];
	if (!api) {
		api = [apiHandlerClass new];
		api.apiProvider = self;
	}
	return api;
}

- (AZHTTPRequest *) queueRequest:(AZHTTPRequest *)request withType:(AZAPIRequestType)type forAPI:(AZClientAPI *)api {
	NSMutableDictionary *queue = masterQueue[QUEUE_IMPERATIVE];
	if (!queue) queue = masterQueue[QUEUE_IMPERATIVE] = [NSMutableDictionary dictionary];

	NSString *c = NSStringFromClass([api class]);
	NSMutableArray *apiQueue = queue[c];
	if (!apiQueue) apiQueue = queue[c] = [NSMutableArray array];
	[apiQueue addObject:request];

	[self processQueue:nil synchronously:NO];
	return request;
}

- (BOOL) processQueue:(NSMutableDictionary *)queue synchronously:(BOOL)sync {
	if (!queue) {
		if ([self processQueue:masterQueue[QUEUE_IMPERATIVE] synchronously:YES])
			return YES;

		return [self processQueue:masterQueue[QUEUE_CONSICUTIVE] synchronously:NO];
	}

	NSMutableSet *cleanup = queue[QUEUE_CLEANUP];
	[workingQueue removeObjectsInArray:[cleanup allObjects]];

	BOOL queued = NO;

	for (NSMutableArray *apiQueue in [queue allValues])
		if (apiQueue != (id)cleanup) {
			if (cleanup) {
				NSSet *inQueue = [NSSet setWithArray:apiQueue];
				[apiQueue removeObjectsInArray:[cleanup allObjects]];
				[cleanup minusSet:inQueue];
			}

			for (AZHTTPRequest *request in apiQueue) {
				[[[request error:^(AZHTTPRequest *action, NSString *response) {
					[self processError:action withResponse:response];
					return YES;
				} firstly:YES] success:^(AZHTTPRequest *action, id *data) {
					//				NSLog(@"Success call: %@", action);
					[self queue:queue cleanup:action];
					return YES;
				} firstly:YES] execute];

				[workingQueue addObject:request];
				queued = YES;

				if (sync) break;
			}

			if (queued) {
				[apiQueue removeObjectsInArray:workingQueue];
				if (sync)
					break;
			}
		}

	return queued;
}

- (BOOL) hasWorkingRequests {
	for (AZHTTPRequest *request in workingQueue)
		if (!request.finished)
			return YES;

	return NO;
}

- (BOOL) hasPendingRequests {
	for (NSDictionary *queues in [masterQueue allValues]) // imperative | consecutive
		for (NSDictionary *queue in [queues allValues]) // login | groups | text-edit
			for (NSArray *apiQueue in [queue allValues]) // groups::fetch | groups::add-group | groups::update-group
				if ([apiQueue count])
					return YES;

	return NO;
}


- (void) queue:(NSMutableDictionary *)queue cleanup:(id)request {
	NSMutableSet *cleanup = queue[QUEUE_CLEANUP];
	if (!cleanup) cleanup = queue[QUEUE_CLEANUP] = [NSMutableSet set];
	[cleanup addObject:request];
}

- (void) processError:(AZHTTPRequest *)action withResponse:(NSString *)response {
//	NSLog(@"Failed call: %@\n%@", action, response);
}

@end
