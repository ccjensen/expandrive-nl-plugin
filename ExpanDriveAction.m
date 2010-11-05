//
//  ExpanDriveAction.m
//  ExpanDriveNLPlugin
//
//  Created by Christopher Campbell Jensen on 10/26/10.
//

#import "ExpanDriveAction.h"
#import "ExpanDriveOptionSheetController.h"


@implementation ExpanDriveAction

/*  The action ID only has to be unique within the scope of the bundle.
 By default, NLAction will assume the action ID to be the name of the nib
 containing the option sheet.
 */
+ (NSString *)actionID
{
    return @"ExpanDriveAction";
}

/* the name that will appear in the "add action" sheet
 */
+ (NSString *)title
{
    return @"ExpanDrive…";
}

+ (NSImage *)icon
{
    static NSImage * icon = nil;
    if (!icon) {
        NSString * path = [[NSWorkspace sharedWorkspace] fullPathForApplication: @"ExpanDrive"];
        path = [path stringByAppendingPathComponent: @"Contents/Resources/ExpanDrive.icns"];
        icon = [[NSImage alloc] initWithContentsOfFile: path];
    }
    return icon;
}

/* hides plugin if application is not installed
 */
+ (BOOL)invisible
{
    NSString *path = [[NSWorkspace sharedWorkspace] fullPathForApplication: @"ExpanDrive"];
    return !path;
}

/*  this method is invoked to get a description of the action to show in the
 location's list of actions
 */
- (NSString *)title
{	
	NSString *title;
	NSString *action = [self selectedActionTitle];
	
	int performAction = [self selectedSingleOrMultiple];
	switch (performAction) {
		case PERFORMSINGLEACTION: {
			ScriptBridgeDrive *drive = [self selectedDrive];
			NSString *drivename = [drive drivename] ? [drive drivename] : @"";
			title = [NSString stringWithFormat:@"%@: %@", action, drivename];
			break;
		}
		case PERFORMMULTIPLEACTION: {
			NSString *driveContains = [self selectedDriveContains] ? [self selectedDriveContains] : @"";
			title = [NSString stringWithFormat:@"%@: %@", action, driveContains];
			break;
		}
		case PERFORMALLACTION: {
			title = [NSString stringWithFormat:@"%@: All drives", action];
			break;
		}
		default:
			title = [NSString stringWithFormat:@"%@: Unknown", action];
			break;
	}
	return title;
}

/* actually do the action
 */
- (void)performAction
{
	[self logString:[NSString stringWithFormat:@"ExpanDrivePlugin: %@", [self title]]];
	int performAction = [self selectedSingleOrMultiple];
	switch (performAction) {
		case PERFORMSINGLEACTION:
			[self performSingleAction];
			break;
		case PERFORMMULTIPLEACTION:
			[self performMultipleAction];
			break;
		case PERFORMALLACTION:
			[self performAllAction];
			break;
		default:
			[self logString:[NSString stringWithFormat:@"ERROR: Single or Multiple with id <%d> not recognised", performAction]];
			break;
	}
}

- (void)performSingleAction
{
	ScriptBridgeDrive *drive = [self selectedDrive];
	if (!drive) {
		//no valid drive object, skip action
		[self logString:[NSString stringWithFormat:@"ExpanDrivePlugin: Drive not found or not set."]];
		return;
	}
	
	int action = [self selectedAction];
	switch (action) {
		case ACTIONCONNECT:
			if (![drive isConnected]) {
				[drive connect];
				[self logString:[NSString stringWithFormat:@"Connected to %@", [[self selectedDrive] drivename]]];
			}
			break;
		case ACTIONEJECT:
			if ([drive isConnected]) {
				[drive eject];
				[self logString:[NSString stringWithFormat:@"Ejected %@", [[self selectedDrive] drivename]]];
			}
			break;
		default:
			[self logString:[NSString stringWithFormat:@"ERROR: Action with id <%d> not recognised", action]];
			break;
	}
}

