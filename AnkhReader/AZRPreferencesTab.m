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
	// server
	self.tfServerAddress.stringValue = PREF_STR(DEF_SERVER_ADDRESS);

	// user
	BOOL automatically = PREF_BOOL(DEF_USER_LOGIN_AUTOMATICALY);
	[self.cbLoginAutomatically setState:automatically ? NSOnState : NSOffState];

	[self setLoginAsGuest:PREF_BOOL(DEF_USER_LOGIN_AS_GUEST)];

	// ui
	BOOL groupPages = PREF_BOOL(DEF_UI_GROUP_PAGES);

	[self.cbUIGroupPages setState:groupPages ? NSOnState : NSOffState];
}

- (BOOL) loginAsGuest {
	return [self.cbLoginAsGuest state] == NSOnState;
}

- (BOOL) loginAutomatically {
	return [self.cbLoginAutomatically state] == NSOnState;
}

- (void) setLoginAsGuest:(BOOL)asGuest {
	[self.cbLoginAsGuest setState:asGuest ? NSOnState : NSOffState];

	[self.tfUserLogin setEnabled:!asGuest];
	[self.tfUserPassword setEnabled:!asGuest];

	if (asGuest) {
		[self.tfUserLogin setStringValue:@""];
		[self.tfUserPassword setStringValue:@""];
	} else {
		self.tfUserLogin.stringValue = PREF_STR(DEF_USER_LOGIN);
		self.tfUserPassword.stringValue = PREF_STR(DEF_USER_PASSWORD);
	}

	PREF_SAVE_UI_BOOL(self.cbLoginAsGuest, DEF_USER_LOGIN_AS_GUEST);
}

- (IBAction)actionLoginAsGuestChecked:(id)sender {
	[self setLoginAsGuest:[self loginAsGuest]];
}

- (IBAction)actionLoginAutomaticalyChecked:(id)sender {
	PREF_SAVE_UI_BOOL(self.cbLoginAutomatically, DEF_USER_LOGIN_AUTOMATICALY);
}

- (IBAction)actionServerAddressChanged:(id)sender {
	PREF_SAVE_UI_STR(self.tfServerAddress, DEF_SERVER_ADDRESS);
}

- (IBAction)actionUserLoginChanged:(id)sender {
	PREF_SAVE_UI_STR(self.tfUserLogin, DEF_USER_LOGIN);
}

- (IBAction)actionUserPasswordChanged:(id)sender {
	PREF_SAVE_UI_STR(self.tfUserPassword, DEF_USER_PASSWORD);
}

- (IBAction)actionUIGroupPages:(id)sender {
	PREF_SAVE_UI_BOOL(self.cbUIGroupPages, DEF_UI_GROUP_PAGES);
}

@end
