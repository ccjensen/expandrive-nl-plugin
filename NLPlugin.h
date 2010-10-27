//
//  NLPlugin.h
//  NetworkLocation
//
//  Created by Chris Farber on 2/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * There should be one subclass of NLPlugin in your plugin bundle. This subclass
 * should be your bundle's principal class. NLPlugin serves two purposes, the first
 * of which is managing certain responsibilites. The second purpose is to inform
 * NetworkLocation what actions are provided by the plugin, and hold any common code
 * useful to other classes (such as NLAction subclasses).
 */
@class NLAction;

@interface NLPlugin : NSObject {
    @private
    NSBundle * pluginBundle;
    NSDictionary * actionsByID;
}

+ (id)pluginForClass:(Class)aClass;

- (id)initInBundle:(NSBundle *)bundle;

- (NLAction *)actionForID:(NSString *)actionID;
- (NSBundle *)bundle;

//Must be overriden
//Return an array of the classes of NLAction in your plugin.
/**
 * This is the only method you must implement in your subclass. Since there's no
 * good way to autodetect the NLAction subclasses within the bundle, or at least I
 * haven't found a suitable way yet, you have to implement this method to let
 * NetworkLocation know.
 * Here's an example implementation:
 *
 * - (NSArray *)actions
 * {
 *   return [NSArray arrayWithObject:[MySuperCoolNLActionSubclass class]];
 * }
 *
 * Note that you can use this method 
 */
- (NSArray *)actions;

@end
