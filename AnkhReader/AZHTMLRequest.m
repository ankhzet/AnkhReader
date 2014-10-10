//
//  AZHTMLRequest.m
//  AZClientAPI
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZHTMLRequest.h"

@implementation AZHTMLRequest

- (id)init {
	if (!(self = [super init]))
		return self;


	[self success:^(AZHTTPRequest *action, id *data) {
		if (![*data isKindOfClass:[NSData class]]) {
			action->errorBlock(action, [NSString stringWithFormat:@"API response must be a NSData (%@ returned)", [*data className]]);
			return NO;
		}

		//todo: tfhpple framework include
		/*
		 CFStringRef cfEncodingStr = nil;
		 CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(action.encoding);
		 if (cfEncoding != kCFStringEncodingInvalidId) {
		 cfEncodingStr = CFStringConvertEncodingToIANACharSetName(cfEncoding);
		 }
		 NSString *encoding = (__bridge NSString *)cfEncodingStr;

		 TFHpple *document = [[TFHpple alloc] initWithHTMLData:aquiredData encoding:encoding];

		 if (!document) {
		 errorBlock(self, @"HTML response parse error");
		 return;
		 }

		 if (![document isKindOfClass:[TFHpple class]]) {
		 errorBlock(self, @"API call returns non-html result");
		 return;
		 }

		 successBlock(self, document);
		 */

		return YES;
	} firstly:YES];

	return self;
}

@end
