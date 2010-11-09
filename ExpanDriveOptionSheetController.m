//
//  ExpanDriveOptionSheetController.m
//  ExpanDriveNLPlugin
//
//  Created by Christopher Campbell Jensen on 10/26/10.
//

#import "ExpanDriveOptionSheetController.h"
#import "Constants.h"

#define SingleActionWindowHeight 175
#define MultipleActionExtraHeight 36

@implementation ExpanDriveOptionSheetController

- (void)awakeFromNib
{
	expanDrive = [SBApplication applicationWithBundleIdentifier:APPLICATIONBUNDLEIDENTIFIER];
	[drivenamesPopupButton removeAllItems];
	drives = [[NSArray arrayWithArray:[self retrieveDrives]] retain];
	properties = [[self retrieveDiskProperties] retain];
	
	[self populateDriveNamesPopupButton];
	[self populateDrivepropertyPopupButton];
	
	//if the sheet is being reopened, we want the current settings entered into the sheet
	NSLog(@"ExpanDrivePluginOptionsSheet: loading [options]: %@", [self options]);
	if ([[self options] count]) {
		[self resetControlsToOptions:[self options]];
	}
	[self tabView:tabView willSelectTabViewItem:[tabView selectedTabViewItem]];
}

- (void)dealloc
{
	[drives release];
	[properties release];
	
	[super dealloc];
}

- (void)resetControlsToOptions:(NSDictionary *)selectedOptions
{
	//set all action type controls
	[singleActionTypeMatrix selectCellWithTag:[[selectedOptions objectForKey:ACTIONKEY] intValue]];
	[self actionChanged:singleActionTypeMatrix];
	
	//single sheet controls
	[drivenamesPopupButton selectItemWithTitle:[selectedOptions objectForKey:DRIVENAMEKEY]];
	
	//multiple sheet controls
	[drivepropertyPopupButton selectItemWithTitle:[selectedOptions objectForKey:DRIVEPROPERTYKEY]];
	[drivecontainsTextField setStringValue:[selectedOptions objectForKey:DRIVECONTAINSKEY]];
	
	[tabView selectTabViewItemWithIdentifier:[selectedOptions objectForKey:PERFORMACTIONKEY]];
}

- (IBAction)save:(id)sender
{
	NSNumber *selectedTab = (NSNumber *)[[tabView selectedTabViewItem] identifier];
	[options setValue:selectedTab forKey:PERFORMACTIONKEY];
	[options setValue:[self valueOfActionMatrix] forKey:ACTIONKEY];
	
	//single
	[options setValue:[self valueOfDrivenamePopupButton:[selectedTab intValue]] forKey:DRIVENAMEKEY];
	
	//multiple
	[options setValue:[self valueOfDrivepropertyPopupButton:[selectedTab intValue]] forKey:DRIVEPROPERTYKEY];
	[options setValue:[self valueOfDrivecontainsTextField:[selectedTab intValue]] forKey:DRIVECONTAINSKEY];
	
	//all
	//only needs the actionMatrix value
	
	NSLog(@"ExpanDrivePluginOptionsSheet: storing [options]: %@", [self options]);
	[self setOptions:[self window]];
}

- (void)updateSubmitState:(NSNumber *)tabIdentifier
{
	//check if controls should be activated for current window
	BOOL state;
	switch ([tabIdentifier intValue]) {

		case PERFORMSINGLEACTION: {
			state = [drives count] ? YES : NO;
			
			[singleActionTypeMatrix setEnabled:state];
			[drivenamesPopupButton setEnabled:state];
		} break;
			
		case PERFORMMULTIPLEACTION: {
			state = YES;
		} break;
			
		case PERFORMALLACTION: {
			state = YES;
		} break;
	}
	[saveButton setEnabled:state];
}

#pragma mark -
#pragma mark Set up Controls
- (void)populateDriveNamesPopupButton
{
	if ([drives count]) {
		for (ScriptBridgeDrive *drive in drives) {
			[drivenamesPopupButton addItemWithTitle:[drive drivename]];
		}
	} else {
		[drivenamesPopupButton addItemWithTitle:@"No drives in ExpanDrive"];
	}
}

- (void)populateDrivepropertyPopupButton
{
	for (NSString *property in properties) {
		[drivepropertyPopupButton addItemWithTitle:property];
	}
}

- (SBElementArray *)retrieveDrives
{	
	return [expanDrive drives];
}

- (NSArray *)retrieveDiskProperties
{
	return [NSArray arrayWithObjects:@"drivename", @"server", @"url", @"remotePath", nil];
}

#pragma mark -
#pragma mark NSTabViewDelegate Methods
- (void)tabView:(NSTabView *)aTabView willSelectTabViewItem:(NSTabViewItem *)aTabViewItem
{	
	NSNumber *identifier = (NSNumber *)[aTabViewItem identifier];
	[self updateSubmitState:identifier];
}

#pragma mark -
#pragma mark Synchronise controls
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


#pragma mark -
#pragma mark Get current values of controls
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
	return [NSNumber numberWithInt:value];
}

#pragma mark Single Drive Actions
- (NSString *)valueOfDrivenamePopupButton:(int)selectedTabIdentifier
{
	NSString *value;
	int index = [drivenamesPopupButton indexOfSelectedItem];
	//check that an item is selected, -1 indicates none selected
	if (index != -1) {
		value = [[drivenamesPopupButton itemAtIndex:index] title];
	} else {
		value = [NSString stringWithString:@""];
	}
	return value;
}

#pragma mark Multiple Drive Actions
- (NSString *)valueOfDrivecontainsTextField:(int)selectedTabIdentifier
{	
	return [drivecontainsTextField stringValue];
}

- (NSString *)valueOfDrivepropertyPopupButton:(int)selectedTabIdentifier
{
	NSString *value;
	
	int index = [drivepropertyPopupButton indexOfSelectedItem];
	//check that an item is selected, -1 indicates none selected
	if (index != -1) {
		value = [[drivepropertyPopupButton selectedItem] title];
	} else {
		value = [NSString stringWithString:@""];
	}
	return value;
}



@end
