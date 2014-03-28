//
//  AZRAPIAction.h
//  AnkhReader
//
//  Created by Ankh on 20.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AZRAPIAction;
typedef void(^AZRAPIExecutionCallbackBlock)(AZRAPIAction *action, id data);
typedef void(^AZRAPIExecutionErrorBlock)(AZRAPIAction *action, NSString *response);


@interface AZRAPIAction : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSDictionary *parameters;

+ (instancetype) actionWithName:(NSString *)name;

- (NSString *) url;

- (instancetype) execute;
- (instancetype) success:(AZRAPIExecutionCallbackBlock)block firstly:(BOOL)first;
- (instancetype) error:(AZRAPIExecutionErrorBlock)block firstly:(BOOL)first;

@end
