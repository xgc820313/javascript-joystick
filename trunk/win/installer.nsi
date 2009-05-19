!include "mozillaplugin.nsh"
!include "LogicLib.nsh"

; TODO: simplify editing the version numbers
; TODO: only uninstall the files that were installed (and not the entire folder)
; TODO: check for errors after writing/deleting files (can't delete/overwrite whilst a plug-in is in use)

; The name of the installer
Name "JavaScript Joystick Plug-in"

; The file to write
OutFile "jsjs-installer.exe"

; The default installation folder
InstallDir "$PROGRAMFILES\Joystick Plugin"
InstallDirRegKey HKCU "Software\JSJS" ""

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

; Installer version info

LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"

VIProductVersion "0.6.0.1"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "JavaScript Joystick Plug-in"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Numfum Ltd"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "©2001-2002, 2009 Numfum Ltd"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Browser plug-ins to enable JavaScript access to game controllers"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "0.6.0"

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

;--------------------------------

Section "Plugin Common Files (required)"
  ; Flag as being required
  SectionIn RO
  
  ; Set and then store the installation folder
  SetOutPath $INSTDIR
  WriteRegStr HKCU "Software\JSJS" "" $INSTDIR

  ; Write the IE ActiveX control (even if it's not used)
  File "release\iejoystick.dll"
  ; And write the Firefox plug-in too
  File "release\npjoystick.dll"
  
  ; Write the Windows uninstaller keys
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\JSJS" "DisplayName" "JavaScript Joystick Plug-in (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\JSJS" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\JSJS" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\JSJS" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "Firefox/Opera/Safari Plug-in"
  ; Register Mozilla plug-in (recommended but appears to be ignored)
  WriteRegStr HKLM "Software\MozillaPlugins\@numfum.com/JSJS,version=0.6.0.1" "Description" "Allows JavaScript access to joysticks"
  WriteRegStr HKLM "Software\MozillaPlugins\@numfum.com/JSJS,version=0.6.0.1" "Path"        "$INSTDIR\npjoystick.dll"
  WriteRegStr HKLM "Software\MozillaPlugins\@numfum.com/JSJS,version=0.6.0.1" "ProductName" "JavaScript Joystick Plugin"
  WriteRegStr HKLM "Software\MozillaPlugins\@numfum.com/JSJS,version=0.6.0.1" "Vendor"      "Numfum Ltd"
  WriteRegStr HKLM "Software\MozillaPlugins\@numfum.com/JSJS,version=0.6.0.1" "Version"     "0.6.0.1"
  WriteRegStr HKLM "Software\MozillaPlugins\@numfum.com/JSJS,version=0.6.0.1\MimeTypes\application/x-vnd.numfum-joystick" "Description" "JavaScript Joystick Plugin"

  ; Then write a copy to the plug-ins folder
  !insertmacro MozillaPluginDir
  Pop $R0
  ${If} $R0 != ''
    ; Write this only if we can (new installations should pick up the registered copy above)
    SetOutPath $R0
    File "release\npjoystick.dll"
  ${EndIf}
SectionEnd

Section "Internet Explorer ActiveX"
  ; Register ActiveX control and mark it as 'approved'
  ExecWait 'regsvr32 /s "$INSTDIR\iejoystick.dll"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Ext\PreApproved\{3AE9ED90-4B59-47A0-873B-7B71554B3C3E}" "" ""
SectionEnd

Section "Uninstall"
  ; Unregister the plug-in then remove the file
  DeleteRegKey HKLM "Software\MozillaPlugins\@numfum.com/JSJS,version=0.6.0.1"

  !insertmacro MozillaPluginDir
  Pop $R0
  ${If} $R0 != ''
    Delete $R0\npjoystick.dll
  ${EndIf}
  
  ; Unregister the ActiveX then remove the approval
  ExecWait 'regsvr32 /s /u "$INSTDIR\iejoystick.dll"'
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Ext\PreApproved\{3AE9ED90-4B59-47A0-873B-7B71554B3C3E}"
  
  ; Remove the entire contents of the install folder
  RMDir /r $INSTDIR

  ; Then finally delete the install folder's regsitry key
  DeleteRegKey /ifempty HKCU "Software\JSJS"
SectionEnd