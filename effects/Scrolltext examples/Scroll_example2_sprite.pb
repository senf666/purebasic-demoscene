;Drawing a sprite scroller directly to the screen

InitSprite()
OpenWindow(0,0,0,800,600,"",#PB_Window_BorderLess|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0),0,0,800,600)
StickyWindow(0,1)
Enumeration 
        #font
EndEnumeration

CatchSprite(#font,?font)                

Global xmove=64*12,speed=8,letter=1
Global scroll$="  THIS IS A DIRECT SPRITE SCROLLER  THIS IS A DIRECT SPRITE SCROLLER  THIS IS A DIRECT SPRITE SCROLLER  THIS IS A DIRECT SPRITE SCROLLER  THIS IS A DIRECT SPRITE SCROLLER  THIS IS A DIRECT SPRITE SCROLLER  THIS IS A DIRECT SPRITE SCROLLER        "

Global alpha$=" !     '()  ,-./0         :    ? ABCDEFGHIJKLMNOPQRSTUVWXYZ"             ;font layout


Procedure Scroller()
        
        For i=1 To (800/64)+2
                t$=Mid(scroll$,letter+i,1)              ;next letter
                pos=FindString(alpha$,t$)-1             ;get the position in font alphabet
                ClipSprite(#font,64*pos,0,64,64)
                DisplayTransparentSprite(#font,xmove+(i*64),300)
        Next i
        
        xmove-speed
        If xmove=-128:xmove=-64:letter+1: EndIf
        If letter>Len(scroll$):letter=1:xmove=64*12:EndIf
        
        
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
; CursorPosition = 36
; Folding = +
; EnableXP
; DPIAware
; DisableDebugger
; HideErrorLog