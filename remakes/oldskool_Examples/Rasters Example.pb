
KK_Window(800,600)

BStep.F=1.2  
BSize=140     ;travel height
BYPos=300     ;centre position

Yinc.F=0
StpY.F=(#PI*2)/(BSize*BStep.F)     ;initial speed step  

KK_RasterInit()

MyBar=KK_RasterCreate(800,1,255)     ;return the SpriteID of the newly created raster bar

;pre-defined shades:
;1     =      Red
;2     =      Green
;3     =      Dark Blue
;4     =      Yellow
;5     =      Light Blue
;6     =      Purple
;7     =      Random

Repeat
       w=WindowEvent()
       ClearScreen(0)
       
       ;simple raster bar drawing rout
       Yinc.F+StpY.F
       For rs=1 To 64 Step 4
              RasterY=(Sin(Yinc.F+(StpY.F*rs))*BSize)+BYPos
              DisplayTransparentSprite(MyBar,0,RasterY)
       Next rs

       FlipBuffers()
Until GetEsc()








; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 29
; DisableDebugger
; HideErrorLog
; CompileSourceDirectory
; EOF
; DontSaveDeclare
; Build=0
; jaPBe Version=3.9.4.774