//
//  AZRAPILayer.h
//  AnkhReader
//
//  Created by Ankh on 20.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AZRAPIAction;
@interface AZRAPILayer : NSObject

- (AZRAPIAction *) action:(NSString *)actionName;

@end
