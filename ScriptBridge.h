/*
 * ScriptBridge.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class ScriptBridgeExpanDrive, ScriptBridgeDrive;



/*
 * ExpanDrive Terminology
 */

// An application's top level scripting object.
@interface ScriptBridgeExpanDrive : SBApplication

- (SBElementArray *) drives;

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the frontmost (active) application?
@property (copy, readonly) NSString *version;  // The version of the application.

- (void) connect:(id)x;  // Connect the drive to its server.

@end

@interface ScriptBridgeDrive : SBObject

@property (copy) NSString *server;  // The server
@property (copy) NSString *username;  // The username
@property (copy) NSString *port;  // The port
@property (copy) NSString *drivename;  // The name / nickname / mount point for the drive
@property (readonly) BOOL isConnected;  // True if the drive is currently connected / mounted.
@property (copy, readonly) NSString *url;  // The unique server url.
@property (copy) NSString *remotePath;  // The path on the server to connect to.

- (void) delete;  // Delete an object.
- (BOOL) exists;  // Verify if an object exists.
- (void) connect;  // Connect the drive to its server.
- (void) eject;  // Eject the drive by disconnecting it from the server.

@end

