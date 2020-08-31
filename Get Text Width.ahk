
#include LOGFONT.ahk

Gui, Font, s12
Gui, Add, Button, HwndHwnd0, AutoHotKey

Gui, Font, s10
Gui, Add, Text, HwndHwnd1, AutoHotKey

Gui, Font, w700, Source Code Pro
Gui, Add, Button, HwndHwnd2, AutoHotKey

Gui, Font, Italic
Gui, Add, Text, HwndHwnd3, AutoHotKey

Gui, Font, Norm, Verdana
Gui, Add, Button, HwndHwnd4, AutoHotKey

Gui, Show, AutoSize

font0 := New LOGFONT(Hwnd0)
font1 := New LOGFONT(Hwnd1)
font2 := New LOGFONT(Hwnd2)
font3 := New LOGFONT(Hwnd3)
font4 := New LOGFONT(Hwnd4)

MsgBox, % "W`tH`n" font0.PixelWidth("AutoHotKey") "`t" font0.PixelHeight("AutoHotKey") "`n`n" font1.PixelWidth("AutoHotKey") "`t" font1.PixelHeight("AutoHotKey") "`n`n" font2.PixelWidth("AutoHotKey") "`t" font2.PixelHeight("AutoHotKey") "`n`n" font3.PixelWidth("AutoHotKey") "`t" font3.PixelHeight("AutoHotKey") "`n`n" font4.PixelWidth("AutoHotKey") "`t" font4.PixelHeight("AutoHotKey")

MsgBox, % "Some LOGFONT Values`n`n" font0.Print() "`n`n" font1.Print() "`n`n" font2.Print() "`n`n" font3.Print() "`n`n" font4.Print()

var := "W`tH`n" font0.PixelWidth("AutoHotKey") "`t" font0.PixelHeight("AutoHotKey") "`n`n" font0.Print()

Gui, Font, s15, klingon font
GuiControl, Font, %Hwnd0%
font0.UpdateFont()

MsgBox, % "Test of UpdateFont`n`n" var "`n`n`n" "W`tH`n" font0.PixelWidth("AutoHotKey") "`t" font0.PixelHeight("AutoHotKey") "`n`n" font0.Print()
return

GuiClose:
	ExitApp