
;Drawing a scroller on a sprite then displaying the sprite on a sinewave
;this is only one way of doing it though. 
;this is very configurable.

InitSprite()
OpenWindow(0,0,0,800,600,"",#PB_Window_BorderLess|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0),0,0,800,600)

Enumeration 
        #font
        #tmpimg
        #scrollsprite
EndEnumeration


CatchImage(#font,?font)                
CreateSprite(#scrollsprite,800,64)     ;draw scroltext on here

Global xmove=64*12,speed=8,letter=1
Global scroll$="  THIS IS AN IMAGE ON SPRITE SINEWAVE SCROLLER  THIS IS AN IMAGE ON SPRITE SINEWAVE SCROLLER  THIS IS AN IMAGE ON SPRITE SINEWAVE SCROLLER  THIS IS AN IMAGE ON SPRITE SINEWAVE SCROLLER  THIS IS AN IMAGE ON SPRITE SINEWAVE SCROLLER    "
Global alpha$=" !     '()  ,-./0         :    ? ABCDEFGHIJKLMNOPQRSTUVWXYZ"             ;font layout

Global curvestep.f=#PI/(360*5)      ;bigger=smoother
Global c.f,cc.f
#clp=8                 ;slice width
#sineheight=96          ;wave height

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
        
        ;scroll left
        xmove-speed
        If xmove=-128:xmove=-64:letter+1: EndIf
        If letter>Len(scroll$):letter=1:xmove=64*12:EndIf
        
        cc=c            ;save current value
        
        For i=0 To 800 Step #clp
                NewYpos=#sineheight*Sin(curvestep.f*c)                          ;new y position based on the sine value
                ClipSprite(#scrollsprite,i,0,#clp,64)                           ;cut the sprit eup into vertical slices
                DisplayTransparentSprite(#scrollsprite,i,NewYpos+200)           ;draw it
                c-#PI*6                                                         ;add to the sine
        Next i
c=cc	        ;restore old value
c-#PI*10         ;add to it       *** try + and - here for different effects ***
        
EndProcedure


Repeat
        ClearScreen(0)
        
        Scroller()
        
        
        FlipBuffers()        
        
Until GetAsyncKeyState_(#VK_ESCAPE)


DataSection
        font:   :IncludeBinary "gfx\bigfont.bmp"
EndDataSection

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 68
; FirstLine = 14
; Folding = -
; EnableXP
; DPIAware
; DisableDebugger
; HideErrorLog