//
//  ExpanDriveOptionSheetController.h
//  ExpanDriveNLPlugin
//
//  Created by Christopher Campbell Jensen on 10/26/10.
//

#import <Cocoa/Cocoa.h>
#import "OptionSheetController.h"
#import "ScriptBridge.h"

@interface ExpanDriveOptionSheetController : OptionSheetController <NSTabViewDelegate> {
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

- (void)resetControlsToOptions:(NSDictionary *)selectedOptions;
- (IBAction)save:(id)sender;
- (void)updateSubmitState:(NSNumber *)tabIdentifier;

- (void)populateDriveNamesPopupButton;
- (void)populateDrivepropertyPopupButton;

- (SBElementArray *)retrieveDrives;
- (NSArray *)retrieveDiskProperties;

- (IBAction)actionChanged:(id)sender;

- (NSNumber *)valueOfActionMatrix;
- (NSString *)valueOfDrivenamePopupButton:(int)selectedTabIdentifier;
- (NSString *)valueOfDrivecontainsTextField:(int)selectedTabIdentifier;
- (NSString *)valueOfDrivepropertyPopupButton:(int)selectedTabIdentifier;

@end

