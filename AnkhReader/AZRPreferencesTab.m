//
//  AZRPreferencesTab.m
//  AnkhReader
//
//  Created by Ankh on 29.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRPreferencesTab.h"
#import "AZRTabsCommons.h"


@interface AZRPreferencesTab ()
@property (weak) IBOutlet NSTextField *tfServerAddress;
@property (weak) IBOutlet NSTextField *tfUserLogin;
@property (weak) IBOutlet NSSecureTextField *tfUserPassword;
@property (weak) IBOutlet NSButton *cbLoginAsGuest;
@property (weak) IBOutlet NSButton *cbLoginAutomatically;
@property (weak) IBOutlet NSButton *cbUIGroupPages;

@end

@implementation AZRPreferencesTab

- (NSString *) tabIdentifier {
	return AZRUIDPreferencesTab;
}

- (void) show {
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

	// server
	self.tfServerAddress.stringValue = PREF_STR(DEF_SERVER_ADDRESS);

	// user
	self.tfUserLogin.stringValue = PREF_STR(DEF_USER_LOGIN);
	self.tfUserPassword.stringValue = PREF_STR(DEF_USER_PASSWORD);

	BOOL asGuest = [ud boolForKey:DEF_USER_LOGIN_AS_GUEST];
	BOOL automatically = [ud boolForKey:DEF_USER_LOGIN_AUTOMATICALY];

	[self.cbLoginAsGuest setState:asGuest ? NSOnState : NSOffState];
	[self.cbLoginAutomatically setState:automatically ? NSOnState : NSOffState];

	// ui
	BOOL groupPages = [ud boolForKey:DEF_UI_GROUP_PAGES];

	[self.cbUIGroupPages setState:groupPages ? NSOnState : NSOffState];
}

- (BOOL) loginAsGuest {
	return [self.cbLoginAsGuest state] == NSOnState;
}

- (BOOL) loginAutomatically {
	return [self.cbLoginAutomatically state] == NSOnState;
}

- (IBAction)actionLoginAsGuestChecked:(id)sender {
	BOOL asGuest = [self loginAsGuest];

	[self.tfUserLogin setEnabled:!asGuest];
	[self.tfUserPassword setEnabled:!asGuest];

	if (asGuest) {
		[self.tfUserLogin setStringValue:@""];
		[self.tfUserPassword setStringValue:@""];
	} else {
		self.tfUserLogin.stringValue = PREF_STR(DEF_USER_LOGIN);
		self.tfUserPassword.stringValue = PREF_STR(DEF_USER_PASSWORD);
	}

	PREF_SAVE_BOOL(self.cbLoginAsGuest, DEF_USER_LOGIN_AS_GUEST);
}

- (IBAction)actionLoginAutomaticalyChecked:(id)sender {
	PREF_SAVE_BOOL(self.cbLoginAutomatically, DEF_USER_LOGIN_AUTOMATICALY);
}

- (IBAction)actionServerAddressChanged:(id)sender {
	PREF_SAVE_STR(self.tfServerAddress.stringValue, DEF_SERVER_ADDRESS);
}

- (IBAction)actionUserLoginChanged:(id)sender {
	PREF_SAVE_STR(self.tfUserLogin.stringValue, DEF_USER_LOGIN);
}

- (IBAction)actionUserPasswordChanged:(id)sender {
	PREF_SAVE_STR(self.tfUserPassword.stringValue, DEF_USER_PASSWORD);
}

- (IBAction)actionUIGroupPages:(id)sender {
	PREF_SAVE_BOOL(self.cbUIGroupPages, DEF_UI_GROUP_PAGES);
}

@end
