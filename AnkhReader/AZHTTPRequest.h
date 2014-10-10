//
//  AZRAPIAction.h
//  AZClientAPI
//
//  Created by Ankh on 20.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AZAPIRequestType) {
	AZAPIRequestTypeDefault    = 0,
	AZAPIRequestTypeImperative = 1 << 0,
};


@class AZHTTPRequest;
typedef BOOL(^AZRAPIExecutionCallbackBlock)(AZHTTPRequest *action, id *data);
typedef BOOL(^AZRAPIExecutionErrorBlock)(AZHTTPRequest *action, NSString *response);


@interface AZHTTPRequest : NSObject <NSURLConnectionDataDelegate> {
@protected
	AZRAPIExecutionCallbackBlock successBlock;
	AZRAPIExecutionErrorBlock errorBlock;
	NSData *aquiredData;
}

@property (nonatomic) NSString *name;
@property (nonatomic) NSDictionary *parameters;

@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic) NSString *httpMethod;
@property (nonatomic) NSString *referrer;
@property (nonatomic) BOOL isPost;
@property (nonatomic) NSStringEncoding encoding;

@property long long expectedBytes;
@property long long loadedBytes;

@property NSHTTPURLResponse *response;
@property BOOL successful;
@property BOOL interrupt;
@property BOOL finished;

+ (instancetype) actionWithName:(NSString *)name;

- (NSString *) url;

- (AZHTTPRequest *) execute;
- (instancetype) success:(AZRAPIExecutionCallbackBlock)block firstly:(BOOL)first;
- (instancetype) error:(AZRAPIExecutionErrorBlock)block firstly:(BOOL)first;
- (instancetype) success:(AZRAPIExecutionCallbackBlock)block;
- (instancetype) error:(AZRAPIExecutionErrorBlock)block;

@end

@interface AZHTTPRequest (NSURLConnectionDownloadDelegate)
@end
