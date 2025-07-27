

KK_Window(800,600)

MyImg=CatchImage(#PB_Any,?rot)

KK_PlasmaSetup(800,600,MyImg)

mode=2	;rotozoom
;try mode 1 to 11

Repeat

	event=WindowEvent()
	KK_PlasmaDraw(0,0,mode)	;

FlipBuffers()

Until GetEsc()


DataSection
       rot:
       IncludeBinary"data\intro.bmp"
EndDataSection
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 8
; EnableAsm
; EnableXP
; DisableDebugger
; CompileSourceDirectory