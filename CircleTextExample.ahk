
#Include Circle of Text.ahk

if(!pToken := Gdip_Startup()) {
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit(Func("ExitFun").Bind(Func("Gdip_Shutdown").Bind(pToken)))

Width := 600, Height := 600

Arc := 320
Font := "British Inserat MN"
Size := 60
;0.05932
Style := ""
Colour := 0xff003F77
Str := "I thought what I'd do was, I'd pretend I was one of those deaf-mutes "

;Arc := 360
;Str := "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"

;pText := CircularText(Arc, Str, Width, Height, Font, Size, Style, SubStr(Colour, 3))

pText := OneDimentionalText(Str, 3000, Height, Font, Size, Style, SubStr(Colour, 3))

Gdip_SaveBitmapToFile(pText, A_YYYY "-" A_MM "-" A_DD "-" A_Hour "-" A_Min "-" A_Sec ".png", 100)

Gdip_DisposeImage(pText)
ExitApp


ExitFun(fun) {
	fun.Call()
}

