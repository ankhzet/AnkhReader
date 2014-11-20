//
//  AZRSyncedScrollView.h
//  AnkhReader
//
//  Created by Ankh on 17.11.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol AZRSyncedScrollViewProtocol <NSObject>

- (void) frame:(NSScrollView *)view sizeChanged:(NSSize)size;

@end

@interface AZRSyncedScrollView : NSScrollView

@property (nonatomic, weak) id<AZRSyncedScrollViewProtocol> delegate;

@end
