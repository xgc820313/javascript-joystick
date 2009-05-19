#ifndef __PLUGIN_BASE_H__
#define __PLUGIN_BASE_H__

#include "plugin.h"
#include "npupp.h"

#define DECLARE_NPOBJECT_CLASS_WITH_BASE(_class, ctor)                          \
	static NPClass s##_class##_NPClass = {                                      \
	NP_CLASS_STRUCT_VERSION,                                                    \
	ctor,                                                                       \
	ScriptablePluginObjectBase::_Deallocate,                                    \
	ScriptablePluginObjectBase::_Invalidate,                                    \
	ScriptablePluginObjectBase::_HasMethod,                                     \
	ScriptablePluginObjectBase::_Invoke,                                        \
	ScriptablePluginObjectBase::_InvokeDefault,                                 \
	ScriptablePluginObjectBase::_HasProperty,                                   \
	ScriptablePluginObjectBase::_GetProperty,                                   \
	ScriptablePluginObjectBase::_SetProperty,                                   \
	ScriptablePluginObjectBase::_RemoveProperty                                 \
}

#define GET_NPOBJECT_CLASS(_class) &s##_class##_NPClass

class ScriptablePluginObjectBase : public NPObject
{
public:
	ScriptablePluginObjectBase(NPP npp) : mNpp(npp)
	{
	}

	virtual ~ScriptablePluginObjectBase()
	{
	}

	// Virtual NPObject hooks called through this base class. Override as you
	// see fit.
	virtual void Invalidate();

	// Allows JavaScript to check if a method exists. Method names are converted
	// using NPN_GetStringIdentifier("foo")
	virtual bool HasMethod(NPIdentifier name);

	// Calls the method 'name' from JavaScript (with optional args)
	virtual bool Invoke(NPIdentifier name, const NPVariant *args, uint32_t argCount, NPVariant *result);

	// Called if the plugin is invoked like a method, e.g. document.getElementById("plugin")()
	virtual bool InvokeDefault(const NPVariant *args, uint32_t argCount, NPVariant *result);

	// As per HasMethod but for properties
	virtual bool HasProperty(NPIdentifier name);

	// Returns the property 'name'
	virtual bool GetProperty(NPIdentifier name, NPVariant *result);

	// Sets the property 'name'
	virtual bool SetProperty(NPIdentifier name, const NPVariant *value);
	
	virtual bool RemoveProperty(NPIdentifier name);

public:
	static void _Deallocate(NPObject *npobj);
	static void _Invalidate(NPObject *npobj);
	static bool _HasMethod(NPObject *npobj, NPIdentifier name);
	static bool _Invoke(NPObject *npobj, NPIdentifier name, const NPVariant *args, uint32_t argCount, NPVariant *result);
	static bool _InvokeDefault(NPObject *npobj, const NPVariant *args, uint32_t argCount, NPVariant *result);
	static bool _HasProperty(NPObject * npobj, NPIdentifier name);
	static bool _GetProperty(NPObject *npobj, NPIdentifier name, NPVariant *result);
	static bool _SetProperty(NPObject *npobj, NPIdentifier name, const NPVariant *value);
	static bool _RemoveProperty(NPObject *npobj, NPIdentifier name);

protected:
	NPP mNpp;
};

#endif // __PLUGIN_BASE_H__