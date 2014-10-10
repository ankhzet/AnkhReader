//
//  AZRAppCommons.h
//  AnkhReader
//
//  Created by Ankh on 09.10.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#ifndef AnkhReader_AZRAppCommons_h
#define AnkhReader_AZRAppCommons_h


#define PREF_SAVE_STR(_string, _pref_key) \
	[[NSUserDefaults standardUserDefaults] setObject:(_string) forKey:(_pref_key)];

#define PREF_SAVE_BOOL(_bool, _pref_key) \
	[[NSUserDefaults standardUserDefaults] setBool:!!_bool forKey:(_pref_key)];

#define PREF_SAVE_UI_STR(_string, _pref_key) \
	PREF_SAVE_STR((_string.stringValue, _pref_key) \

#define PREF_SAVE_UI_BOOL(_checkbox, _pref_key) \
	PREF_SAVE_BOOL(([(_checkbox) state] == NSOnState), _pref_key)

#define PREF_STR(_key)\
	({id value = [[NSUserDefaults standardUserDefaults] stringForKey:(_key)]; (value != nil) ? value : @"";})

#define PREF_BOOL(_key)\
	({[[NSUserDefaults standardUserDefaults] boolForKey:(_key)];})



#define DEF_SERVER_ADDRESS @"server.address"

#define DEF_USER_LOGIN_AS_GUEST @"user.login_as_guest"
#define DEF_USER_LOGIN_AUTOMATICALY @"user.login_automaticaly"

#define DEF_USER_LOGIN @"user.login"
#define DEF_USER_PASSWORD @"user.password"

#define DEF_UI_GROUP_PAGES @"ui.group_pages"

#endif
