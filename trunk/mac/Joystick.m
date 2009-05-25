#import "Joystick.h"
#import <IOKit/hid/IOHIDUsageTables.h>

@implementation Joystick

- (id)init {
	if ((self = [super init]) != nil) {
		[self setDevice:0];
		autoPoll = YES;
		buttonA  = 1;
		buttonB  = 2;
	}
	return self;
}

- (void)dealloc {
	[self setCurrentDevice:nil];
	[super dealloc];
}

- (BOOL)setDevice:(unsigned int)index {
	NSArray* sticks = [DDHidJoystick allJoysticks];
	if (index >= 0 && index < [sticks count]) {
		[self setCurrentDevice:[sticks objectAtIndex:index]];
		stickIndex = index;
	} else {
		[self setCurrentDevice:nil];
		stickIndex = -1;
	}
	
	for (int n = 0; n < [stick countOfSticks]; n++) {
		DDHidJoystickStick* stickObj = [stick objectInSticksAtIndex:n];
		for (int i = 0; i < [stickObj countOfStickElements]; i++) {
			DDHidElement* element = [stickObj objectInStickElementsAtIndex: i];
			switch ([[element usage] usageId]) {
				case kHIDUsage_GD_Z:
					//elementZ = [element retain];
					break;
				case kHIDUsage_GD_Rz:
					//elementR = [element retain];
					break;
			}
		}
	}
	
	return [self isConnected];
}

- (unsigned int)getDevice {
	return stickIndex;
}

- (BOOL)isConnected {
	return stick != nil;
}

- (void)setAutoPoll:(BOOL)enabled {
	autoPoll = enabled;
}

- (BOOL)getAutoPoll {
	return autoPoll;
}

- (void)poll {
	if (!autoPoll) {
		lastX = [self readX];
		lastY = [self readY];
		lastButtons = [self readButtons];
	}
}

- (unsigned int)getNumButtons {
	return [stick numberOfButtons];
}

- (NSString*)getProductName {
	return [stick productName];
}

- (BOOL)hasPOV {
	@try {
		return [[stick objectInSticksAtIndex:0] countOfPovElements];
	}
	@catch (NSException* e) {
		[self setCurrentDevice:nil];
	}
	return NO;
}

- (int)getX {
	if (autoPoll) {
		return [self readX];
	} else {
		return lastX;
	}
}

- (int)getY {
	if (autoPoll) {
		return [self readY];
	} else {
		return lastY;
	}
}

- (int)getZ {
	return [self getElementValueWrapper:elementZ];
}

- (int)getR {
	return [self getElementValueWrapper:elementR];
}

- (BOOL)getA {
	return ([self getButtons] & buttonA) != 0;
}

- (BOOL)getB {
	return ([self getButtons] & buttonB) != 0;
}

- (unsigned int)getButtons {
	if (autoPoll) {
		return [self readButtons];
	} else {
		return lastButtons;
	}
}

- (int)getPOV {
	if ([self hasPOV]) {
		return [self getElementValueWrapper:[[stick objectInSticksAtIndex:0] objectInPovElementsAtIndex: 0]];
	} else {
		return -1;
	}
}

- (BOOL)getDPad:(Direction)direction {
	return NO;
}

- (void)setCurrentDevice:(DDHidJoystick*)device {
	[elementZ release];
	[elementR release];
	@try {
		[stick close];
	}
	@catch (NSException* e) {
		// ignore
	}
	[stick release];
	 stick = device;
	[stick retain];
	[stick open];
}

- (int)getElementValueWrapper:(DDHidElement*)element {
	if (element) {
		@try {
			return [stick getElementValue:element];
		}
		@catch (NSException* e) {
			[self setCurrentDevice:nil];
		}
	}
	return 0;
}

- (int)readX {
	return [self getElementValueWrapper:[[stick objectInSticksAtIndex:0] xAxisElement]] + 32768;
}
- (int)readY {
	return [self getElementValueWrapper:[[stick objectInSticksAtIndex:0] yAxisElement]] + 32768;
}
- (unsigned int)readButtons {
	unsigned int buttons = 0;
	for (int n = [stick numberOfButtons] - 1; n >= 0; n--) {
		buttons |= [self getElementValueWrapper:[[stick buttonElements] objectAtIndex:n]] << n;
	}
	return buttons;
}

@end
