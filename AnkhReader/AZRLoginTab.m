//
//  AZRLoginTab.m
//  AnkhReader
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRLoginTab.h"
#import "AZRTabsCommons.h"

#import "AZAPIProvider.h"
#import "AZRUserAPI.h"

#define DEF_LOGIN_AS_GUEST @"login.login_as_guest"
#define DEF_LOGIN_AUTOMATICALY @"login.login_automaticaly"

#define DEF_LOGIN @"login.login"
#define DEF_PASSWORD @"login.password"

@implementation AZRLoginTab {
	BOOL loggingIn;
}

- (NSString *) tabIdentifier {
	return AZRUIDLoginTab;
}

- (void) show {
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	BOOL asGuest = [ud boolForKey:DEF_LOGIN_AS_GUEST];
	BOOL automatically = [ud boolForKey:DEF_LOGIN_AUTOMATICALY];

	[self.cbLoginAsGuest setState:asGuest ? NSOnState : NSOffState];
	[self.cbLoginAutomaticaly setState:automatically ? NSOnState : NSOffState];

	self.tfLogin.stringValue = [ud stringForKey:DEF_LOGIN];
	self.tfPassword.stringValue = [ud stringForKey:DEF_PASSWORD];

	loggingIn = NO;
	if (automatically) {
		double delayInSeconds = 0;//2.0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			if ([self loginAutomatically] && !loggingIn)
				[self actionLogin:nil];
		});
	}
}

- (IBAction)actionLogin:(id)sender {
	[self.bLogin setEnabled:NO];

	loggingIn = YES;
	if ([self loginAsGuest]) {
		[[self tabs] navigateTo:AZRUIDUpdatesTab withNavData:nil];

		return;
	}

	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	BOOL automatically = [ud boolForKey:DEF_LOGIN_AUTOMATICALY];

	NSString *login = self.tfLogin.stringValue;
	NSString *password = self.tfPassword.stringValue;

	if (automatically) {
		NSString *storedLogin = [ud stringForKey:DEF_LOGIN];
		NSString *storedPassword = [ud stringForKey:DEF_PASSWORD];
		login = storedLogin ? storedLogin : login;
		password = storedPassword ? storedPassword : password;
	}

	AZRUserAPI *api = [[AZAPIProvider getInstance] API:[AZRUserAPI class]];

	[api loginWithParams:@{@"login": login, @"pass": password} withCompletion:^(AZRUser *user) {
		if (user) {
			[ud setObject:login forKey:DEF_LOGIN];
			[ud setObject:password forKey:DEF_PASSWORD];

			[AZClientAPI onMain:^{
				[[self tabs] navigateTo:AZRUIDUpdatesTab withNavData:user];
			} synk:NO];
			return;
		} else
			[AZUtils notifyErrorMsg:@"Login failed"];

		[self.bLogin setEnabled:YES];
	}];
}

- (IBAction)actionLoginAsGuestChecked:(id)sender {
	BOOL asGuest = [self loginAsGuest];
	[self.tfLogin setEnabled:!asGuest];
	[self.tfPassword setEnabled:!asGuest];

	[[NSUserDefaults standardUserDefaults] setBool:asGuest forKey:DEF_LOGIN_AS_GUEST];
}

- (IBAction)actionLoginAutomaticalyChecked:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:[self loginAutomatically] forKey:DEF_LOGIN_AUTOMATICALY];
}

- (BOOL) loginAsGuest {
	return [self.cbLoginAsGuest state] == NSOnState;
}

- (BOOL) loginAutomatically {
	return [self.cbLoginAutomaticaly state] == NSOnState;
}

@end
