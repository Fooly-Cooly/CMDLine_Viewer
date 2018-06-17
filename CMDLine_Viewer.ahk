;================================================================================;
;	CMDLine Viewer - Lists processes' initial command-line/parameters            ;
;	Copyright (C) 2018  Brian Baker https://github.com/Fooly-Cooly               ;
;	Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt                ;
;	Works with AHK ANSI, Unicode & 64-bit                                        ;
;================================================================================;

#NoEnv					; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon				; Disables the showing of a tray icon.
#SingleInstance force	; Prevents having multiple copies running
SendMode Input			; Recommended for new scripts due to its superior speed and reliability.

;	Generate GUI with list of processes
Menu, Tray, Icon, icon.ico
Gui, Add, ListView, +HwndhListView -Multi w400 h500 gListView Sort, Process Name|Command Line (Double-Click to copy)
for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
	if (process.CommandLine)
		LV_Add("", process.Name, process.CommandLine)
LV_ModifyCol(1, "Auto")
Gui, Show,, Process List

;	Calculate columns total width and set GUI width based on it
Gui +HwndhGui
SysGet, width, 2 ; SM_CXVSCROLL - Get width of vertical scrollbar
SendMessage, 0x1000+29, 0, 0, SysListView321, ahk_id %hGui%
width += ErrorLevel
SendMessage, 0x1000+29, 1, 0, SysListView321, ahk_id %hGui%
width += ErrorLevel + 4
GuiControl, Move, %hListView%, w%width%
Gui, Show, AutoSize, Process List
return

ListView:
	LV_GetText(Output, A_EventInfo, 2)
	if (Output)
	{
		clipboard := Output
		ToolTip Copied
		Sleep 750
		ToolTip
	}
return

GuiClose:
	ExitApp

+Esc::ExitApp