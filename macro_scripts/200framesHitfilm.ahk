; This script was created using Pulover's Macro Creator
; www.macrocreator.com

#NoEnv
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Window
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1

F3::
200FramesHitfilm:
Loop
{
    if (BreakLoop = 1)
      break
    Sleep, 20
    Send, {LControl Down}
    Sleep, 20
    Send, {a}
    Sleep, 20
    Send, {LControl Up}
    Sleep, 20
    Send, {LShift Down}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {>}
    Sleep, 20
    Send, {LShift Up}
    Sleep, 20
    Send, {LControl Down}
    Sleep, 20
    Send, {LShift Down}
    Sleep, 20
    Send, {d}
    Sleep, 20
    Send, {LShift Up}
    Sleep, 20
    Send, {LControl Up}
    Sleep, 500
}

Esc::
    BreakLoop = 1
Return

