// JoystickCtl.cpp : Implementation of CJoystickCtl
#include "stdafx.h"
#include "JoystickCtl.h"

CJoystickCtl::CJoystickCtl() {
	stick = Joystick();
}

STDMETHODIMP CJoystickCtl::setDevice(UINT device, VARIANT_BOOL *pVal) {
	*pVal = stick.setDevice(device);
	return S_OK;
}

STDMETHODIMP CJoystickCtl::getDevice(UINT *pVal) {
	*pVal = stick.getDevice();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::isConnected(VARIANT_BOOL *pVal) {
	*pVal = stick.isConnected();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::setAutoPoll(VARIANT_BOOL autoPoll) {
	stick.setAutoPoll(autoPoll != 0);
	return S_OK;
}

STDMETHODIMP CJoystickCtl::poll() {
	stick.poll();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::hasZAxis(VARIANT_BOOL *pVal) {
	*pVal = stick.hasZAxis();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::hasRAxis(VARIANT_BOOL *pVal) {
	*pVal = stick.hasRAxis();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::hasPOV(VARIANT_BOOL *pVal) {
	*pVal = stick.hasPOV();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::getNumButtons(UINT *pVal) {
	*pVal = stick.getNumButtons();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::setButtonA(UINT button) {
	stick.setButtonA(button);
	return S_OK;
}

STDMETHODIMP CJoystickCtl::setButtonB(UINT button) {
	stick.setButtonB(button);
	return S_OK;
}

STDMETHODIMP CJoystickCtl::calibrate() {
	stick.calibrate();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::getProductName(BSTR *pName) {
	USES_CONVERSION;
	char* name = stick.getProductName();
	CComBSTR wName = A2W(name);
	*pName = wName.Detach();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_x(DWORD *pVal) {
	*pVal = stick.getX();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_y(DWORD *pVal) {
	*pVal = stick.getY();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_z(DWORD *pVal) {
	*pVal = stick.getZ();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_r(DWORD *pVal) {
	*pVal = stick.getR();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_a(VARIANT_BOOL *pVal) {
	*pVal = stick.getA();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_b(VARIANT_BOOL *pVal) {
	*pVal = stick.getB();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_buttons(DWORD *pVal) {
	*pVal = stick.getButtons();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_pov(DWORD *pVal) {
	*pVal = stick.getPOV();
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_up(VARIANT_BOOL *pVal) {
	*pVal = stick.getDPad(Joystick::DPAD_UP);
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_down(VARIANT_BOOL *pVal) {
	*pVal = stick.getDPad(Joystick::DPAD_DOWN);
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_left(VARIANT_BOOL *pVal) {
	*pVal = stick.getDPad(Joystick::DPAD_LEFT);
	return S_OK;
}

STDMETHODIMP CJoystickCtl::get_right(VARIANT_BOOL *pVal) {
	*pVal = stick.getDPad(Joystick::DPAD_RIGHT);
	return S_OK;
}

HRESULT CJoystickCtl::OnDraw(ATL_DRAWINFO& di) {
	RECT& rc = *(RECT*) di.prcBounds;
	Rectangle(di.hdcDraw, rc.left, rc.top, rc.right, rc.bottom);

	SetTextAlign(di.hdcDraw, TA_CENTER|TA_BASELINE);
	LPCTSTR pszText = _T("JavaScript Joystick");
	TextOut(di.hdcDraw, (rc.left + rc.right) / 2, (rc.top + rc.bottom) / 2, pszText, lstrlen(pszText));

	return S_OK;
}