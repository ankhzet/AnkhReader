//
//  Utils.h
//  PhotoGallery
//
//  Created by Ankh on 01.01.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+AnkhUtils.h"
#import "NSColor+AnkhColors.h"
#import "NSURL+AnkhUtils.h"
#import "NSArray+AnkhUtils.h"

//#define API_ACTION_BASE_URL @"http://ankhzet.esy.es/api/client/"
#define API_ACTION_BASE_URL @"http://ankhzet.ua/api/client/"

// util functions
@interface AZUtils : NSObject

+ (void) notifyErrorMsg:(NSString *)error;

// applications document directory
+(NSURL *)applicationDocumentsDirectory;

@end
