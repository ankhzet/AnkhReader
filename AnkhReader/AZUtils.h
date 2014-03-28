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

// util functions
@interface AZUtils : NSObject

+ (void) notifyErrorMsg:(NSString *)error;

// applications document directory
+(NSURL *)applicationDocumentsDirectory;

@end
