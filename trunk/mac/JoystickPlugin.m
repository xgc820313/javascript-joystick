#import "JoystickPlugin.h"

@interface JoystickPlugin (Internal)
- (id)_initWithArguments:(NSDictionary *)arguments;
@end

@implementation JoystickPlugin

#pragma mark -
#pragma mark Initialisation and Allocation

+ (NSView*)plugInViewWithArguments:(NSDictionary*)newArguments {
	return [[[self alloc] _initWithArguments:newArguments] autorelease];
}

- (void)webPlugInInitialize {
	[stick release];
	 stick = [[[Joystick alloc] init] retain];
}

- (void)webPlugInDestroy {
	[stick release];
	 stick = nil;
}

- (id)objectForWebScript {
	return self;
}

#pragma mark -
#pragma mark Exposed methods

- (NSValue*)setDevice:(int)index {
	return [NSNumber numberWithBool:[stick setDevice:index]];
}

- (int)getDevice {
	return [stick getDevice];
}

- (NSValue*)isConnected {
	return [NSNumber numberWithBool:[stick isConnected]];
}

- (int)getNumButtons {
	return [stick getNumButtons];
}

- (NSString*)getProductName {
	return [stick getProductName];
}

#pragma mark -
#pragma mark WebScripting informal protocal

+ (NSString*)webScriptNameForSelector:(SEL)selector {
	if(selector == @selector(setDevice:)) {
		return @"setDevice";
	}
	return nil;
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)selector {
	if (selector == @selector(setDevice:) ||
		selector == @selector(getDevice) ||
		selector == @selector(isConnected) ||
		selector == @selector(getNumButtons) ||
		selector == @selector(getProductName)) {
		return NO;
	}
	return YES;
}

+ (BOOL)isKeyExcludedFromWebScript:(const char *)name {
	return NO;
}

- (NSArray*)attributeKeys {
    return [NSArray arrayWithObjects:@"x", @"y", @"z", @"r", @"a", @"b", @"buttons", @"pov", @"up", @"down", @"left", @"right", nil];
}

- (id)valueForKey:(NSString *)key {
	NSArray* attrs = [self attributeKeys];
	switch ([attrs indexOfObject:key]) {
		case 0:
			return [NSNumber numberWithInt:[stick getX]];
		case 1:
			return [NSNumber numberWithInt:[stick getY]];
		case 2:
			return [NSNumber numberWithInt:[stick getZ]];
		case 3:
			return [NSNumber numberWithInt:[stick getR]];
		case 4:
			return [NSNumber numberWithBool:[stick getA]];
		case 5:
			return [NSNumber numberWithBool:[stick getB]];
		case 6:
			return [NSNumber numberWithInt:[stick getButtons]];
		case 7:
			return [NSNumber numberWithInt:[stick getPOV]];
		default:
			return nil;
	}
}

@end

#pragma mark -

@implementation JoystickPlugin (Internal)

- (id)_initWithArguments:(NSDictionary *)newArguments {
	if (!(self = [super initWithFrame:NSZeroRect])) {
		return nil;
	}
    return self;
}

@end
