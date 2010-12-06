#include "ScriptablePluginObject.h"

ScriptablePluginObject::ScriptablePluginObject(NPP npp) : ScriptablePluginObjectBase(npp), stick() {
	getNumDevices_id  = methodId[0]  = NPN_GetStringIdentifier("getNumDevices");
	setDevice_id      = methodId[1]  = NPN_GetStringIdentifier("setDevice");
	getDevice_id      = methodId[2]  = NPN_GetStringIdentifier("getDevice");
	isConnected_id    = methodId[3]  = NPN_GetStringIdentifier("isConnected");
	setAutoPoll_id    = methodId[4]  = NPN_GetStringIdentifier("setAutoPoll");
	poll_id           = methodId[5]  = NPN_GetStringIdentifier("poll");
	hasZAxis_id       = methodId[6]  = NPN_GetStringIdentifier("hasZAxis");
	hasRAxis_id       = methodId[7]  = NPN_GetStringIdentifier("hasRAxis");
	hasPOV_id         = methodId[8]  = NPN_GetStringIdentifier("hasPOV");
	getNumButtons_id  = methodId[9]  = NPN_GetStringIdentifier("getNumButtons");
	setButtonA_id     = methodId[10] = NPN_GetStringIdentifier("setButtonA");
	setButtonB_id     = methodId[11] = NPN_GetStringIdentifier("setButtonB");
	calibrate_id      = methodId[12] = NPN_GetStringIdentifier("calibrate");
	getProductName_id = methodId[13] = NPN_GetStringIdentifier("getProductName");
	
	propX_id = propertyId[0] = NPN_GetStringIdentifier("x");
	propY_id = propertyId[1] = NPN_GetStringIdentifier("y");
	propZ_id = propertyId[2] = NPN_GetStringIdentifier("z");
	propR_id = propertyId[3] = NPN_GetStringIdentifier("r");
	propA_id = propertyId[4] = NPN_GetStringIdentifier("a");
	propB_id = propertyId[5] = NPN_GetStringIdentifier("b");
	propButtons_id = propertyId[6]  = NPN_GetStringIdentifier("buttons");
	propPov_id     = propertyId[7]  = NPN_GetStringIdentifier("pov");
	propUp_id      = propertyId[8]  = NPN_GetStringIdentifier("up");
	propDown_id    = propertyId[9]  = NPN_GetStringIdentifier("down");
	propLeft_id    = propertyId[10] = NPN_GetStringIdentifier("left");
	propRight_id   = propertyId[11] = NPN_GetStringIdentifier("right");
}

bool ScriptablePluginObject::HasMethod(NPIdentifier name) {
	for (int n = 0; n < NUM_METHODS; n++) {
		if (name == methodId[n]) {
			return PR_TRUE;
		}
	}
	return PR_FALSE;
}

