;Drawing a scroller on a sprite then displaying the sprite

InitSprite()
OpenWindow(0,0,0,800,600,"",#PB_Window_BorderLess|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0),0,0,800,600)
StickyWindow(0,1)

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
        event=WindowEvent()
        ClearScreen(0)
        
        Scroller()
        
        
        FlipBuffers()        
        
Until GetAsyncKeyState_(#VK_ESCAPE)


DataSection
        font:   :IncludeBinary "gfx\bigfont.bmp"
EndDataSection

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 57
; Folding = +
; EnableXP
; DPIAware
; DisableDebugger
; HideErrorLog