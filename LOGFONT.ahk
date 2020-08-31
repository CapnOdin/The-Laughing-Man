
#include <gdip>

/*
pToken := Gdip_Startup()
LF := new LOGFONT()
LF.SetFont("klingon font", 15)
MsgBox, % "W`tH`n" LF.PixelWidth("AutoHotKey") "`t" LF.PixelHeight("AutoHotKey") "`n`n" LF.Print()
LF.SetFont("Verdana", 26)
MsgBox, % "W`tH`n" LF.PixelWidth("AutoHotKey") "`t" LF.PixelHeight("AutoHotKey") "`n`n" LF.Print()
Gdip_Shutdown(pToken)
*/

/*
pToken := Gdip_Startup()
LF := new LOGFONT()
LF.SetFontGui("klingon font", 15)
res := "W`tH`n" LF.PixelWidth("AutoHotKey") "`t" LF.PixelHeight("AutoHotKey") "`n`n" LF.Print()
LF.SetFontGui("Verdana", 26)
res .= "`n`n" "W`tH`n" LF.PixelWidth("AutoHotKey") "`t" LF.PixelHeight("AutoHotKey") "`n`n" LF.Print()
MsgBox, % res
Gdip_Shutdown(pToken)
*/

Class LOGFONT {
	Static WM_GETFONT := 0x31, LONG := 4, BYTE := 1
	
	HFONT := 0, GuiName := "LOGFONT"
	
	Height := 0, Width := 0, Escapement := 0, Orientation := 0, Weight := 0
	
	Italic := 0, Underline := 0, StrikeOut := 0, CharSet := 0, OutPrecision := 0, ClipPrecision := 0, Quality := 0, PitchAndFamily := 0
	
	FaceName := ""
	
	__New(Hwnd := False){
		this.Hwnd := Hwnd
		if(Hwnd) {
			this.UpdateFont()
		}
	}
	
	SetFont(Name, Size, Style := 0){
		;hDC := CreateCompatibleDC()
		
		if(this.HFONT) {
			Gdip_DeleteFont(this.HFONT)
		}
		this.hFamily := Gdip_FontFamilyCreate(Name)
		this.HFONT := Gdip_FontCreate(this.hFamily, Size, Style)
		
		;G := Gdip_GraphicsFromHDC(hdc)
		
		;hFold := DllCall("SelectObject", "UPtr", hDC, "UPtr", this.HFONT)
		
		;MsgBox, % Gdip_TextToGraphics(G, "sometext", "x" 100 / 2 " y5p w10 Centre cbbffffff r4 s30", , 100, 100)
		
		
		
		;MsgBox, % hDC "`n" G "`n" hFold
		
		
		;VarSetCapacity(buff, 92)
		;DllCall("gdiplus\GdipGetLogFont", A_PtrSize ? "UPtr" : "UInt", G, A_PtrSize ? "UPtr*" : "UInt*", &buff)
		;this.GetData(buff, 92)
		
		
		MsgBox, % this.HFONT "`n" this.hFamily
		amount := DllCall("GetObject", "UPtr", this.HFONT, "Int", 0, "UPtr", 0)
		MsgBox, % amount
		VarSetCapacity(buff, amount)
		amount := DllCall("GetObject", "UPtr", this.HFONT, "Int", amount, "UPtr", &buff)
		MsgBox, % amount
		this.GetData(buff, amount)
		
		
		Gdip_DeleteFontFamily(this.hFamily)
		;DeleteDC(hDC)
		;Gdip_DeleteGraphics(G)
	}
	
	
	SetFontGui(Name, Size, Style := ""){
		Gui, % this.GuiName ":Font", % "s" Size " " Style, % Name
		if(!this.Hwnd) {
			Gui, % this.GuiName ":Add", Edit, +HwndHwnd, |||||||
			Gui, % this.GuiName ":Color", , FF0000
			this.Hwnd := Hwnd
			;Gui, % this.GuiName ":Show"
		} else {
			GuiControl, % this.GuiName ":Font", % this.Hwnd
		}
		if(this.HFONT) {
			Gdip_DeleteFont(this.HFONT)
		}
		this.UpdateFont()
	}
	
	SetFontGdip(Name, Size, Style := 0, Align := 1, Rendering := 4){
		this.pGraphics := Gdip_CreateBitmap(500, 500)
		this.hFamily := Gdip_FontFamilyCreate(Name)
		this.HFONT := Gdip_FontCreate(this.hFamily, Size, Style)
		this.hFormat := Gdip_StringFormatCreate(0x4000 | 0x1000)
		Gdip_SetStringFormatAlign(this.hFormat, Align)
		Gdip_SetTextRenderingHint(this.pGraphics, Rendering)
		;Gdip_DeleteFontFamily(hFamily)
	}
	
	UpdateFont(){
		this.HFONT := DllCall("SendMessage", "Ptr", this.Hwnd, "UInt", this.WM_GETFONT, "Ptr", 0, "Ptr", 0, "Ptr")
		amount := DllCall("GetObject", "Ptr", this.HFONT, "Int", 0, "Ptr", 0)
		VarSetCapacity(buff, amount)
		amount := DllCall("GetObject", "Ptr", this.HFONT, "Int", amount, "Ptr", &buff)
		this.__GetData(buff, amount)
	}
	
	__GetData(ByRef buff, amount){
		; Of Type LONG
		this.Height		:= NumGet(buff, this.LONG * 0, "Int") ; Verified I think
		this.Width		:= NumGet(buff, this.LONG * 1, "Int")
		this.Escapement := NumGet(buff, this.LONG * 2, "Int")
		this.Orientation:= NumGet(buff, this.LONG * 3, "Int")
		this.Weight		:= NumGet(buff, this.LONG * 4, "Int") ; Verified
		
		offset := this.LONG * 4
		
		; Of Type BYTE
		this.Italic			:= NumGet(buff, this.BYTE * 4 + offset, "UChar") ; Verified
		this.Underline		:= NumGet(buff, this.BYTE * 5 + offset, "UChar") ; Verified
		this.StrikeOut		:= NumGet(buff, this.BYTE * 6 + offset, "UChar") ; Verified
		this.CharSet		:= NumGet(buff, this.BYTE * 7 + offset, "UChar")
		this.OutPrecision	:= NumGet(buff, this.BYTE * 1 + offset, "UChar")
		this.ClipPrecision	:= NumGet(buff, this.BYTE * 2 + offset, "UChar")
		this.Quality		:= NumGet(buff, this.BYTE * 3 + offset, "UChar")
		this.PitchAndFamily := NumGet(buff, this.BYTE * 0 + offset, "UChar")
		
		offset += this.BYTE * 7 - 1
		
		this.FaceName := ""
		
		; Of Type Char Array
		While (offset < amount && (nextChar := NumGet(buff, offset += 1, "Char") + NumGet(buff, offset += 1, "Char")) != 0){
			this.FaceName .= Chr(nextChar)
		}
		
	}
	
	PixelWidth(str){
		return this.GetDimensionsInPixels(str)["w"]
	}
	
	PixelHeight(str){
		return this.GetDimensionsInPixels(str)["h"]
	}
	
	GetDimensionsInPixels(str){
		if(this.Hwnd) {
			hDC := DllCall("GetDC", "Uint", this.Hwnd)
		} else {
			hDC := CreateCompatibleDC()
		}
		
		hFold := DllCall("SelectObject", "Uint", hDC, "Uint", this.HFONT)
		DllCall("GetTextExtentPoint32", "Uint", hDC, "str", str, "int", StrLen(str), "int64P", nSize)
		
		if(this.Hwnd) {
			DllCall("SelectObject", "Uint", hDC, "Uint", hFold)
			DllCall("ReleaseDC", "Uint", this.Hwnd, "Uint", hDC)
		} else {
			DeleteDC(hDC)
		}
		
		nWidth  := nSize & 0xFFFFFFFF
		nHeight := nSize >> 32 & 0xFFFFFFFF
		
		Return {"w" : nWidth, "h" : nHeight}
	}
	
	PixelWidth2(str){
		return this.GetDimensionsInPixels2(str)["w"]
	}
	
	PixelHeight2(str){
		return this.GetDimensionsInPixels2(str)["h"]
	}
	
	GetDimensionsInPixels2(str) {
		CreateRectF(RC, 0, 0, 0, 0)
		ReturnRC := Gdip_MeasureString(this.pGraphics, str, this.hFont, this.hFormat, RC)
		MsgBox, % ReturnRC
		ReturnRC := StrSplit(ReturnRC, "|")
		Return {"w" : ReturnRC[3], "h" : ReturnRC[4]}
	}
	
	
	Print(){
		LONG := "Height:`t`t" this.Height "`nWidth:`t`t" this.Width "`nEscapement:`t" this.Escapement "`nOrientation:`t" this.Orientation "`nWeight:`t`t" this.Weight
		
		BYTE := "Italic:`t`t" this.Italic "`nUnderline:`t`t" this.Underline "`nStrikeOut:`t`t" this.StrikeOut "`nCharSet:`t`t" this.CharSet "`nOutPrecision:`t" this.OutPrecision "`nClipPrecision:`t" this.ClipPrecision "`nQuality:`t`t" this.Quality "`nPitchAndFamily:`t" this.PitchAndFamily
		
		return "-" RegExReplace(this.FaceName, "[^a-zA-Z ]") "-`n" LONG "`n" BYTE
	}
	
}





