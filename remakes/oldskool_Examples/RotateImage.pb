

LoadImage(1,"data\intro.bmp")


KK_Window(800,600)
Repeat
w=WindowEvent()
ClearScreen(0)

  RotImage = ImageID(KK_RotateImage(ImageID(1), angle))
  angle + 1
  StartDrawing(ScreenOutput())
  	DrawImage(RotImage,0,0)
  StopDrawing()
  If IsImage(RotImage) : FreeImage(RotImage) : Delay(20) : EndIf
  
FlipBuffers()
Until GetEsc()

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 19
; EnableAsm
; EnableXP
; DisableDebugger
; CompileSourceDirectory