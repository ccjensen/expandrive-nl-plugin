//
//  ExpanDriveOptionSheetController.m
//  ExpanDriveNLPlugin
//
//  Created by Christopher Campbell Jensen on 10/26/10.
//

#import "ExpanDriveOptionSheetController.h"

@implementation ExpanDriveOptionSheetController

- (void)awakeFromNib
{
	[drivenamesPopupButton removeAllItems];
	drives = [[NSArray alloc] initWithArray:[self retrieveDrives]];
	[self populatePopupButton:drivenamesPopupButton];
}

- (SBElementArray *)retrieveDrives
{	
	ScriptBridgeExpanDrive *expanDrive = [SBApplication applicationWithBundleIdentifier:@"com.expandrive.ExpanDrive2"];
	return [expanDrive drives];
}

- (void)populatePopupButton:(NSPopUpButton *)popupButton
{
	if ([drives count]) {
		[self setSubmitState:YES];
		for (ScriptBridgeDrive *drive in drives) {
			[popupButton addItemWithTitle:[drive drivename]];
		}
		[self storeDefaultOptions];
	} else {
		[self setSubmitState:NO];
		[drivenamesPopupButton addItemWithTitle:@"No drives created in ExpanDrive"];
	}
}

- (void)setSubmitState:(BOOL)state
{
	[actionTypeMatrix setEnabled:state];
	[drivenamesPopupButton setEnabled:state];
	[saveButton setEnabled:state];
}

- (void)storeDefaultOptions
{
	[self actionChanged:nil];
	[self drivenameChanged:nil];
}

- (IBAction)actionChanged:(id)sender
{	
	int tag = [[actionTypeMatrix selectedCell] tag];
	NSNumber *actionNumber = [[NSNumber alloc] initWithInt:tag];
	[options setValue:actionNumber forKey:ACTIONKEY];
}

- (IBAction)drivenameChanged:(id)sender
{
	int index = [drivenamesPopupButton indexOfSelectedItem];
	//check that an item is selected, -1 indicates none selected
	if (index != -1) {
		ScriptBridgeDrive *selectedDrive = [drives objectAtIndex:index];
		[options setValue:selectedDrive forKey:DRIVEKEY];
	}
}

@end
