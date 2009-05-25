#import <Cocoa/Cocoa.h>
#import <Joystick.h>

@interface JoystickPlugin : NSView <WebPlugInViewFactory> {
	Joystick* stick;
}

- (NSValue*)setDevice:(int)index;
- (int)getDevice;
- (NSValue*)isConnected;
- (int)getNumButtons;
- (NSString*)getProductName;

@end
