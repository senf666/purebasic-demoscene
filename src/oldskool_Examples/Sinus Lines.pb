;KrazyK Sinusline library test


KK_Window(800,600)

KK_SinusInit()

KK_SinusType(1,0,800)
KK_SinusType(2,1,800)
KK_SinusType(3,2,800)
KK_SinusType(4,3,800)
KK_SinusType(5,4,800)
KK_SinusType(6,5,800)
KK_SinusType(7,6,800)


Repeat
w=WindowEvent()

ClearScreen(0)


KK_SinusDraw(1,10,8)
KK_SinusDraw(2,100,-18)
KK_SinusDraw(3,200,-9)
KK_SinusDraw(4,300,2)
KK_SinusDraw(5,400,2)
KK_SinusDraw(6,500,-2)
KK_SinusDraw(7,595,3)



FlipBuffers()


Until GetEsc()




; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 22
; EnableAsm
; EnableXP
; DisableDebugger