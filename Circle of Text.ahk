
#Include LOGFONT.ahk


OneDimentionalText(Str, Width, Height, Font, fSize, fStyle, fColour) {
	pBitmap := Gdip_CreateBitmap(Width, Height)
	
	G := Gdip_GraphicsFromImage(pBitmap)
	
	Gdip_SetSmoothingMode(G, 4)
	
	Options := "s" fSize " " fStyle " r4 NoWrap Centre vCentre c" fColour ; " h" strSize["h"]
	x := Width / 2
	
	strSize := StrSplit(Gdip_TextToGraphics(G, Str, Options " x3000 y" Height / 2, Font, , , True), "|")
	strSize := {"w": strSize[3], "h": strSize[4]}
	
	total := 0
	for i, chr in StrSplit(Str) {
		w := StrSplit(Gdip_TextToGraphics(G, chr, Options " x0 y" Height / 2, Font, , , True), "|")[3]
		total += w
	}
	totalWidth := total
	
	Gdip_TextToGraphics(G, Str, Options " x" x " y" Height / 3, Font)
	
	total := 0
	for i, chr in StrSplit(Str) {
		w := StrSplit(Gdip_TextToGraphics(G, chr, Options " x" x, Font, , , True), "|")[3]
		Gdip_TextToGraphics(G, chr, Options " x" x - totalWidth / 2 + total " y" Height * 2 / 3, Font)
		total += w
	}
	
	Gdip_DeleteGraphics(G)
	
	Return pBitmap
}


CircularText(Arc, Str, Width, Height, Font, fSize, fStyle, fColour){
	pBitmap := Gdip_CreateBitmap(Width, Height)
	
	G := Gdip_GraphicsFromImage(pBitmap)
	
	Gdip_SetSmoothingMode(G, 4)
	
	Options := "s" fSize " " fStyle " r4 NoWrap Centre vCentre c" fColour ; " h" strSize["h"]
	x := Width / 2
	
	;MsgBox, % Gdip_TextToGraphics(G, Str, Options, Font, 1000000, Height, True)
	strSize := StrSplit(Gdip_TextToGraphics(G, Str, Options " x0 y" Height / 2, Font, , , True), "|")
	strSize := {"w": strSize[3], "h": strSize[4]}
	;MsgBox, % strSize["w"] "`n" strSize["h"]
	
	total := 0
	;lst := []
	for i, chr in StrSplit(Str) {
		w := StrSplit(Gdip_TextToGraphics(G, chr, Options " x0 y" Height / 2, Font, , , True), "|")[3]
		;lst.Push(w)
		total += w
	}
	
	strSize["w"] := total
	
	if(!Arc) {
		Arc := 360
	}
	
	Angle := Arc / strSize["w"]
	
	Options .= " y" 0 ; " h" strSize["h"] ; strSize["h"] / 2 ; " h" strSize["h"]
	
	for i, chr in StrSplit(Str) {
		w := StrSplit(Gdip_TextToGraphics(G, chr, Options " x" x, Font, , , True), "|")[3]
		
		deg := w * Angle
		if(i > 1) {
			RotateAroundCenter(G, deg / 2, Width, Height)
		}
		Gdip_TextToGraphics(G, chr, Options " x" x - w/2 " w" w, Font)
		RotateAroundCenter(G, deg / 2, Width, Height)
	}
	;MsgBox, % strSize["w"] "`n" total
	
	Gdip_DeleteGraphics(G)
	
	Return pBitmap
}



CircularText2(Arc, Str, Width, Height, Font, fSize, fStyle, fColour){
	;static LF := new LOGFONT()
	;LF.SetFontGui(Font, fSize, fStyle)
	;strSize := LF.GetDimensionsInPixels(Str)
	
	;LF.SetFontGdip(Font, fSize, 0)
	;strSize := LF.GetDimensionsInPixels2(Str)
	
	;MsgBox, % strSize["h"]
	
	pBitmap := Gdip_CreateBitmap(Width, Height)
	
	G := Gdip_GraphicsFromImage(pBitmap)
	
	Gdip_SetSmoothingMode(G, 4)
	
	/*
	if(!Arc) {
		Arc := 360
	}
	
	Angle := Arc / strSize["w"]
	*/
	
	
	Options := "s" fSize " " fStyle " r4 NoWrap Centre vCentre c" fColour ; " h" strSize["h"]
	x := Width / 2
	
	;MsgBox, % Gdip_TextToGraphics(G, Str, Options, Font, 1000000, Height, True)
	strSize := StrSplit(Gdip_TextToGraphics(G, Str, Options " x0 y" Height / 2, Font, , , True), "|")
	strSize := {"w": strSize[3], "h": strSize[4]}
	MsgBox, % strSize["w"] "`n" strSize["h"]
	
	total := 0
	lst := []
	for i, chr in StrSplit(Str) {
		w := StrSplit(Gdip_TextToGraphics(G, chr, Options " x0 y" Height / 2, Font, , , True), "|")[3]
		lst.Push(w)
		total += w
	}
	
	strSize["w"] := total
	
	if(!Arc) {
		Arc := 360
	}
	
	Angle := Arc / strSize["w"]
	
	Options .= " y" 0 " h" strSize["h"] ; strSize["h"] / 2 ; " h" strSize["h"]
	
	for i, chr in StrSplit(Str) {
		;w := LF.PixelWidth(chr)
		;w := LF.PixelWidth2(chr)
		;MsgBox, % Gdip_TextToGraphics(G, chr, Options, Font, Width, Height, True)
		;w := StrSplit(Gdip_TextToGraphics(G, chr, Options, Font, Width, Height, True), "|")[3]
		;MsgBox, % w
		;total += w
		w := StrSplit(Gdip_TextToGraphics(G, chr, Options " x" x, Font, , , True), "|")[3]
		
		deg := w * Angle
		if(i > 1) {
			RotateAroundCenter(G, deg / 2, Width, Height)
		}
		Gdip_TextToGraphics(G, chr, Options " x" x - w/2 " w" w, Font)
		RotateAroundCenter(G, deg / 2, Width, Height)
	}
	MsgBox, % strSize["w"] "`n" total
	
	Gdip_DeleteGraphics(G)
	
	Return pBitmap
}


CircularMonoSpacedText(Angle, Str, Width, Height, Font, Options){
	pBitmap := Gdip_CreateBitmap(Width, Height)
	
	G := Gdip_GraphicsFromImage(pBitmap)
	
	Gdip_SetSmoothingMode(G, 4)
	
	if(!Angle) {
		Angle := 360 / StrLen(Str)
	}
	
	for i, chr in StrSplit(Str) {
		Gdip_TextToGraphics(G, chr, Options, Font, Width, Height)
		RotateAroundCenter(G, Angle, Width, Height)
	}
	
	Gdip_DeleteGraphics(G)
	Return pBitmap
}

RotateAroundCenter(G, Angle, Width, Height) {
	Gdip_TranslateWorldTransform(G, Width / 2, Height / 2)
	Gdip_RotateWorldTransform(G, Angle)
	Gdip_TranslateWorldTransform(G, - Width / 2, - Height / 2)
}
