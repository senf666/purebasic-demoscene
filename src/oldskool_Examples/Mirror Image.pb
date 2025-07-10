

KK_Window(640,400)

LoadImage(10,"data\intro.bmp")


KK_MirrorImageX(10)

StartDrawing(ScreenOutput())
	DrawImage(ImageID(10),0,0)
StopDrawing()
FlipBuffers()

Delay(3000)
KK_MirrorImageY(10)
StartDrawing(ScreenOutput())
	DrawImage(ImageID(10),0,0)
StopDrawing()
FlipBuffers()

Delay(3000)



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 21
; EnableAsm
; EnableXP
; DisableDebugger
; CompileSourceDirectory