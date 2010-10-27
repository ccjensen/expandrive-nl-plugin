//
//  OptionSheetController.h
//  NetworkLocation
//
//  Created by Chris Farber on 9/24/06.
//  Copyright 2006 Chris Farber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NLAction.h"

@class NLAction;

/**
 * OptionSheetController serves two purposes: loading and managing the nib containing
 * the options interface for an action, and providing bindings access to the action's
 * options.
 *
 * You can subclass OptionSheetController to provide controller code for more complex
 * interfaces. Don't touch other methods, just create your own for use with the
 * interface.
 */
@interface OptionSheetController : NSWindowController {
    NLAction * action;
    NSBundle * nibBundle;
    NSMutableDictionary * options;
    NSWindow * parentWindow;
    @private
    id target;
    SEL selector;
    id contextInfo;
    BOOL cancelled;
    BOOL deleteIfCancelled;
}

@property (readonly) NLAction * action;
@property (readonly) NSBundle * nibBundle;
@property (readonly) NSMutableDictionary * options;
@property (readonly) NSWindow * parentWindow;

+ (id)optionSheetControllerWithNibName:(NSString *)nibName
                              inBundle:(NSBundle *)bundle
                             forAction:(NLAction *)anAction;

- (id)initWithWindowNibName:(NSString *)nibName inBundle:(NSBundle *)bundle
                  forAction:(NLAction *)anAction;


- (BOOL)cancelled;
- (void)setDeleteIfCancelled:(BOOL)deleteIfCancelled;
- (BOOL)deleteIfCancelled;
- (id)contextInfo;

- (void)closeSheet;
- (IBAction)cancel:(id)sender;
- (IBAction)setOptions:(id)sender;

- (void)setTarget:(id)aTarget selector:(SEL)aSelector 
      contextInfo:(id)context;

- (void)showSheetOnWindow:(NSWindow *)window;
- (void)showSheetAgain;

@end
