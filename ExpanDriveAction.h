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

}

- (int)selectedAction;
- (NSString *)selectedActionTitle;
- (ScriptBridgeDrive *)selectedDrive;

@end
