; Written by Mikael 'Ampli' Johansson 2019
; Purebasic 5.71
; Enjoy it as I do =) 

InitSprite()
InitKeyboard()

OpenWindow(1, 0,0,800,600,"DBF - Twister", #PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(1),0,0,800,600,0,0,0)
SetFrameRate(30)

Global M_PI.f = 3.1415

Repeat
  ExamineKeyboard()
  event = WindowEvent()
  ClearScreen(RGB(55,155,185))
  
  StartDrawing(ScreenOutput())
    For x = 0 To 799 Step 2
      aa.f  + 0.00015
      s.f = Sin (aa+x / 150) * 120
      
      amp.f = (Cos(x / 8000  ) * s/165)
      
      y1.f = 300 + Cos((aa + amp)                   ) * 157
      y2.f = 300 + Cos((aa + amp) + M_PI / 2        ) * 157
      y3.f = 300 + Cos((aa + amp) + M_PI            ) * 157
      y4.f = 300 + Cos((aa + amp) + M_PI + M_PI / 2 ) * 157
      
      If y1 < y2
        Line(x, y1+s, 1, y2 - y1, RGB(  127+s,   0,  127+s))
        Line(x, y1+s, 9, y2 - y1 , RGB(  255,   255,  255))
       EndIf
       If y2 < y3
         Line(x, y2+s, 1, y3 - y2, RGB(  127-s,   127-s,  0))
         Line(x, y2+s, 9, y3 - y2 , RGB(  255,  255,  255))
       EndIf
       If y3 < y4
         Line(x, y3+s, 1, y4 - y3, RGB(  127+s,   0,  100))
         Line(x, y3+s, 9, y4 - y3 , RGB(  255,   255,  255))
       EndIf
       If y4 < y1
         Line(x, y4+s, 1, y1 - y4, RGB(  0,   127+s,  75))
         Line(x, y4+s, 9, y1 - y4 , RGB(  255,   255,  255))
       EndIf
    Next
  StopDrawing()
  
  
  Delay(1) : FlipBuffers()
  
Until event = #PB_Event_CloseWindow Or KeyboardPushed(#PB_Key_Escape)
End
