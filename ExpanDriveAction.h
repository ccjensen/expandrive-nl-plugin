//
//  ExpanDriveAction.h
//  ExpanDriveNLPlugin
//
//  Created by Christopher Campbell Jensen on 10/26/10.
//

#import <Cocoa/Cocoa.h>
#import "NLAction.h"
#import "ScriptBridge.h"

@interface ExpanDriveAction : NLAction {
	ScriptBridgeExpanDrive *expanDrive;
}

@property (readonly) ScriptBridgeExpanDrive *expanDrive;

- (void)logString:(NSString *)log;

- (void)performSingleAction;
- (void)performMultipleAction;
- (void)performAllAction;

- (int)selectedAction;
- (int)selectedSingleOrMultiple;
- (NSString *)selectedDriveproperty;
- (NSString *)selectedActionTitle;
- (NSString *)selectedDriveContains;
- (ScriptBridgeDrive *)selectedDrive;

@end