- (void)performMultipleAction
{
	ScriptBridgeExpanDrive *expanDrive = [[self options] objectForKey:APPLICATIONKEY];
	
	NSString *driveProperty = [self selectedDriveproperty];
	NSString *driveContains = [self selectedDriveContains];
	
	int action = [self selectedAction];
	switch (action) {
		case ACTIONCONNECT: {
			NSArray *matchingDrives = [[expanDrive drives] filteredArrayUsingPredicate:
									   [NSPredicate predicateWithFormat:@"(isConnected == NO) AND (%K contains %@)", driveProperty, driveContains]];
			if ( [matchingDrives count] >= 1 ) {
				[self logString:[NSString stringWithFormat:@"Connecting %d drives...", [matchingDrives count]]];
				[matchingDrives makeObjectsPerformSelector:@selector(connect)];
			}
			[self logString:[NSString stringWithFormat:@"Connected to all ejected drives who's %@ contains %@", driveProperty, driveContains]];
		} break;
		case ACTIONEJECT: {
			NSArray *matchingDrives = [[expanDrive drives] filteredArrayUsingPredicate:
									   [NSPredicate predicateWithFormat:@"(isConnected == YES) AND (%K contains %@)", driveProperty, driveContains]];
			if ( [matchingDrives count] >= 1 ) {
				[self logString:[NSString stringWithFormat:@"Ejecting %d drives...", [matchingDrives count]]];
				[matchingDrives makeObjectsPerformSelector:@selector(eject)];
			}
			[self logString:[NSString stringWithFormat:@"Ejected all connected drives who's %@ contains %@", driveProperty, driveContains]];
		} break;
		default:
			[self logString:[NSString stringWithFormat:@"ERROR: Action with id <%d> not recognised"]];
			break;
	}
}

- (void)performAllAction
{
	ScriptBridgeExpanDrive *expanDrive = [[self options] objectForKey:APPLICATIONKEY];
	
	int action = [self selectedAction];
	switch (action) {
		case ACTIONCONNECT: {
			NSArray *matchingDrives = [[expanDrive drives] filteredArrayUsingPredicate:
									   [NSPredicate predicateWithFormat:@"(isConnected == NO)"]];
			if ( [matchingDrives count] >= 1 ) {
				[self logString:[NSString stringWithFormat:@"Connecting %d drives...", [matchingDrives count]]];
				[matchingDrives makeObjectsPerformSelector:@selector(connect)];
			}
			[self logString:[NSString stringWithFormat:@"Connected all ejected drives"]];
		} break;
		case ACTIONEJECT: {
			NSArray *matchingDrives = [[expanDrive drives] filteredArrayUsingPredicate:
									   [NSPredicate predicateWithFormat:@"(isConnected == YES)"]];
			if ( [matchingDrives count] >= 1 ) {
				[self logString:[NSString stringWithFormat:@"Ejecting %d drives...", [matchingDrives count]]];
				[matchingDrives makeObjectsPerformSelector:@selector(eject)];
			}
			[self logString:[NSString stringWithFormat:@"Ejected all connected drives"]];
		} break;
		default:
			[self logString:[NSString stringWithFormat:@"ERROR: Action with id <%d> not recognised"]];
			break;
	}
}

/*  perform cleanup when leaving the location or quitting the application
 this method must be defined, even if it does not do anything.
 */
- (void)cleanupAction
{
	
}

/**
 * In special cases, when bindings prove inadequate, you will need
 * to provide controller code for your option interface. To do this, you should
 * subclass OptionSheetController and override this method to return your subclass's
 * class. The default implementation of this method returns the class
 * OptionSheetController. The class returned by this method is instantiated and used
 * as the nib's owner.
 */
- (Class)optionSheetControllerClass
{
    return [ExpanDriveOptionSheetController class];
}

#pragma mark -
#pragma mark Added Methods
- (void)logString:(NSString *)log
{
	NSLog(@"ExpanDrivePlugin: %@", log);
}

- (int)selectedAction
{
	NSNumber *result = [[self options] objectForKey:ACTIONKEY];
	return [result intValue];
}

- (int)selectedSingleOrMultiple
{
	NSNumber *result = [[self options] objectForKey:PERFORMACTIONKEY];
	return [result intValue];
}

- (NSString *)selectedDriveproperty
{
	return [[self options] objectForKey:DRIVEPROPERTYKEY];
}

- (NSString *)selectedDriveContains
{
	return [[self options] objectForKey:DRIVECONTAINSKEY];
}

- (NSString *)selectedActionTitle
{
	NSMutableString *result = [NSMutableString string];
	int action = [self selectedAction];
	switch (action) {
		case ACTIONCONNECT:
			[result appendString:ACTIONCONNECTSTRING];
			break;
		case ACTIONEJECT:
			[result appendString:ACTIONEJECTSTRING];
			break;
		default:
			[result appendString:@"<Perform unknown action>"];
			break;
	}
	
	int performAction = [self selectedSingleOrMultiple];
	switch (performAction) {
		case PERFORMSINGLEACTION:
			//do nothing
			break;
		case PERFORMMULTIPLEACTION:
			[result appendFormat:@" all drives who's %@ property contains", [self selectedDriveproperty]];
			break;
		default:
			break;
	}
	
	return result;
}

- (ScriptBridgeDrive *)selectedDrive
{
	ScriptBridgeDrive *drive = (ScriptBridgeDrive *)[[self options] objectForKey:DRIVENAMEKEY];
	return [drive exists] ? drive : nil;
}

@end
