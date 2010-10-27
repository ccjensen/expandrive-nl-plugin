//
//  ExpanDriveOptionSheetController.h
//  ExpanDriveNLPlugin
//
//  Created by Christopher Campbell Jensen on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OptionSheetController.h"
#import "ScriptBridge.h"

#define ACTIONKEY @"action"
#define DRIVEKEY @"drivename"

#define ACTIONCONNECT 1
#define ACTIONDISCONNECT 0

@interface ExpanDriveOptionSheetController : OptionSheetController {
	SBElementArray *drives;
	
    IBOutlet NSPopUpButton *drivenamesPopupButton;
	IBOutlet NSMatrix *actionTypeMatrix;
	IBOutlet NSButton *saveButton;
}

- (SBElementArray *)retrieveDrives;
- (void)populatePopupButton:(NSPopUpButton *)popupButton;
- (void)setSubmitState:(BOOL)state;

- (IBAction)actionChanged;
- (IBAction)drivenameChanged;

@end

