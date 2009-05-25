#import <Cocoa/Cocoa.h>
#import <DDHidLib/DDHidLib.h>

typedef enum {	// choices for getDPad
	DPAD_UP,
	DPAD_DOWN, 
	DPAD_LEFT,
	DPAD_RIGHT
} Direction;

@interface Joystick : NSObject {
	DDHidJoystick* stick;	// currently connected joystick
	int stickIndex;			// connected joystick index (from all returned devices)
	
	DDHidElement* elementZ;
	DDHidElement* elementR;
	
	BOOL autoPoll;
	unsigned int buttonA;
	unsigned int buttonB;
	int lastX;
	int lastY;
	int lastButtons;
}

#pragma mark -
#pragma mark Methods

- (BOOL)setDevice:(unsigned int)index;
- (unsigned int)getDevice;
- (BOOL)isConnected;
- (void)setAutoPoll:(BOOL)enabled;
- (BOOL)getAutoPoll;
- (void)poll;
- (BOOL)hasZAxis;
- (BOOL)hasRAxis;
- (BOOL)hasPOV;
- (unsigned int)getNumButtons;
- (void)setButtonA:(unsigned int)button;
- (void)setButtonB:(unsigned int)button;
- (NSString*)getProductName;

#pragma mark -
#pragma mark Properties

- (int)getX;
- (int)getY;

- (int)getZ;
- (int)getR;

- (BOOL)getA;
- (BOOL)getB;

- (unsigned int)getButtons;
- (int)getPOV;
- (BOOL)getDPad:(Direction)direction;

@end

#pragma mark -

@interface Joystick (Protected)

- (void)setCurrentDevice:(DDHidJoystick*)device;
- (int)getElementValueWrapper:(DDHidElement*)element;
- (int)readX;
- (int)readY;
- (unsigned int)readButtons;

@end
