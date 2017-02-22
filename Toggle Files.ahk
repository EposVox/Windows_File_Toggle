; Copy this file to Startup to have it always run with your machine:
; C:\Users\Adam\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
; Adam's Windows Mods #2 - Toggle file extensions & hidden files.
;These somewhat emulate how Ubuntu's file manager works for showing/hiding files and extensions.

;No tray icon... obviously. No need for this to take up space.
#NoTrayIcon
SetTitleMatchMode RegEx
return

;TOGGLES FILE EXTENSIONS (in Windows Explorer)
;toggle extensions script - checks status of file extension viewing, toggles it, refreshes Explorer window.
f_ToggleFileExt()
{
Global lang_ToggleFileExt, lang_ShowFileExt, lang_HideFileExt
RootKey = HKEY_CURRENT_USER
SubKey  = Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
RegRead, HideFileExt    , % RootKey, % SubKey, HideFileExt
if HideFileExt = 1
  {
  RegWrite, REG_DWORD, % RootKey, % SubKey, HideFileExt, 0
  f_RefreshExplorer()
  }
else
{
    RegWrite, REG_DWORD, % RootKey, % SubKey, HideFileExt, 1
  f_RefreshExplorer()
}
return
}

f_RefreshExplorer() ;refreshes explorer so you see the results
{
WinGet, id, ID, ahk_class Progman
SendMessage, 0x111, 0x1A220,,, ahk_id %id%
WinGet, id, List, ahk_class CabinetWClass
Loop, %id%
{
  id := id%A_Index%
   SendMessage, 0x111, 0x1A220,,, ahk_id %id%
}
WinGet, id, List, ahk_class ExploreWClass
Loop, %id%
{
  id := id%A_Index%
  SendMessage, 0x111, 0x1A220,,, ahk_id %id%
}
WinGet, id, List, ahk_class #32770
Loop, %id%
{
  id := id%A_Index%
  ControlGet, w_CtrID, Hwnd,, SHELLDLL_DefView1, ahk_id %id%
  if w_CtrID !=
  SendMessage, 0x111, 0x1A220,,, ahk_id %w_CtrID%
}
return
}
;maps toggle to Win+Y
#y::f_ToggleFileExt()
;end of file extensions mod

; WINDOWS KEY + H TOGGLES HIDDEN FILES 
#h:: ;Win+H shortcut
RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden  ;checks for hidden file status and changes
If HiddenFiles_Status = 2  
RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1 
Else  
RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2 
WinGetClass, eh_Class,A 
If (eh_Class = "#32770" OR A_OSVersion >= "WIN_VISTA") ;if your Windows OS is Vista or newer
send, {F5} 
Else PostMessage, 0x111, 28931,,, A 
f_RefreshExplorer() ;calls the refresh command agian so you see your results
Return
;end of hidden files mod

;Hope this helps!