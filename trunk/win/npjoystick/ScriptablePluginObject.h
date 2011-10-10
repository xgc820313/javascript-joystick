#ifndef __PLUGIN_OBJECT_H__
#define __PLUGIN_OBJECT_H__

#include "ScriptablePluginObjectBase.h"
#include "Joystick.h"

#define NUM_METHODS 16
#define NUM_PROPERTIES 14

class ScriptablePluginObject : public ScriptablePluginObjectBase
{
private:
	Joystick stick;
	
	NPIdentifier getNumDevices_id;
	NPIdentifier setDevice_id;
	NPIdentifier getDevice_id;
	NPIdentifier isConnected_id;
	NPIdentifier setAutoPoll_id;
	NPIdentifier poll_id;
	NPIdentifier hasZAxis_id;
	NPIdentifier hasRAxis_id;
	NPIdentifier hasUAxis_id;
	NPIdentifier hasVAxis_id;
	NPIdentifier hasPOV_id;
	NPIdentifier getNumButtons_id;
	NPIdentifier setButtonA_id;
	NPIdentifier setButtonB_id;
	NPIdentifier calibrate_id;
	NPIdentifier getProductName_id;
	
	NPIdentifier propX_id;
	NPIdentifier propY_id;
	NPIdentifier propZ_id;
	NPIdentifier propR_id;
	NPIdentifier propU_id;
	NPIdentifier propV_id;
	NPIdentifier propA_id;
	NPIdentifier propB_id;
	NPIdentifier propButtons_id;
	NPIdentifier propPov_id;
	NPIdentifier propUp_id;
	NPIdentifier propDown_id;
	NPIdentifier propLeft_id;
	NPIdentifier propRight_id;
	
	NPIdentifier methodId[NUM_METHODS];
	NPIdentifier propertyId[NUM_PROPERTIES];
public:
	ScriptablePluginObject(NPP npp);
	
	virtual bool HasMethod(NPIdentifier name);
	virtual bool HasProperty(NPIdentifier name);
	virtual bool Invoke(NPIdentifier name, const NPVariant *args, uint32_t argCount, NPVariant *result);
	virtual bool InvokeDefault(const NPVariant *args, uint32_t argCount, NPVariant *result);
	virtual bool GetProperty(NPIdentifier name, NPVariant *result);
	virtual bool SetProperty(NPIdentifier name, const NPVariant *value);
	
	// allocates memory (via NPN_MemAlloc) and uses it to set a JS string (also fixes dealloc problem with Safari in the process)
	static void allocAndSetNPString(const char* str, NPVariant* result);
};

static NPObject* AllocateScriptablePluginObject(NPP npp, NPClass *aClass)
{
	return new ScriptablePluginObject(npp);
}

DECLARE_NPOBJECT_CLASS_WITH_BASE(ScriptablePluginObject, AllocateScriptablePluginObject);

#endif // __PLUGIN_OBJECT_H__