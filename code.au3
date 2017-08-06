#cs [AutoCompileFileInfo]
	Path_Exe=C:\Users\QuangToan\Desktop\tool.exe
	Path_Icon=C:\Users\QuangToan\Desktop\ico\Rokey-Popo-Emotions-Ah.ico
	Company=Copyright © QuangToan
	Copyright=Copyright © QuangToan
	Description=Quang Toan
	Version=0.0
	ProductName=Quang Toan Co
	ProductVersion=0.01
#ce
#RequireAdmin
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Dim $Services
Dim $ServicesList

#Region ### START Koda GUI section ### Form=c:\users\quangtoan\desktop\form1.kxf
$Form1_1 = GUICreate("Tool IT", 499, 249, 192, 118)
$B_Disable = GUICtrlCreateButton("DISABLE UPDATE", 96, 0, 313, 97)
GUICtrlSetColor(-1, 0x008080)
$Label1 = GUICtrlCreateLabel("Rename PC", 16, 128, 77, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x0078D7)
$Label2 = GUICtrlCreateLabel("New Name", 16, 168, 57, 17)
$newName = GUICtrlCreateInput("", 96, 160, 209, 21)
$B_Change = GUICtrlCreateButton("CHANGE", 336, 168, 153, 65)
$Label3 = GUICtrlCreateLabel("Warning:Rename Pc must restart Pc", 24, 208, 176, 17)
GUICtrlSetColor(-1, 0xFF0000)
$Label4 = GUICtrlCreateLabel("Status", 16, 104, 49, 17)
GUICtrlSetColor(-1, 0x800000)
$Label5 = GUICtrlCreateLabel("", 72, 104, 36, 17)
GUICtrlSetColor(-1, 0x008000)
$B_Status = GUICtrlCreateButton("Check Status", 124, 96, 81, 25, $BS_FLAT)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
CheckStatus()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
			Exit
	    CheckStatus()
	    Case $B_Status
		    CheckStatus()
	    Case $B_Disable
			CheckService()
	    Case $B_Change
			$tam = GUICtrlRead($newName)
			if ($tam = "") Then
			   MsgBox(0,"Error","Empty Input")
			Else
			   Rename($tam)
			EndIf
	EndSwitch
WEnd

Func CheckStatus()
    $ServiceName = "wuauserv"
    Local $Services = ObjGet("winmgmts:\\" & @ComputerName & "\root\cimv2")
    Local $ServicesList = $Services.ExecQuery("SELECT * FROM Win32_Service")
    If IsObj($ServicesList) then
        For $Services in $ServicesList
            If $Services.Name = $ServiceName Then
                if $Services.State = "Running" Then
                    GUICtrlCreateLabel("Running", 72, 104, 46, 17)
					GUICtrlSetColor(-1, 0x008000)
				 EndIf
				 if $Services.State = "Stopped" Then
                    GUICtrlCreateLabel("Stopped", 72, 104, 46, 17)
					GUICtrlSetColor(-1, 0x008000)
				 EndIf
				 if $Services.StartMode = "Disabled" Then
					GUICtrlCreateLabel("Disabled", 72, 104, 46, 17)
					GUICtrlSetColor(-1, 0xFF0000)
			     endif
            EndIf
        Next
    EndIf
 EndFunc



Func CheckService()
    $ServiceName = "wuauserv"
    Local $Services = ObjGet("winmgmts:\\" & @ComputerName & "\root\cimv2")
    Local $ServicesList = $Services.ExecQuery("SELECT * FROM Win32_Service")
    If IsObj($ServicesList) then
        For $Services in $ServicesList
            If $Services.Name = $ServiceName Then
                if ($Services.State = "Running" ) Then
                    Run (@ComSpec & " /c " & 'net stop wuauserv')
				    Run (@ComSpec & " /c " & 'sc config wuauserv start= disabled')
				 Endif
				 if ($Services.State = "Stopped" and $Services.StartMode <> "Disabled") Then
					 Run (@ComSpec & " /c " & 'sc config wuauserv start= disabled')
				 EndIf
				 Sleep(3000)
			     if $Services.StartMode = "Disabled" Then
					GUICtrlCreateLabel("Disabled", 72, 104, 46, 17)
				    GUICtrlSetColor(-1, 0xFF0000)
				 EndIf
            EndIf
        Next
    EndIf
 EndFunc


Func Rename($newName)
   $WMI = ObjGet("winmgmts:" & "{impersonationLevel=impersonate}!\\" & "." & "\root\cimv2")
   $aItems = $WMI.ExecQuery ("Select Name from Win32_ComputerSystem")
   For $element In $aItems
	  $action = $element.Rename($newName)
	  If $action <> 0 Then
		 MsgBox(0, "Error - " & $action, "Error renaming PC")
	  Else
		 MsgBox(0,"Warning","Ok to Restart")
		 Shutdown(6)
	  EndIf
   Next
 EndFunc