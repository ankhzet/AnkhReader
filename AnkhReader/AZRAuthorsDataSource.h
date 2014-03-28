//
//  AZRJSONDateSource.h
//  AnkhReader
//
//  Created by Ankh on 21.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AZRAuthorsTableDelegate <NSObject>
- (void) objectSelected:(id)object;
@end

extern NSString *const AUTHOR_UID_COLLUMN;
extern NSString *const AUTHOR_UPDATED_COLLUMN;
extern NSString *const AUTHOR_UPDATES_COLLUMN;


@interface AZRAuthorsDataSource : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic) NSDictionary *data;
@property (nonatomic) id<AZRAuthorsTableDelegate> delegate;

- (void) rearrangeBy:(NSString *)collumn;

@end
