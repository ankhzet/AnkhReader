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

@interface AZRLoginTab () {
	BOOL autologin;
}

@property (nonatomic) BOOL loggingIn;

@end

@implementation AZRLoginTab

- (NSString *) tabIdentifier {
	return AZRUIDLoginTab;
}

- (void) show {
	self.loggingIn = NO;

	autologin = PREF_BOOL(DEF_USER_LOGIN_AUTOMATICALY);
	[self.cbLoginAutomaticaly setState:autologin ? NSOnState : NSOffState];
	autologin &= ![self.navData boolValue];

	[self setLoginAsGuest:PREF_BOOL(DEF_USER_LOGIN_AS_GUEST)];

	if (autologin) {
		double delayInSeconds = 0;//2.0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			if (autologin && !self.loggingIn)
				[self login:YES];
		});
	}
}

- (BOOL) loginAsGuest {
	return [self.cbLoginAsGuest state] == NSOnState;
}

- (BOOL) loginAutomatically {
	return [self.cbLoginAutomaticaly state] == NSOnState;
}

- (void) setLoggingIn:(BOOL)loggingIn {
	_loggingIn = loggingIn;
	[self.bLogin setEnabled:!loggingIn];
}

- (void) login:(BOOL)autoLogined {
	self.loggingIn = YES;

	AZRUserAPI *api = [[AZAPIProvider getInstance] API:[AZRUserAPI class]];

	[api unLogin];

	if ([self loginAsGuest]) {
		[[self tabs] navigateTo:AZRUIDUpdatesTab withNavData:nil];
		self.loggingIn = NO;
		return;
	}

	//autoLogined - login button not pressed, nor user login/password changed

	NSString *login = autoLogined ? PREF_STR(DEF_USER_LOGIN) : self.tfLogin.stringValue;
	NSString *password = autoLogined ? PREF_STR(DEF_USER_PASSWORD) : self.tfPassword.stringValue;

	[[api loginWithParams:@{@"login": login, @"pass": password} withCompletion:^(AZRUser *user) {
		if (user) {
			// successfuly logined - save credentials if configured for autologin
			if (PREF_BOOL(DEF_USER_LOGIN_AUTOMATICALY)) {
				PREF_SAVE_STR(login, DEF_USER_LOGIN);
				PREF_SAVE_STR(password, DEF_USER_PASSWORD);
			}

			[AZClientAPI onMain:^{
				[[self tabs] navigateTo:AZRUIDUpdatesTab withNavData:user];
			} synk:NO];
			return;
		} else
			[AZUtils notifyErrorMsg:@"Login failed"];

		self.loggingIn = NO;
	}] error:^BOOL(AZHTTPRequest *action, NSString *response) {
		self.loggingIn = NO;
		return YES;
	}];
}

- (IBAction)actionLogin:(id)sender {
	[self login:NO];
}

- (void) setLoginAsGuest:(BOOL)asGuest {
	[self.cbLoginAsGuest setState:asGuest ? NSOnState : NSOffState];
	[self.tfLogin setEnabled:!asGuest];
	[self.tfPassword setEnabled:!asGuest];

	if (asGuest) {
		[self.tfLogin setStringValue:@""];
		[self.tfPassword setStringValue:@""];
	} else {
		self.tfLogin.stringValue = PREF_STR(DEF_USER_LOGIN);
		self.tfPassword.stringValue = PREF_STR(DEF_USER_PASSWORD);
	}

	PREF_SAVE_UI_BOOL(self.cbLoginAsGuest, DEF_USER_LOGIN_AS_GUEST);
}

- (IBAction)actionLoginAsGuestChecked:(id)sender {
	[self setLoginAsGuest:[self loginAsGuest]];
}

- (IBAction)actionLoginAutomaticalyChecked:(id)sender {
	PREF_SAVE_UI_BOOL(self.cbLoginAutomaticaly, DEF_USER_LOGIN_AUTOMATICALY);
}

- (IBAction)actionUserLoginChanged:(id)sender {
	autologin = NO;
}

// proubably, can use [actionUserLoginChanged:] (but rename it ot smth like [actionUserCredentialsChanged:]
- (IBAction)actionUserPasswordChanged:(id)sender {
	autologin = NO;
}

@end
