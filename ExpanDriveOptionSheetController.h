//
//  ExpanDriveOptionSheetController.h
//  ExpanDriveNLPlugin
//
//  Created by Christopher Campbell Jensen on 10/26/10.
//

#import <Cocoa/Cocoa.h>
#import "OptionSheetController.h"
#import "ScriptBridge.h"

#define ACTIONKEY @"action"
#define DRIVEKEY @"drivename"

#define ACTIONCONNECT 1
#define ACTIONCONNECTSTRING @"Connect to"
#define ACTIONDISCONNECT 0
#define ACTIONDISCONNECTSTRING @"Disconnect from"

@interface ExpanDriveOptionSheetController : OptionSheetController {
	NSArray *drives;
	
    IBOutlet NSPopUpButton *drivenamesPopupButton;
	IBOutlet NSMatrix *actionTypeMatrix;
	IBOutlet NSButton *saveButton;
}

- (SBElementArray *)retrieveDrives;
- (void)populatePopupButton:(NSPopUpButton *)popupButton;
- (void)setSubmitState:(BOOL)state;

- (void)storeDefaultOptions;
- (IBAction)actionChanged:(id)sender;
- (IBAction)drivenameChanged:(id)sender;

@end