bool ScriptablePluginObject::Invoke(NPIdentifier name, const NPVariant* args, uint32_t argCount, NPVariant* result) {
	if (!HasMethod(name)) {
		VOID_TO_NPVARIANT(*result); // return void if the method doesn't exist
		return PR_FALSE;
	}
	if (argCount > 0) {
		if (NPVARIANT_IS_INT32(args[0]) || NPVARIANT_IS_DOUBLE(args[0])) { // Firefox sends ints, Safari doubles
			uint32_t val = 0;
			if (NPVARIANT_IS_INT32(args[0])) {
				val = NPVARIANT_TO_INT32(args[0]);
			} else {
				val = (uint32_t) NPVARIANT_TO_DOUBLE(args[0]);
			}
			if (name == setDevice_id) {
				BOOLEAN_TO_NPVARIANT(stick.setDevice(val), *result);
			} else if (name == setButtonA_id) {
				stick.setButtonA(val);
			} else if (name == setButtonB_id) {
				stick.setButtonB(val);
			}
			return PR_TRUE;
		}
		if (NPVARIANT_IS_BOOLEAN(args[0])) {
			bool val = NPVARIANT_TO_BOOLEAN(args[0]);
			if (name == setAutoPoll_id) {
				stick.setAutoPoll(val);
			}
			return PR_TRUE;
		}
	} else {
		if (name == getNumDevices_id) {
			INT32_TO_NPVARIANT(stick.getNumDevices(), *result);
		} else if (name == getDevice_id) {
			INT32_TO_NPVARIANT(stick.getDevice(), *result);
		} else if (name == isConnected_id) {
			BOOLEAN_TO_NPVARIANT(stick.isConnected(), *result);
		} else if (name == poll_id) {
			stick.poll();
		} else if (name == hasZAxis_id) {
			BOOLEAN_TO_NPVARIANT(stick.hasZAxis(), *result);
		} else if (name == hasRAxis_id) {
			BOOLEAN_TO_NPVARIANT(stick.hasRAxis(), *result);
		} else if (name == hasPOV_id) {
			BOOLEAN_TO_NPVARIANT(stick.hasPOV(), *result);
		} else if (name == getNumButtons_id) {
			INT32_TO_NPVARIANT(stick.getNumButtons(), *result);
		} else if (name == calibrate_id) {
			stick.calibrate();
		} else if (name == getProductName_id) {
			allocAndSetNPString(stick.getProductName(), result);
		}
		return PR_TRUE;
	}
	VOID_TO_NPVARIANT(*result);
	return PR_FALSE;
}


bool ScriptablePluginObject::InvokeDefault(const NPVariant *args, uint32_t argCount, NPVariant *result) {
	return PR_FALSE;
}

bool ScriptablePluginObject::HasProperty(NPIdentifier name) {
	for (int n = 0; n < NUM_PROPERTIES; n++) {
		if (name == propertyId[n]) {
			return PR_TRUE;
		}
	}
	return PR_FALSE;
}

bool ScriptablePluginObject::GetProperty(NPIdentifier name, NPVariant* result) {
	if (!HasProperty(name)) {
		VOID_TO_NPVARIANT(*result); // return void if the property doesn't exist
		return PR_FALSE;
	} else if (name == propX_id) {
		INT32_TO_NPVARIANT(stick.getX(), *result);
	} else if (name == propY_id) {
		INT32_TO_NPVARIANT(stick.getY(), *result);
	} else if (name == propZ_id) {
		INT32_TO_NPVARIANT(stick.getZ(), *result);
	} else if (name == propR_id) {
		INT32_TO_NPVARIANT(stick.getR(), *result);
	} else if (name == propA_id) {
		BOOLEAN_TO_NPVARIANT(stick.getA(), *result);
	} else if (name == propB_id) {
		BOOLEAN_TO_NPVARIANT(stick.getB(), *result);
	} else if (name == propButtons_id) {
		INT32_TO_NPVARIANT(stick.getButtons(), *result);
	} else if (name == propPov_id) {
		INT32_TO_NPVARIANT(stick.getPOV(), *result);
	} else if (name == propUp_id) {
		BOOLEAN_TO_NPVARIANT(stick.getDPad(Joystick::DPAD_UP), *result);
	} else if (name == propDown_id) {
		BOOLEAN_TO_NPVARIANT(stick.getDPad(Joystick::DPAD_DOWN), *result);
	} else if (name == propLeft_id) {
		BOOLEAN_TO_NPVARIANT(stick.getDPad(Joystick::DPAD_LEFT), *result);
	} else if (name == propRight_id) {
		BOOLEAN_TO_NPVARIANT(stick.getDPad(Joystick::DPAD_RIGHT), *result);
	}
	return PR_TRUE;
}

bool ScriptablePluginObject::SetProperty(NPIdentifier name, const NPVariant* value) {
	return PR_FALSE;
}

void ScriptablePluginObject::allocAndSetNPString(const char* str, NPVariant* result) {
	size_t len = strlen(str);
	char* out = (char*) NPN_MemAlloc((uint32) len + 1);
	strcpy_s(out, len + 1, str);
	STRINGN_TO_NPVARIANT(out, (uint32) len, *result);
}
