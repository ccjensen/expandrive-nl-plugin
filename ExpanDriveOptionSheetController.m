//
//  ExpanDriveOptionSheetController.m
//  ExpanDriveNLPlugin
//
//  Created by Christopher Campbell Jensen on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ExpanDriveOptionSheetController.h"

@implementation ExpanDriveOptionSheetController

- (void)awakeFromNib
{
	[drivenamesPopupButton removeAllItems];
	drives = [self retrieveDrives];
	[self populatePopupButton:drivenamesPopupButton];
	
	NSLog(@"drives: %@", drives);
}

- (SBElementArray *)retrieveDrives
{	
	ScriptBridgeExpanDrive *expanDrive = [SBApplication applicationWithBundleIdentifier:@"com.expandrive.ExpanDrive2"];
	return [expanDrive drives];
}

- (void)populatePopupButton:(NSPopUpButton *)popupButton
{
	if (![drives count]) {
		[drivenamesPopupButton addItemWithTitle:@"No drives created in ExpanDrive"];
		[self setSubmitState:NO];
	} else {
		[self setSubmitState:YES];
		for (ScriptBridgeDrive *drive in drives) {
			[popupButton addItemWithTitle:[drive drivename]];
		}
	}
}

- (void)setSubmitState:(BOOL)state
{
	[actionTypeMatrix setEnabled:state];
	[drivenamesPopupButton setEnabled:state];
	[saveButton setEnabled:state];
}

- (IBAction)actionChanged
{
	NSNumber *selectedCellTag = [[NSNumber alloc] initWithInt:[[actionTypeMatrix selectedCell] tag]];
	[options setValue:selectedCellTag forKey:ACTIONKEY];
	
}

- (IBAction)drivenameChanged
{
	ScriptBridgeDrive *selectedDrive = [drives objectAtIndex:[drivenamesPopupButton indexOfSelectedItem]];
	[options setValue:selectedDrive forKey:DRIVEKEY];
}

@end
