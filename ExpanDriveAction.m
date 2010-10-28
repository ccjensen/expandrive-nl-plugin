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
	NSString *action = [self selectedActionTitle];
	ScriptBridgeDrive *drive = [self selectedDrive];
	
	NSString *drivename = [drive drivename] ? [drive drivename] : @"<Drive deleted?>";
	return [NSString stringWithFormat:@"%@ %@", action, drivename];
}

/* actually do the action
 */
- (void)performAction
{
	ScriptBridgeDrive *drive = [self selectedDrive];
	if (!drive) {
		//no valid drive object, skip action
		NSLog(@"ERROR - ExpanDrivePlugin: Drive not found. Has it been deleted?");
		return;
	}
	
	int action = [self selectedAction];
	switch (action) {
		case ACTIONCONNECT:
			if (![drive isConnected])
				[drive connect];
			break;
		case ACTIONDISCONNECT:
			if ([drive isConnected])
				[drive eject];
			break;
		default:
			NSLog(@"ERROR - ExpanDrivePlugin: Action with id <%d> not recognised");
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
- (int)selectedAction
{
	NSNumber *result = [[self options] objectForKey:ACTIONKEY];
	return [result intValue];
}

- (NSString *)selectedActionTitle
{
	NSString *result;
	int tag = [self selectedAction];
	switch (tag) {
		case ACTIONCONNECT:
			result = ACTIONCONNECTSTRING;
			break;
		case ACTIONDISCONNECT:
			result = ACTIONDISCONNECTSTRING;
			break;
		default:
			result = @"Unknown Action for";
			break;
	}
	return result;
}

- (ScriptBridgeDrive *)selectedDrive
{
	ScriptBridgeDrive *drive = (ScriptBridgeDrive *)[[self options] objectForKey:DRIVEKEY];
	return [drive exists] ? drive : nil;
}

@end
