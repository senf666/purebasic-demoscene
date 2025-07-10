


KK_Window(640,400)

KK_InitFlipMode(1)		;Enable the library

LoadSprite(1,"data\intro.bmp")
CreateImage(11,640,480)
ClearScreen(0)
DisplaySprite(1,0,0)		;display the normal sprite
FlipBuffers()
Delay(2000)


KK_MirrorSprite(1)		;mirror sprite horizontally
DisplaySprite(1,0,0)
FlipBuffers()
Delay(2000)

KK_FlipSprite(1)		;flip sprite upside down
DisplaySprite(1,0,0)
FlipBuffers()

Delay(2000)
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 24
; EnableAsm
; EnableXP
; DisableDebugger
; CompileSourceDirectory