Gdip_TextToGraphicsOptionParser(pGraphics, Options, Font:="Arial", Width:="", Height:="", Measure:=0) {
	IWidth := Width, IHeight:= Height

	pattern_opts := (A_AhkVersion < "2") ? "iO)" : "i)"
	RegExMatch(Options, pattern_opts "X([\-\d\.]+)(p*)", xpos)
	RegExMatch(Options, pattern_opts "Y([\-\d\.]+)(p*)", ypos)
	RegExMatch(Options, pattern_opts "W([\-\d\.]+)(p*)", Width)
	RegExMatch(Options, pattern_opts "H([\-\d\.]+)(p*)", Height)
	RegExMatch(Options, pattern_opts "C(?!(entre|enter))([a-f\d]+)", Colour)
	RegExMatch(Options, pattern_opts "Top|Up|Bottom|Down|vCentre|vCenter", vPos)
	RegExMatch(Options, pattern_opts "NoWrap", NoWrap)
	RegExMatch(Options, pattern_opts "R(\d)", Rendering)
	RegExMatch(Options, pattern_opts "S(\d+)(p*)", Size)

	if Colour && IsInteger(Colour[2]) && !Gdip_DeleteBrush(Gdip_CloneBrush(Colour[2]))
		PassBrush := 1, pBrush := Colour[2]

	if !(IWidth && IHeight) && ((xpos && xpos[2]) || (ypos && ypos[2]) || (Width && Width[2]) || (Height && Height[2]) || (Size && Size[2]))
		return -1

	Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
	For eachStyle, valStyle in StrSplit( Styles, "|" )
	{
		if RegExMatch(Options, "\b" valStyle)
			Style |= (valStyle != "StrikeOut") ? (A_Index-1) : 8
	}

	Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
	For eachAlignment, valAlignment in StrSplit( Alignments, "|" )
	{
		if RegExMatch(Options, "\b" valAlignment)
			Align |= A_Index//2.1	; 0|0|1|1|2|2
	}

	xpos := (xpos && (xpos[1] != "")) ? xpos[2] ? IWidth*(xpos[1]/100) : xpos[1] : 0
	ypos := (ypos && (ypos[1] != "")) ? ypos[2] ? IHeight*(ypos[1]/100) : ypos[1] : 0
	Width := (Width && Width[1]) ? Width[2] ? IWidth*(Width[1]/100) : Width[1] : IWidth
	Height := (Height && Height[1]) ? Height[2] ? IHeight*(Height[1]/100) : Height[1] : IHeight
	if !PassBrush
		Colour := "0x" (Colour && Colour[2] ? Colour[2] : "ff000000")
	Rendering := (Rendering && (Rendering[1] >= 0) && (Rendering[1] <= 5)) ? Rendering[1] : 4
	Size := (Size && (Size[1] > 0)) ? Size[2] ? IHeight*(Size[1]/100) : Size[1] : 12

	hFamily := Gdip_FontFamilyCreate(Font)
	hFont := Gdip_FontCreate(hFamily, Size, Style)
	FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
	hFormat := Gdip_StringFormatCreate(FormatStyle)
	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
	if !(hFamily && hFont && hFormat && pBrush && pGraphics)
		return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0

	CreateRectF(RC, xpos, ypos, Width, Height)
	Gdip_SetStringFormatAlign(hFormat, Align)
	Gdip_SetTextRenderingHint(pGraphics, Rendering)
	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)

	if vPos
	{
		ReturnRC := StrSplit(ReturnRC, "|")

		if (vPos[0] = "vCentre") || (vPos[0] = "vCenter")
			ypos += (Height-ReturnRC[4])//2
		else if (vPos[0] = "Top") || (vPos[0] = "Up")
			ypos := 0
		else if (vPos[0] = "Bottom") || (vPos[0] = "Down")
			ypos := Height-ReturnRC[4]

		CreateRectF(RC, xpos, ypos, Width, ReturnRC[4])
		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	}

	if !Measure
		_E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)

	return {"Graphics": pGraphics, "Family": hFamily, "Font": hFont, "Format": hFormat, "Brush": pBrush, "x": xpos, "y": ypos, "w": Width, "h": Height}
}















