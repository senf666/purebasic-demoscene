

scrw=800
scrh=600
numstars=500

OpenScreen(scrw,scrh,32,"2d starfield",#PB_Screen_WaitSynchronization,60)
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
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; CursorPosition = 18
; EnableAsm
; EnableXP
; CompileSourceDirectory