//
//  AZRAPILayerSpec.m
//  AnkhReader
//  Spec for AZRAPILayer
//
//  Created by Ankh on 20.07.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "Kiwi.h"
#import "AZClientAPI.h"
#import "AZRAPIAction.h"

SPEC_BEGIN(AZRAPILayerSpec)

describe(@"AZRAPILayer", ^{
	it(@"should properly initialize", ^{
		AZClientAPI *instance = [AZClientAPI new];
		[[instance shouldNot] beNil];
		[[instance should] beKindOfClass:[AZClientAPI class]];
	});

	it(@"should well form api uri's", ^{
		AZClientAPI *api = [AZClientAPI new];

		AZRAPIAction *action = [api action:@"users"];
		[[action shouldNot] beNil];

		[[[action url] should] equal:@"http://ankhzet.ua/clientapi.json?api-action=users"];

		[action setParameters:@{@"id": @(16)}];
		[[[action url] should] equal:@"http://ankhzet.ua/clientapi.json?api-action=users&id=16"];

		[action setParameters:@{@"uri": @(false), @"titles": @[@"t1", @"t2"]}];
		[[[action url] should] equal:@"http://ankhzet.ua/clientapi.json?api-action=users&uri=0&titles[]=t1&titles[]=t2"];

		[action setParameters:@{@"count": @(0), @"actions": @{@"a1": @"action1", @"a2": @"action2"}}];
		[[[action url] should] equal:@"http://ankhzet.ua/clientapi.json?api-action=users&count=0&actions['a2']=action2&actions['a1']=action1"];
	});
});

SPEC_END
