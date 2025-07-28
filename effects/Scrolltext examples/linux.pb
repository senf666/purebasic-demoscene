; Scroll_example1_Image.pb by KrazyK
;
; Ammended to compile & run for Linux demo version 5.31 by SToS

; Added to pass compilation on my system
Import "-no-pie"
EndImport

;Drawing a scroller on a sprite then displaying the sprite
If InitSprite() = 0 Or InitKeyboard() = 0
  MessageRequester("Error", "Sprite system can't be initialized", 0)
  End
EndIf

; Added to get anything to display? I think OpenWindowScreen is broken on Linux or at least the demo version 5.31
OpenScreen(800, 600, 32, "Scroll Example 1")

; Removed the following, see above
;OpenWindow(0,0,0,800,600,"",#PB_Window_ScreenCentered|#PB_Window_BorderLess)
;OpenWindowedScreen(WindowID(0),0,0,800,600,0,0,0)
;StickyWindow(0,1)

Enumeration 
        #font
        #tmpimg
        #scrollsprite
EndEnumeration

CatchImage(#font,?font)                
CreateSprite(#scrollsprite,800,64)     ;draw scroltext on here

Global xmove=64*12,speed=8,letter=1
Global scroll$="  THIS IS AN IMAGE ON SPRITE THIS IS A TEST SCROLLER  THIS IS AN IMAGE ON SPRITE THIS IS A TEST SCROLLER  THIS IS AN IMAGE ON SPRITE THIS IS A TEST SCROLLER  THIS IS AN IMAGE ON SPRITE THIS IS A TEST SCROLLER           THIS IS AN IMAGE ON SPRITE THIS IS A TEST SCROLLER  THIS IS AN IMAGE ON SPRITE THIS IS A TEST SCROLLER                     "

Global alpha$=" !     '()  ,-./0         :    ? ABCDEFGHIJKLMNOPQRSTUVWXYZ"             ;font layout


Procedure Scroller()
        
        StartDrawing(SpriteOutput(#scrollsprite))
        For i=1 To (800/64)+2
                t$=Mid(scroll$,letter+i,1)              ;next letter
                pos=FindString(alpha$,t$)-1     ;get the position in font alphabet
                GrabImage(#font,#tmpimg,64*pos,0,64,64)
                DrawImage(ImageID(#tmpimg),xmove+(i*64),0)
        Next i
        StopDrawing()
        FreeImage(#tmpimg)
        
        xmove-speed
        If xmove=-128:xmove=-64:letter+1: EndIf
        If letter>Len(scroll$):letter=1:xmove=64*12:EndIf
        
        DisplayTransparentSprite(#scrollsprite,0,300)
        
EndProcedure


Repeat
        ;Removed, not needed for fullscreen
        ;event=WindowEvent()
        ClearScreen(0)
        
        Scroller()
        
        FlipBuffers()        
        
        ExamineKeyboard()
; Added, as GetAsyncKeyState is Windows only
Until KeyboardPushed(#PB_Key_Escape)
; Removed, see above
;Until GetAsyncKeyState_(#VK_ESCAPE)
      


DataSection
        font:   :IncludeBinary "./GFX/bigfont.bmp"
EndDataSection