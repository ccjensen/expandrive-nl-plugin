//
//  ExpanDriveOptionSheetController.h
//  ExpanDriveNLPlugin
//
//  Created by Christopher Campbell Jensen on 10/26/10.
//

#import <Cocoa/Cocoa.h>
#import "OptionSheetController.h"
#import "ScriptBridge.h"

#define APPLICATIONKEY @"application"

#define PERFORMACTIONKEY @"performaction"
#define PERFORMSINGLEACTION 0
#define PERFORMMULTIPLEACTION 1
#define PERFORMALLACTION 2

#define ACTIONKEY @"action"
#define ACTIONCONNECT 0
#define ACTIONCONNECTSTRING @"Connect to"
#define ACTIONEJECT 1
#define ACTIONEJECTSTRING @"Eject"

//single
#define DRIVENAMEKEY @"drivename"

//multiple
#define DRIVEPROPERTYKEY @"driveproperty"
#define DRIVECONTAINSKEY @"drivecontains"

@interface ExpanDriveOptionSheetController : OptionSheetController {
	ScriptBridgeExpanDrive *expanDrive;
	NSArray *drives;
	NSArray *properties;
	
	IBOutlet NSTabView *tabView;
	IBOutlet NSButton *saveButton;
	
	//single
	IBOutlet NSMatrix *singleActionTypeMatrix;
	IBOutlet NSPopUpButton *drivenamesPopupButton;
	
	//multiple
	IBOutlet NSMatrix *multipleActionTypeMatrix;
	IBOutlet NSPopUpButton *drivepropertyPopupButton;
	IBOutlet NSTextField *drivecontainsTextField;
	
	//all
	IBOutlet NSMatrix *allActionTypeMatrix;
}

- (void)logString:(NSString *)log;

- (SBElementArray *)retrieveDrives;
- (NSArray *)retrieveDiskProperties;
- (void)populateDriveNamesPopupButton;
- (void)populateDrivepropertyPopupButton;
- (void)setSubmitState:(BOOL)state;

- (IBAction)actionChanged:(id)sender;
- (IBAction)save:(id)sender;

- (NSNumber *)valueOfActionMatrix;
- (ScriptBridgeDrive *)valueOfDrivenamePopupButton:(int)selectedTabIdentifier;
- (NSString *)valueOfDrivecontainsTextField:(int)selectedTabIdentifier;
- (NSString *)valueOfDrivepropertyPopupButton:(int)selectedTabIdentifier;

@end

