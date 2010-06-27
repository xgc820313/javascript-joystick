#include "Joystick.h"

Joystick::Joystick() : device(0), autoPoll(true), buttonA(JOY_BUTTON1), buttonB(JOY_BUTTON2) {
	ZeroMemory(&joyInfoEx, sizeof(joyInfoEx));
	joyInfoEx.dwSize = sizeof(joyInfoEx);
	setDevice(device);
}

Joystick::~Joystick() {}

bool Joystick::setDevice(int index) {
	device = index;
	ZeroMemory(&joyCaps, sizeof(joyCaps));
	joyGetDevCaps(device, &joyCaps, sizeof(joyCaps));
	return isConnected();
}

int Joystick::getDevice() {
	return device;
}

bool Joystick::isConnected() {
	return joyGetPosEx(device, &joyInfoEx) == JOYERR_NOERROR;
}

void Joystick::setAutoPoll(bool enabled) {
	if (!enabled) {
		joyInfoEx.dwFlags = JOY_RETURNBUTTONS | JOY_RETURNX | JOY_RETURNY | JOY_RETURNZ | JOY_RETURNR | JOY_RETURNPOV;
	}
	autoPoll = enabled;
}

bool Joystick::getAutoPoll() {
	return autoPoll;
}

void Joystick::poll() {
	if (!autoPoll) {
		joyGetPosEx(device, &joyInfoEx);
	}
}

bool Joystick::hasZAxis() {
	return (joyCaps.wCaps & JOYCAPS_HASZ) != 0;
}

bool Joystick::hasRAxis() {
	return (joyCaps.wCaps & JOYCAPS_HASR) != 0;
}

bool Joystick::hasPOV() {
	return (joyCaps.wCaps & JOYCAPS_HASPOV) != 0;
}

int Joystick::getNumButtons() {
	return joyCaps.wNumButtons;
}

void Joystick::setButtonA(int button) {
	if (button >= 0 && button < (signed) joyCaps.wNumButtons) {
		buttonA = 1 << button;
	}
}

void Joystick::setButtonB(int button) {
	if (button >= 0 && button < (signed) joyCaps.wNumButtons) {
		buttonB = 1 << button;
	}
}

void Joystick::calibrate() {
	WinExec("control joy.cpl", SW_NORMAL);
}

char* Joystick::getProductName() {
	return joyCaps.szPname;
}

int Joystick::getX() {
	if (autoPoll) {
		joyInfoEx.dwFlags = JOY_RETURNX;
		joyGetPosEx(device, &joyInfoEx);
	}
	return joyInfoEx.dwXpos;
}

int Joystick::getY() {
	if (autoPoll) {
		joyInfoEx.dwFlags = JOY_RETURNY;
		joyGetPosEx(device, &joyInfoEx);
	}
	return joyInfoEx.dwYpos;
}

int Joystick::getZ() {
	if (autoPoll) {
		joyInfoEx.dwFlags = JOY_RETURNZ;
		joyGetPosEx(device, &joyInfoEx);
	}
	return joyInfoEx.dwZpos;
}

int Joystick::getR() {
	if (autoPoll) {
		joyInfoEx.dwFlags = JOY_RETURNR;
		joyGetPosEx(device, &joyInfoEx);
	}
	return joyInfoEx.dwRpos;
}

bool Joystick::getA() {
	return (getButtons() & buttonA) != 0;
}

bool Joystick::getB() {
	return (getButtons() & buttonB) != 0;
}

int Joystick::getButtons() {
	if (autoPoll) {
		joyInfoEx.dwFlags = JOY_RETURNBUTTONS;
		joyGetPosEx(device, &joyInfoEx);
	}
	return joyInfoEx.dwButtons;
}

int Joystick::getPOV() {
	if (autoPoll) {
		joyInfoEx.dwFlags = JOY_RETURNPOV;
		joyGetPosEx(device, &joyInfoEx);
	}
	return joyInfoEx.dwPOV;
}

bool Joystick::getDPad(Direction direction) {
	switch (direction) {
		case DPAD_UP:
			return getY() < 28672;
		case DPAD_DOWN:
			return getY() > 36864;
		case DPAD_LEFT:
			return getX() < 28672;
		case DPAD_RIGHT:
			return getX() > 36864;
	}
	return false;

}