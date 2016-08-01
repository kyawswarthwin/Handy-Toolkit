#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Icon.ico
#AutoIt3Wrapper_Outfile=Release\Handy Toolkit.exe
#AutoIt3Wrapper_Res_Description=Handy Toolkit
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2014 Kyaw Swar Thwin
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_File_Add=res\background.png, RT_RCDATA, 1000, 0
#AutoIt3Wrapper_Res_File_Add=res\bg.bmp, RT_RCDATA, 1001, 0
#AutoIt3Wrapper_Res_File_Add=res\bl.bmp, RT_RCDATA, 1002, 0
#AutoIt3Wrapper_Res_File_Add=res\br.bmp, RT_RCDATA, 1003, 0
#AutoIt3Wrapper_Res_File_Add=res\loader.gif, RT_RCDATA, 1004, 0
#AutoIt3Wrapper_Res_File_Add=res\settings.ini, RT_RCDATA, 1005, 0
#AutoIt3Wrapper_Res_File_Add=res\tl.bmp, RT_RCDATA, 1006, 0
#AutoIt3Wrapper_Res_File_Add=res\tr.bmp, RT_RCDATA, 1007, 0
#AutoIt3Wrapper_Res_File_Add=shells\disable_lock_screen.sh, RT_RCDATA, 1008, 0
#AutoIt3Wrapper_Res_File_Add=shells\install_busybox.sh, RT_RCDATA, 1009, 0
#AutoIt3Wrapper_Res_File_Add=shells\install_google_apps.sh, RT_RCDATA, 1010, 0
#AutoIt3Wrapper_Res_File_Add=shells\uninstall_busybox.sh, RT_RCDATA, 1011, 0
#AutoIt3Wrapper_Res_File_Add=shells\uninstall_google_apps.sh, RT_RCDATA, 1012, 0
#AutoIt3Wrapper_Res_File_Add=ads.txt, RT_RCDATA, ADS, 0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "Include\Android.au3"
#include "Include\Busy.au3"
#include "Include\Marquee.au3"
#include "Include\ResourcesEx.au3"
#include <EditConstants.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <WinAPI.au3>
#include <WinAPISys.au3>
#include <WindowsConstants.au3>
#include "MCFinclude.au3"

Global Const $sAppName = "Handy Toolkit"
Global Const $sAppVersion = "1.0"
Global Const $sAppPublisher = "Kyaw Swar Thwin"

Global Const $DBT_DEVNODES_CHANGED = 0x0007

Global $sTitle = $sAppName
Global $sDeviceState, $sManufacturer, $sModelNumber, $sAndroidVersion, $sBuildNumber, $bRootAccess, $sRootAccess, $bBusyBox, $sBusyBox

If Not @Compiled Then
	While 1
		MsgBox(BitOR($MB_OK, $MB_APPLMODAL), $sTitle, "Go Fuck Yourself!")
		BlockInput(1)
	WEnd
EndIf

_Singleton($sAppName & " v" & $sAppVersion)

OnAutoItExitRegister("_OnExit")

