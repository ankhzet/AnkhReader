//
//  AZRReaderTab.m
//  AnkhReader
//
//  Created by Ankh on 03.02.15.
//  Copyright (c) 2015 Ankh. All rights reserved.
//

#import "AZRReaderTab.h"
#import <WebKit/WebKit.h>

NSString *const AZRReaderNavDataKey = @"AZRReaderNavDataKey";

@interface AZRReaderTab ()

@property (weak) IBOutlet WebView *wvWebView;

@end

@implementation AZRReaderTab

- (NSString *) tabIdentifier {
	return AZRUIDReaderTab;
}

- (void) updateContents {
	NSString *data = [self.navData valueForKey:AZRReaderNavDataKey];

	[[self.wvWebView mainFrame] loadHTMLString:data baseURL:PREF_STR(DEF_SERVER_ADDRESS)];
}

@end
