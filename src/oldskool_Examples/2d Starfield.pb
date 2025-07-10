

scrw=800
scrh=600
numstars=500

KK_Window(scrw,scrh)
CreateSprite(999,scrw,scrh)

KK_Init2DStars(numstars,scrw,scrh,999)

Repeat
	event=WindowEvent()
	ClearScreen(0)
	;KK_Draw2DStars(-0.5)			;move left
	KK_Draw2DStars(0.5)			;move right
	DisplayTransparentSprite(999,0,0)
	FlipBuffers()
Until GetEsc()


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 12
; EnableAsm
; EnableXP
; CompileSourceDirectory