// JoystickCtl.h : Declaration of the CJoystickCtl
#pragma once
#include "resource.h"       // main symbols
#include <atlctl.h>
#include "iejoystick.h"
#include "Joystick.h"

// CJoystickCtl
class ATL_NO_VTABLE CJoystickCtl :
	public CComObjectRootEx<CComSingleThreadModel>,
	public IDispatchImpl<IJoystickCtl, &IID_IJoystickCtl, &LIBID_iejoystickLib, /*wMajor =*/ 1, /*wMinor =*/ 0>,
	public IPersistStreamInitImpl<CJoystickCtl>,
	public IOleControlImpl<CJoystickCtl>,
	public IOleObjectImpl<CJoystickCtl>,
	public IOleInPlaceActiveObjectImpl<CJoystickCtl>,
	public IViewObjectExImpl<CJoystickCtl>,
	public IOleInPlaceObjectWindowlessImpl<CJoystickCtl>,
	public IObjectSafetyImpl<CJoystickCtl, INTERFACESAFE_FOR_UNTRUSTED_CALLER | INTERFACESAFE_FOR_UNTRUSTED_DATA>,
	public CComCoClass<CJoystickCtl, &CLSID_JoystickCtl>,
	public CComControl<CJoystickCtl>
{
public:
	CJoystickCtl();

DECLARE_OLEMISC_STATUS(OLEMISC_RECOMPOSEONRESIZE |
	OLEMISC_INVISIBLEATRUNTIME |
	OLEMISC_CANTLINKINSIDE |
	OLEMISC_INSIDEOUT |
	OLEMISC_ACTIVATEWHENVISIBLE |
	OLEMISC_SETCLIENTSITEFIRST
)

DECLARE_REGISTRY_RESOURCEID(IDR_JOYSTICKCTL)

BEGIN_COM_MAP(CJoystickCtl)
	COM_INTERFACE_ENTRY(IJoystickCtl)
	COM_INTERFACE_ENTRY(IDispatch)
	COM_INTERFACE_ENTRY(IViewObjectEx)
	COM_INTERFACE_ENTRY(IViewObject2)
	COM_INTERFACE_ENTRY(IViewObject)
	COM_INTERFACE_ENTRY(IOleInPlaceObjectWindowless)
	COM_INTERFACE_ENTRY(IOleInPlaceObject)
	COM_INTERFACE_ENTRY2(IOleWindow, IOleInPlaceObjectWindowless)
	COM_INTERFACE_ENTRY(IOleInPlaceActiveObject)
	COM_INTERFACE_ENTRY(IOleControl)
	COM_INTERFACE_ENTRY(IOleObject)
	COM_INTERFACE_ENTRY(IPersistStreamInit)
	COM_INTERFACE_ENTRY2(IPersist, IPersistStreamInit)
	COM_INTERFACE_ENTRY_IID(IID_IObjectSafety, IObjectSafety)
END_COM_MAP()

BEGIN_PROP_MAP(CJoystickCtl)
	PROP_DATA_ENTRY("_cx", m_sizeExtent.cx, VT_UI4)
	PROP_DATA_ENTRY("_cy", m_sizeExtent.cy, VT_UI4)
END_PROP_MAP()


BEGIN_MSG_MAP(CJoystickCtl)
	CHAIN_MSG_MAP(CComControl<CJoystickCtl>)
	DEFAULT_REFLECTION_HANDLER()
END_MSG_MAP()

// IViewObjectEx
	DECLARE_VIEW_STATUS(VIEWSTATUS_SOLIDBKGND | VIEWSTATUS_OPAQUE)

// IJoystickCtl
public:
	STDMETHOD(setDevice)(/*[in]*/ UINT device, /*[out, retval]*/ VARIANT_BOOL *pVal);
	STDMETHOD(getDevice)(/*[out, retval]*/ UINT *pVal);
	STDMETHOD(isConnected)(/*[out, retval]*/ VARIANT_BOOL *pVal);
	STDMETHOD(setAutoPoll)(/*[in]*/ VARIANT_BOOL autoPoll);
	STDMETHOD(poll)();
	STDMETHOD(hasZAxis)(/*[out, retval]*/ VARIANT_BOOL *pVal);
	STDMETHOD(hasRAxis)(/*[out, retval]*/ VARIANT_BOOL *pVal);
	STDMETHOD(hasPOV)(/*[out, retval]*/ VARIANT_BOOL *pVal);
	STDMETHOD(getNumButtons)(/*[out, retval]*/ UINT *pVal);
	STDMETHOD(setButtonA)(/*[in]*/ UINT button);
	STDMETHOD(setButtonB)(/*[in]*/ UINT button);
	STDMETHOD(calibrate)();
	STDMETHOD(getProductName)(/*[out, retval]*/ BSTR *pName);
	
	STDMETHOD(get_x)(/*[out, retval]*/ DWORD *pVal);
	STDMETHOD(get_y)(/*[out, retval]*/ DWORD *pVal);
	STDMETHOD(get_z)(/*[out, retval]*/ DWORD *pVal);
	STDMETHOD(get_r)(/*[out, retval]*/ DWORD *pVal);
	STDMETHOD(get_a)(/*[out, retval]*/ VARIANT_BOOL *pVal);
	STDMETHOD(get_b)(/*[out, retval]*/ VARIANT_BOOL *pVal);
	STDMETHOD(get_buttons)(/*[out, retval]*/ DWORD *pVal);
	STDMETHOD(get_pov)(/*[out, retval]*/ DWORD *pVal);
	STDMETHOD(get_up)(/*[out, retval]*/ VARIANT_BOOL *pVal);
	STDMETHOD(get_down)(/*[out, retval]*/ VARIANT_BOOL *pVal);
	STDMETHOD(get_left)(/*[out, retval]*/ VARIANT_BOOL *pVal);
	STDMETHOD(get_right)(/*[out, retval]*/ VARIANT_BOOL *pVal);

	HRESULT OnDraw(ATL_DRAWINFO& di);

	DECLARE_PROTECT_FINAL_CONSTRUCT()

	HRESULT FinalConstruct()
	{
		return S_OK;
	}

	void FinalRelease()
	{
	}

private:
	Joystick stick;
};

OBJECT_ENTRY_AUTO(__uuidof(JoystickCtl), CJoystickCtl)
