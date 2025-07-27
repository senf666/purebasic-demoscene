
;Drawing a scroller on a sprite then displaying it a fake tube


DataSection
                
        fontdata:       ;size, back colour, front colour of each slice of the scroller
        Data.l          4,224,32,       7,190,96,       10,128,160,     11,64,255,      11,64,224,      10,128,160,     7,190,96,       4,224,32
        datend:
        
        font:   :IncludeBinary "gfx\bigfont.bmp"
EndDataSection

InitSprite()
OpenWindow(0,0,0,800,600,"",#PB_Window_BorderLess|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0),0,0,800,600)
StickyWindow(0,1)

SpriteQuality(#PB_Sprite_BilinearFiltering)

Enumeration 
        #font
        #tmpimg
        #scrollsprite
EndEnumeration

;define the structure of each slice in the tube
Structure font
        size.l
        colback.l
        colfront.l
EndStructure

Global Dim font.font(7)
CopyMemory(?fontdata,@font(0),?datend-?fontdata)

CatchImage(#font,?font)                
CreateSprite(#scrollsprite,800,64)     ;draw scroltext on here

Global xmove=64*12,speed=8,letter=1
Global scroll$="  THIS IS A FAKE FRONT TUBE SCROLLER     THIS IS A FAKE FRONT TUBE SCROLLER     THIS IS A FAKE FRONT TUBE SCROLLER     THIS IS A FAKE FRONT TUBE SCROLLER     THIS IS A FAKE FRONT TUBE SCROLLER     "
Global alpha$=" !     '()  ,-./0         :    ? ABCDEFGHIJKLMNOPQRSTUVWXYZ"             ;font layout


Procedure DrawFrontTube()
 
ypos=0
For i=0 To 7
        ClipSprite(#scrollsprite,0,(i*8),800,8)                                        ;800x8 pixel slices
        zsize=font(i)\size                                                              ;get the next size
        ZoomSprite(#scrollsprite,800,zsize)                                            ;resize it for your tube
        col=font(i)\colfront                                                            ;get the correct raster colour
        DisplayTransparentSprite(#scrollsprite,0,ypos+300,255,RGB(col,col,col))         ;draw it with the correct colour and in the next y position
        ypos+zsize                                                                      ;y position + the szoomed size
Next i
ProcedureReturn 

EndProcedure


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
        
;        DisplayTransparentSprite(#scrollsprite,0,300)
        
        
EndProcedure


Repeat
        event=WindowEvent()
        ClearScreen(0)
        
        Scroller()              ;create the scrolltext first
        DrawFrontTube()         ;draw the tube version

        FlipBuffers()        
        
Until GetAsyncKeyState_(#VK_ESCAPE)



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 92
; FirstLine = 2
; Folding = 9
; EnableXP
; DPIAware
; DisableDebugger
; HideErrorLog