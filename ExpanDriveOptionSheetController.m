//
//  ExpanDriveOptionSheetController.m
//  ExpanDriveNLPlugin
//
//  Created by Christopher Campbell Jensen on 10/26/10.
//

#import "ExpanDriveOptionSheetController.h"
#import <objc/runtime.h>

@implementation ExpanDriveOptionSheetController

- (void)awakeFromNib
{
	expanDrive = [SBApplication applicationWithBundleIdentifier:@"com.expandrive.ExpanDrive2"];
	[drivenamesPopupButton removeAllItems];
	drives = [[NSArray arrayWithArray:[self retrieveDrives]] retain];
	properties = [[self retrieveDiskProperties] retain];
	
	[self populateDriveNamesPopupButton];
	[self populateDrivepropertyPopupButton];
}

- (void)dealloc
{
	[drives release];
	[properties release];
	
	[super dealloc];
}

- (void)logString:(NSString *)log
{
	NSLog(@"ExpanDrivePluginOptionsSheet: %@", log);
}

- (SBElementArray *)retrieveDrives
{	
	return [expanDrive drives];
}

- (NSArray *)retrieveDiskProperties
{
	return [NSArray arrayWithObjects:@"server", @"drivename", @"url", @"remotePath", nil];
}

- (void)setSubmitState:(BOOL)state
{
	[singleActionTypeMatrix setEnabled:state];
	[drivenamesPopupButton setEnabled:state];
	[saveButton setEnabled:state];
}

// synchronises all actionTypeMatrix's
- (IBAction)actionChanged:(id)sender
{
	int tag = 0;
	if ([sender isEqual:singleActionTypeMatrix]) {
		tag = [[singleActionTypeMatrix selectedCell] tag];
		[multipleActionTypeMatrix selectCellWithTag:tag];
		[allActionTypeMatrix selectCellWithTag:tag];
	} else if ([sender isEqual:multipleActionTypeMatrix]) {
		tag = [[multipleActionTypeMatrix selectedCell] tag];
		[singleActionTypeMatrix selectCellWithTag:tag];
		[allActionTypeMatrix selectCellWithTag:tag];
	} else if ([sender isEqual:allActionTypeMatrix]) {
		tag = [[allActionTypeMatrix selectedCell] tag];	
		[singleActionTypeMatrix selectCellWithTag:tag];
		[multipleActionTypeMatrix selectCellWithTag:tag];
	}
}

- (IBAction)save:(id)sender
{
	NSNumber *selectedTab = (NSNumber *)[[tabView selectedTabViewItem] identifier];
	[options setValue:selectedTab forKey:PERFORMACTIONKEY];
	[options setValue:[self valueOfActionMatrix] forKey:ACTIONKEY];
	
	//single
	[options setValue:[self valueOfDrivenamePopupButton:[selectedTab intValue]] forKey:DRIVENAMEKEY];
	
	//multiple
	[options setValue:expanDrive forKey:APPLICATIONKEY];
	[options setValue:[self valueOfDrivepropertyPopupButton:[selectedTab intValue]] forKey:DRIVEPROPERTYKEY];
	[options setValue:[self valueOfDrivecontainsTextField:[selectedTab intValue]] forKey:DRIVECONTAINSKEY];
	
	[self setOptions:[self window]];
}

- (NSNumber *)valueOfActionMatrix
{
	NSNumber *selectedTab = (NSNumber *)[[tabView selectedTabViewItem] identifier];	
	int value = 0;
	switch ([selectedTab intValue]) {
		case PERFORMSINGLEACTION:
			value = [[singleActionTypeMatrix selectedCell] tag];
			break;
		case PERFORMMULTIPLEACTION:
			value = [[multipleActionTypeMatrix selectedCell] tag];
			break;
		case PERFORMALLACTION:
			value = [[allActionTypeMatrix selectedCell] tag];
			break;
		default:
			break;
	}
	[self logString:[NSString stringWithFormat:@"Action set to: [%d]", value]];
	return [NSNumber numberWithInt:value];
}

#pragma mark -
#pragma mark Single Drive Actions
- (ScriptBridgeDrive *)valueOfDrivenamePopupButton:(int)selectedTabIdentifier
{
	ScriptBridgeDrive *value = nil;
	
	if (selectedTabIdentifier == PERFORMSINGLEACTION) {
		//single tab selected
		int index = [drivenamesPopupButton indexOfSelectedItem];
		//check that an item is selected, -1 indicates none selected
		if (index != -1) {
			value = [drives objectAtIndex:index];
		}
	}
	[self logString:[NSString stringWithFormat:@"Drive name set to: [%@]", value]];
	return value;
}

- (void)populateDriveNamesPopupButton
{
	if ([drives count]) {
		[self setSubmitState:YES];
		for (ScriptBridgeDrive *drive in drives) {
			[drivenamesPopupButton addItemWithTitle:[drive drivename]];
		}
	} else {
		[self setSubmitState:NO];
		[drivenamesPopupButton addItemWithTitle:@"No drives created in ExpanDrive"];
	}
}

#pragma mark -
#pragma mark Multiple Drive Actions
- (NSString *)valueOfDrivecontainsTextField:(int)selectedTabIdentifier
{
	NSString *value = nil;
	
	if (selectedTabIdentifier == PERFORMMULTIPLEACTION) {
		//single tab selected
		value = [drivecontainsTextField stringValue];
	}
	[self logString:[NSString stringWithFormat:@"Drive contains set to: [%@]", value]];
	return value;
}

- (NSString *)valueOfDrivepropertyPopupButton:(int)selectedTabIdentifier
{
	NSString *value = nil;
	
	if (selectedTabIdentifier == PERFORMMULTIPLEACTION) {
		//single tab selected
		int index = [drivepropertyPopupButton indexOfSelectedItem];
		//check that an item is selected, -1 indicates none selected
		if (index != -1) {
			value = [[drivepropertyPopupButton selectedItem] title];
		}
	}
	[self logString:[NSString stringWithFormat:@"Drive property set to: [%@]", value]];
	return value;
}

- (void)populateDrivepropertyPopupButton
{
	for (NSString *property in properties) {
		[drivepropertyPopupButton addItemWithTitle:property];
	}
}

@end