DirRemove(@TempDir & "\" & $sAppName, 1)
DirCreate(@TempDir & "\" & $sAppName)
_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\background.png", 1000)
_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\bg.bmp", 1001)
_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\bl.bmp", 1002)
_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\br.bmp", 1003)
_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\loader.gif", 1004)
_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\settings.ini", 1005)
_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\tl.bmp", 1006)
_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\tr.bmp", 1007)

_GDIPlus_Startup()
$hImage = _GDIPlus_ImageLoadFromFile(@TempDir & "\" & $sAppName & "\background.png")
$hGUI = GUICreate($sTitle, _GDIPlus_ImageGetWidth($hImage), _GDIPlus_ImageGetHeight($hImage), -1, -1, $WS_POPUP, $WS_EX_LAYERED)
$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
_WinAPI_UpdateLayeredWindowEx($hGUI, -1, -1, $hBitmap)
_WinAPI_DeleteObject($hBitmap)
_GDIPlus_ImageDispose($hImage)
_GDIPlus_Shutdown()
GUIRegisterMsg($WM_NCHITTEST, "_WM_NCHITTEST")
GUISetState()

$hControlGUI = GUICreate("", 320, 480, 29, 83, $WS_POPUP, BitOR($WS_EX_MDICHILD, $WS_EX_LAYERED), $hGUI)
$idFileMenu = GUICtrlCreateMenu("&File")
$idFileExitMenu = GUICtrlCreateMenuItem("E&xit", $idFileMenu)
$idToolsMenu = GUICtrlCreateMenu("&Tools")
$idToolsInstallMenu = GUICtrlCreateMenu("Install", $idToolsMenu)
$idToolsInstallBusyBoxMenu = GUICtrlCreateMenuItem("BusyBox", $idToolsInstallMenu)
$idToolsInstallGoogleAppsMenu = GUICtrlCreateMenuItem("Google Apps", $idToolsInstallMenu)
$idToolsUninstallMenu = GUICtrlCreateMenu("Uninstall", $idToolsMenu)
$idToolsUninstallBusyBoxMenu = GUICtrlCreateMenuItem("BusyBox", $idToolsUninstallMenu)
$idToolsUninstallGoogleAppsMenu = GUICtrlCreateMenuItem("Google Apps", $idToolsUninstallMenu)
GUICtrlCreateMenuItem("", $idToolsMenu)
$idToolsMiscellaneousMenu = GUICtrlCreateMenu("Miscellaneous", $idToolsMenu)
$idToolsMiscellaneousDisableLockScreenMenu = GUICtrlCreateMenuItem("Remove Pattern, PIN, Password Lock", $idToolsMiscellaneousMenu)
$idToolsMiscellaneousFactoryResetMenu = GUICtrlCreateMenuItem("Factory Reset", $idToolsMiscellaneousMenu)
$idToolsRebootMenu = GUICtrlCreateMenu("Reboot", $idToolsMenu)
$idToolsRebootRebootMenu = GUICtrlCreateMenuItem("Reboot", $idToolsRebootMenu)
$idToolsRebootRecoveryMenu = GUICtrlCreateMenuItem("Recovery", $idToolsRebootMenu)
$idToolsRebootBootloaderMenu = GUICtrlCreateMenuItem("Bootloader", $idToolsRebootMenu)
$idToolsRebootDownloadMenu = GUICtrlCreateMenuItem("Download", $idToolsRebootMenu)
$idHelpMenu = GUICtrlCreateMenu("&Help")
$idHelpAboutMenu = GUICtrlCreateMenuItem("&About " & $sAppName & "...", $idHelpMenu)
GUISetBkColor(0xABCDEF)
_WinAPI_SetLayeredWindowAttributes($hControlGUI, 0xABCDEF)
$idEdit = GUICtrlCreateEdit("", 0, 0, 320, 420, BitOR($ES_AUTOVSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL))
$aMarquee = _GUICtrlMarquee_Init()
_GUICtrlMarquee_SetScroll($aMarquee, Default, Default, Default, 5)
_GUICtrlMarquee_SetDisplay($aMarquee, Default, 0xFFFFFF, 0xFF0000, 16, "Zawgyi-One")
_GUICtrlMarquee_Create($aMarquee, _Resource_GetAsString("ADS"), 0, 420, 320, 40)
GUIRegisterMsg($WM_DEVICECHANGE, "_WM_DEVICECHANGE")
GUISetState()
_GetDeviceInfo()

While 1
	If WinActive($hGUI) Then WinActivate($hControlGUI)
	$iMsg = GUIGetMsg()
	Switch $iMsg
		Case $GUI_EVENT_CLOSE, $idFileExitMenu
			Exit
		Case $idToolsInstallBusyBoxMenu
			If $sDeviceState <> "Online" Then
				MsgBox(BitOR($MB_ICONERROR, $MB_APPLMODAL), "Error", "Device Is Not Found.", Default, $hControlGUI)
			Else
				If $bBusyBox Then
					MsgBox(BitOR($MB_ICONINFORMATION, $MB_APPLMODAL), $sTitle, "Device Is Already Installed BusyBox.", Default, $hControlGUI)
				Else
					If Not $bRootAccess Then
						MsgBox(BitOR($MB_ICONINFORMATION, $MB_APPLMODAL), $sTitle, "Root Access Is Required.", Default, $hControlGUI)
					Else
						_Busy_Create("Installing...", $BUSY_SCREEN, 200, $hControlGUI)
						_Android_Shell("mkdir /data/local/tmp", True)
						_Android_Shell("rm -r /data/local/tmp/*", True)
						_Android_Push("busybox", "/data/local/tmp")
						_Android_Shell("chmod 755 /data/local/tmp/busybox")
						_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\install_busybox.sh", 1009)
						_Android_Push(@TempDir & "\" & $sAppName & "\install_busybox.sh", "/data/local/tmp")
						_Android_Shell("chmod 755 /data/local/tmp/install_busybox.sh")
						_Android_Shell("sh /data/local/tmp/install_busybox.sh", True)
						FileDelete(@TempDir & "\" & $sAppName & "\*.sh")
						_Android_Shell("rm -r /data/local/tmp/*", True)
						_Busy_Update("Rebooting...")
						_Android_Reboot()
						_Busy_Close()
					EndIf
				EndIf
			EndIf
		Case $idToolsInstallGoogleAppsMenu
			If $sDeviceState <> "Online" Then
				MsgBox(BitOR($MB_ICONERROR, $MB_APPLMODAL), "Error", "Device Is Not Found.", Default, $hControlGUI)
			Else
				$iAPILevel = _Android_GetProperty("ro.build.version.sdk")
				If Not FileExists(@ScriptDir & "\gapps\android-" & $iAPILevel & ".tar.gz") Then
					MsgBox(BitOR($MB_ICONERROR, $MB_APPLMODAL), "Error", "Device Is Not Supported.", Default, $hControlGUI)
				Else
					If Not $bRootAccess Then
						MsgBox(BitOR($MB_ICONINFORMATION, $MB_APPLMODAL), $sTitle, "Root Access Is Required.", Default, $hControlGUI)
					Else
						_Busy_Create("Installing...", $BUSY_SCREEN, 200, $hControlGUI)
						_Android_Shell("mkdir /data/local/tmp", True)
						_Android_Shell("rm -r /data/local/tmp/*", True)
						_Android_Push("busybox", "/data/local/tmp")
						_Android_Shell("chmod 755 /data/local/tmp/busybox")
						_Android_Push(@ScriptDir & "\gapps\gapps.lst", "/data/local/tmp")
						_Android_Push(@ScriptDir & "\gapps\android-" & $iAPILevel & ".tar.gz", "/data/local/tmp/gapps.tar.gz")
						_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\install_google_apps.sh", 1010)
						_Android_Push(@TempDir & "\" & $sAppName & "\install_google_apps.sh", "/data/local/tmp")
						_Android_Shell("chmod 755 /data/local/tmp/install_google_apps.sh")
						_Android_Shell("sh /data/local/tmp/install_google_apps.sh", True)
						FileDelete(@TempDir & "\" & $sAppName & "\*.sh")
						_Android_Shell("rm -r /data/local/tmp/*", True)
						_Busy_Update("Rebooting...")
						_Android_Reboot()
						_Busy_Close()
					EndIf
				EndIf
			EndIf
		Case $idToolsUninstallBusyBoxMenu
			If $sDeviceState <> "Online" Then
				MsgBox(BitOR($MB_ICONERROR, $MB_APPLMODAL), "Error", "Device Is Not Found.", Default, $hControlGUI)
			Else
				If Not $bBusyBox Then
					MsgBox(BitOR($MB_ICONINFORMATION, $MB_APPLMODAL), $sTitle, "Device Is Already Uninstalled BusyBox.", Default, $hControlGUI)
				Else
					If Not $bRootAccess Then
						MsgBox(BitOR($MB_ICONINFORMATION, $MB_APPLMODAL), $sTitle, "Root Access Is Required.", Default, $hControlGUI)
					Else
						_Busy_Create("Uninstalling...", $BUSY_SCREEN, 200, $hControlGUI)
						_Android_Shell("mkdir /data/local/tmp", True)
						_Android_Shell("rm -r /data/local/tmp/*", True)
						_Android_Push("busybox", "/data/local/tmp")
						_Android_Shell("chmod 755 /data/local/tmp/busybox")
						_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\uninstall_busybox.sh", 1011)
						_Android_Push(@TempDir & "\" & $sAppName & "\uninstall_busybox.sh", "/data/local/tmp")
						_Android_Shell("chmod 755 /data/local/tmp/uninstall_busybox.sh")
						_Android_Shell("sh /data/local/tmp/uninstall_busybox.sh", True)
						FileDelete(@TempDir & "\" & $sAppName & "\*.sh")
						_Android_Shell("rm -r /data/local/tmp/*", True)
						_Busy_Update("Rebooting...")
						_Android_Reboot()
						_Busy_Close()
					EndIf
				EndIf
			EndIf
		Case $idToolsUninstallGoogleAppsMenu
			If $sDeviceState <> "Online" Then
				MsgBox(BitOR($MB_ICONERROR, $MB_APPLMODAL), "Error", "Device Is Not Found.", Default, $hControlGUI)
			Else
				If Not $bRootAccess Then
					MsgBox(BitOR($MB_ICONINFORMATION, $MB_APPLMODAL), $sTitle, "Root Access Is Required.", Default, $hControlGUI)
				Else
					_Busy_Create("Uninstalling...", $BUSY_SCREEN, 200, $hControlGUI)
					_Android_Shell("mkdir /data/local/tmp", True)
					_Android_Shell("rm -r /data/local/tmp/*", True)
					_Android_Push("busybox", "/data/local/tmp")
					_Android_Shell("chmod 755 /data/local/tmp/busybox")
					_Android_Push(@ScriptDir & "\gapps\gapps.lst", "/data/local/tmp")
					_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\uninstall_google_apps.sh", 1012)
					_Android_Push(@TempDir & "\" & $sAppName & "\uninstall_google_apps.sh", "/data/local/tmp")
					_Android_Shell("chmod 755 /data/local/tmp/uninstall_google_apps.sh")
					_Android_Shell("sh /data/local/tmp/uninstall_google_apps.sh", True)
					FileDelete(@TempDir & "\" & $sAppName & "\*.sh")
					_Android_Shell("rm -r /data/local/tmp/*", True)
					_Busy_Update("Rebooting...")
					_Android_Reboot()
					_Busy_Close()
				EndIf
			EndIf
		Case $idToolsMiscellaneousDisableLockScreenMenu
			If $sDeviceState <> "Online" Then
				MsgBox(BitOR($MB_ICONERROR, $MB_APPLMODAL), "Error", "Device Is Not Found.", Default, $hControlGUI)
			Else
				If Not $bRootAccess Then
					MsgBox(BitOR($MB_ICONINFORMATION, $MB_APPLMODAL), $sTitle, "Root Access Is Required.", Default, $hControlGUI)
				Else
					_Busy_Create("Disabling Lock Screen...", $BUSY_SCREEN, 200, $hControlGUI)
					_Android_Shell("mkdir /data/local/tmp", True)
					_Android_Shell("rm -r /data/local/tmp/*", True)
					_Android_Push("sqlite3", "/data/local/tmp")
					_Android_Shell("chmod 755 /data/local/tmp/sqlite3")
					_Resource_SaveToFile(@TempDir & "\" & $sAppName & "\disable_lock_screen.sh", 1008)
					_Android_Push(@TempDir & "\" & $sAppName & "\disable_lock_screen.sh", "/data/local/tmp")
					_Android_Shell("chmod 755 /data/local/tmp/disable_lock_screen.sh")
					_Android_Shell("sh /data/local/tmp/disable_lock_screen.sh", True)
					FileDelete(@TempDir & "\" & $sAppName & "\*.sh")
					_Android_Shell("rm -r /data/local/tmp/*", True)
					_Busy_Update("Rebooting...")
					_Android_Reboot()
					_Busy_Close()
				EndIf
			EndIf
		Case $idToolsMiscellaneousFactoryResetMenu
			If $sDeviceState <> "Online" And $sDeviceState <> "Bootloader" Then
				MsgBox(BitOR($MB_ICONERROR, $MB_APPLMODAL), "Error", "Device Is Not Found.", Default, $hControlGUI)
			Else
				If $sDeviceState = "Online" And $bRootAccess = False Then
					MsgBox(BitOR($MB_ICONINFORMATION, $MB_APPLMODAL), $sTitle, "Root Access Is Required.", Default, $hControlGUI)
				Else
					If MsgBox(BitOR($MB_YESNO, $MB_APPLMODAL), $sTitle, "Are You Sure You Want To Restore The Device To Its Factory Settings?" & @CRLF & "This Will Erase All Data From Your Device's Internal Storage.", Default, $hControlGUI) = $IDYES Then
						_Busy_Create("Factory Resetting...", $BUSY_SCREEN, 200, $hControlGUI)
						_Android_WipeDataCache()
						_Busy_Update("Rebooting...")
						_Android_Reboot()
						_Busy_Close()
					EndIf
				EndIf
			EndIf
		Case $idToolsRebootRebootMenu
			_Reboot()
		Case $idToolsRebootRecoveryMenu
			_Reboot("recovery")
		Case $idToolsRebootBootloaderMenu
			_Reboot("bootloader")
		Case $idToolsRebootDownloadMenu
			_Reboot("download")
		Case $idHelpAboutMenu
			MsgBox(BitOR($MB_ICONINFORMATION, $MB_APPLMODAL), "About", $sAppName & @CRLF & @CRLF & "Version: " & $sAppVersion & @CRLF & "Developed By: " & $sAppPublisher, Default, $hControlGUI)
	EndSwitch
WEnd

Func _WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $iMsg, $iwParam, $ilParam
	Switch $hWnd
		Case $hGUI
			Return $HTCAPTION
	EndSwitch
EndFunc   ;==>_WM_NCHITTEST

Func _WM_DEVICECHANGE($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Switch $iwParam
		Case $DBT_DEVNODES_CHANGED
			_GetDeviceInfo()
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_DEVICECHANGE

Func _GetDeviceInfo()
	Local $sNewDeviceState, $sOldDeviceState, $sDeviceInfo
	$sNewDeviceState = _Android_GetState()
	If $sDeviceState <> $sNewDeviceState Then
		$sDeviceInfo = ""
		$sOldDeviceState = $sDeviceState
		$sDeviceState = $sNewDeviceState
		$sDeviceInfo &= "Device State: " & $sDeviceState & @CRLF
		Switch $sDeviceState
			Case "Online"
				$sManufacturer = _Android_GetProperty("ro.product.manufacturer")
				$sDeviceInfo &= "Manufacturer: " & $sManufacturer & @CRLF
				$sModelNumber = _Android_GetProperty("ro.product.model")
				$sDeviceInfo &= "Model Number: " & $sModelNumber & @CRLF
				$sAndroidVersion = _Android_GetProperty("ro.build.version.release")
				$sDeviceInfo &= "Android Version: " & $sAndroidVersion & @CRLF
				$sBuildNumber = _Android_GetProperty("ro.build.display.id")
				$sDeviceInfo &= "Build Number: " & $sBuildNumber & @CRLF
				$bRootAccess = _Android_IsRooted()
				$sRootAccess = $bRootAccess ? "Yes" : "No"
				$sDeviceInfo &= "Root Access: " & $sRootAccess & @CRLF
				$bBusyBox = _Android_IsBusyBoxInstalled()
				$sBusyBox = $bBusyBox ? "Installed" : "Not Installed"
				$sDeviceInfo &= "BusyBox: " & $sBusyBox & @CRLF
			Case "Offline"
				_Connect()
			Case "Bootloader"

			Case Else
				If $sOldDeviceState = "" Then _Connect()
		EndSwitch
		GUICtrlSetData($idEdit, $sDeviceInfo)
	EndIf
EndFunc   ;==>_GetDeviceInfo

Func _Connect()
	_Busy_Create("Connecting...", $BUSY_SCREEN, 200, $hControlGUI)
	_Android_Connect()
	_Busy_Close()
EndFunc   ;==>_Connect

Func _Reboot($sMode = "")
	If ($sDeviceState <> "Online" And $sDeviceState <> "Bootloader") Or (($sMode = "recovery" Or $sMode = "download") And $sDeviceState <> "Online") Then
		MsgBox(BitOR($MB_ICONERROR, $MB_APPLMODAL), "Error", "Device Is Not Found.", Default, $hControlGUI)
	Else
		If $sMode = "download" And $sManufacturer <> "Samsung" Then
			MsgBox(BitOR($MB_ICONERROR, $MB_APPLMODAL), "Error", "Device Is Not Supported.", Default, $hControlGUI)
		Else
			_Busy_Create("Rebooting...", $BUSY_SCREEN, 200, $hControlGUI)
			_Android_Reboot($sMode)
			_Busy_Close()
		EndIf
	EndIf
EndFunc   ;==>_Reboot

Func _OnExit()
	DirRemove(@TempDir & "\" & $sAppName, 1)
EndFunc   ;==>_OnExit
