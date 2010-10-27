//
//  ExpanDriveAction.m
//  ExpanDriveNLPlugin
//
//  Created by Christopher Campbell Jensen on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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
        NSString * path = [[NSWorkspace sharedWorkspace] 
                           fullPathForApplication: @"ExpanDrive"];
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
	return [NSString stringWithFormat:@"Connect to %@", @"temp"];
}

/* actually do the action
 */
- (void)performAction
{
	NSString *getActionString = [[NSString alloc] initWithFormat:@"options.%@", ACTIONKEY];
	NSString *getDriveString = [[NSString alloc] initWithFormat:@"options.%@", DRIVEKEY];
	
	NSLog(@"action: %@ to %@", [self valueForKeyPath:getActionString], [self valueForKeyPath:getDriveString]);
}

/*  perform cleanup when leaving the location or quitting the application
 this method must be defined, even if it does not do anything.
 */
- (void)cleanupAction
{
	
}

/* Returns the overridden thingy */
- (Class)optionSheetControllerClass
{
    return [ExpanDriveOptionSheetController class];
} 

@end
