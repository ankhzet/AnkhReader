//
//  AZRLoginTab.h
//  AnkhReader
//
//  Created by Ankh on 28.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "AZRTabProvider.h"

@interface AZRLoginTab : AZRTabProvider
@property (weak) IBOutlet NSTextField *tfLogin;
@property (weak) IBOutlet NSSecureTextField *tfPassword;
@property (weak) IBOutlet NSButton *bLogin;
@property (weak) IBOutlet NSButton *cbLoginAsGuest;
@property (weak) IBOutlet NSButton *cbLoginAutomaticaly;

@end
