; TODO: check for errors after writing/deleting files (can't delete/overwrite whilst a plug-in is in use)

;--------------------------------

; NOTE: depends on this script in order to run:
;       http://nsis.sourceforge.net/Get_Mozilla_Plugin_Path

!include "mozillaplugin.nsh"
!include "LogicLib.nsh"
!include "MUI2.nsh"

;--------------------------------

; Version number (both the ActiveX and Mozilla plug-in use the same)
!define VERSION_NUM "0.6.2.1"

; IE plug-in UUID
!define ACTIVEX_UUID "3AE9ED90-4B59-47A0-873B-7B71554B3C3E"

; Name of the installer
Name "JavaScript Joystick Plug-in"

; File to write
OutFile "jsjs-installer.exe"

; Default installation folder
InstallDir "$PROGRAMFILES\Joystick Plugin"
InstallDirRegKey HKLM "Software\JSJS" "InstallDir"

; Request application privileges for Windows Vista/7
RequestExecutionLevel admin

;--------------------------------

!define MUI_ABORTWARNING

; Pages

!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES


!insertmacro MUI_LANGUAGE "English"

;--------------------------------

; Installer version info

VIProductVersion "${VERSION_NUM}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "JavaScript Joystick Plug-in"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Numfum Ltd"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "©2001-2002, 2009-2010 Numfum Ltd"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Browser plug-ins to enable JavaScript access to game controllers"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${VERSION_NUM}"

;--------------------------------

Section "Common Files" Common
  ; Flag as being required
  SectionIn RO
  
  ; Set and then store the installation folder
  SetOutPath $INSTDIR
  WriteRegStr HKLM "Software\JSJS" "InstallDir" "$INSTDIR"

  ; Write the IE ActiveX control (even if it's not used)
  File "release\iejoystick.dll"
  ; And write the Firefox plug-in too
  File "release\npjoystick.dll"
  
  ; Write the Windows uninstaller keys
  !define JSJS_UNINSTALLER_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\JSJS"
  WriteRegStr   HKLM "${JSJS_UNINSTALLER_KEY}" "DisplayName" "JavaScript Joystick Plug-in"
  WriteRegStr   HKLM "${JSJS_UNINSTALLER_KEY}" "Publisher" "Numfum Ltd"
  WriteRegStr   HKLM "${JSJS_UNINSTALLER_KEY}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "${JSJS_UNINSTALLER_KEY}" "NoModify" 1
  WriteRegDWORD HKLM "${JSJS_UNINSTALLER_KEY}" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "Firefox" Firefox
  ; Register Mozilla plug-in (recommended but appears to be ignored)
  !define MOZILLA_PLUGIN_KEY "Software\MozillaPlugins\@numfum.com/JSJS,version=${VERSION_NUM}"
  WriteRegStr HKLM "${MOZILLA_PLUGIN_KEY}" "Description" "Allows JavaScript access to joysticks"
  WriteRegStr HKLM "${MOZILLA_PLUGIN_KEY}" "Path"        "$INSTDIR\npjoystick.dll"
  WriteRegStr HKLM "${MOZILLA_PLUGIN_KEY}" "ProductName" "JavaScript Joystick Plugin"
  WriteRegStr HKLM "${MOZILLA_PLUGIN_KEY}" "Vendor"      "Numfum Ltd"
  WriteRegStr HKLM "${MOZILLA_PLUGIN_KEY}" "Version"     "${VERSION_NUM}"
  WriteRegStr HKLM "${MOZILLA_PLUGIN_KEY}\MimeTypes\application/x-vnd.numfum-joystick" "Description" "JavaScript Joystick Plugin"
  
  ; Then write a copy to the plug-ins folder
  !insertmacro MozillaPluginDir
  Pop $R0
  ${If} $R0 != ''
    ; Write this only if we can (new installations should pick up the registered copy above)
    SetOutPath $R0
    File "release\npjoystick.dll"
  ${EndIf}
SectionEnd

Section "Internet Explorer" Explorer
  ; Mark the ActiveX control as 'approved' then register it
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Ext\PreApproved\{${ACTIVEX_UUID}}" "" ""
  RegDLL "$INSTDIR\iejoystick.dll"
  
  ; Then enable the ActiveX to run in IE for any domain
  !define IE_SITE_SETTINGS_KEY "Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{${ACTIVEX_UUID}}\iexplore"
  WriteRegDWORD HKCU "${IE_SITE_SETTINGS_KEY}" "Flags" 0
  WriteRegDWORD HKCU "${IE_SITE_SETTINGS_KEY}" "Type"  1
SectionEnd

;--------------------------------

; Descriptions

LangString DESC_Common   ${LANG_ENGLISH} "Common files required by all plug-in versions."
LangString DESC_Firefox  ${LANG_ENGLISH} "Firefox plug-in. Also compatible with Opera, Safari and Chrome."
LangString DESC_Explorer ${LANG_ENGLISH} "Internet Explorer ActiveX. Only compatible with 32-bit IE (64-bit IE does not support plug-ins)."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${Common}   $(DESC_Common)
  !insertmacro MUI_DESCRIPTION_TEXT ${Firefox}  $(DESC_Firefox)
  !insertmacro MUI_DESCRIPTION_TEXT ${Explorer} $(DESC_Explorer)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------

Section "Uninstall"
  ; All removals are flagged /REBOOTOK since a plug-in might be active in a browser

  ; Unregister the plug-in then remove the file
  DeleteRegKey HKLM "Software\MozillaPlugins\@numfum.com/JSJS,version=${VERSION_NUM}"

  !insertmacro MozillaPluginDir
  Pop $R0
  ${If} $R0 != ''
    Delete /REBOOTOK "$R0\npjoystick.dll"
  ${EndIf}
  
  ; Unregister the ActiveX then remove the approvals
  UnRegDLL "$INSTDIR\iejoystick.dll"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Ext\PreApproved\{${ACTIVEX_UUID}}"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{${ACTIVEX_UUID}}"
  
  ; Remove the installed files (and the folder)
  RMDir /r /REBOOTOK "$INSTDIR"

  ; Then finally delete the installer's regsitry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\JSJS"
  DeleteRegKey HKLM "Software\JSJS"
SectionEnd