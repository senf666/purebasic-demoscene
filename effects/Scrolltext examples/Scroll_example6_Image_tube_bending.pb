
;Drawing a scroller on a sprite then display it as a fake tube
;shows both front and back when 'twisting' around and on a sine curve


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
Declare MirrorImageX(ImageID)

Enumeration 
        #font
        #flippedfont
        #tmpimg
        #scrollsprite
        #scrollsprite2
        #tubecopy
        #blank
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
CopyImage(#font,#flippedfont)           ;copy the font
MirrorImageX(#flippedfont)              ;and flip it!
CreateSprite(#scrollsprite,800,64)      ;right way up 
CreateSprite(#scrollsprite2,800,64)     ;flipped scrolltext
CreateSprite(#blank,800,64)

Global xmove=64*12,speed=8,letter=1
Global scroll$="  THIS IS A FAKE TUBE SCROLLER    THIS IS A FAKE TUBE SCROLLER     THIS IS A FAKE TUBE SCROLLER     THIS IS A FAKE TUBE SCROLLER     THIS IS A FAKE TUBE SCROLLER     THIS IS A FAKE TUBE SCROLLER     THIS IS A FAKE TUBE SCROLLER     "
Global alpha$=" !     '()  ,-./0         :    ? ABCDEFGHIJKLMNOPQRSTUVWXYZ"             ;font layout

Global twspeed.f=#PI/2          ;twist speed
Global fonty.f=0,fonty2.f=128   ;starting position of the normal and inverted font (very important!) This took a while to work out!!
Global rcol=Random(160)         ;random colour for the back raster

Global curvestep.f=#PI/(360*5)  ;bigger = smoother
Global c.f,cc.f                 ;sine adds
#clp=4                          ;slice witch
#sineheight=64*2                ;bend height

Procedure DrawFrontTube()
 
ypos=0
For i=0 To 7
        ClipSprite(#scrollsprite,0,(i*8),800,8)                                        ;800x8 pixel slises
        zsize=font(i)\size                                                              ;get the next size
        ZoomSprite(#scrollsprite,800,zsize)                                            ;resize it for your tube
        col=font(i)\colfront                                                            ;get the correct raster colour
        DisplayTransparentSprite(#scrollsprite,0,ypos+300,255,RGB(col,col,col))    ;draw it with the correct colour and in the next y position
        ypos+zsize                                                                      ;y position + the szoomed size
Next i

EndProcedure

Procedure DrawBackTube()
     
ypos=0
For i=0 To 7
        ClipSprite(#scrollsprite2,0,(i*8),800,8)
        zsize=font(i)\size
        ZoomSprite(#scrollsprite2,800,zsize)
        col=font(i)\colback
        DisplayTransparentSprite(#scrollsprite2,0,ypos+300,255,RGB(rcol,0,col)) 
        ypos+zsize
Next i
EndProcedure

Procedure Scroller()
        
        ;two separate sprite scroller
        ;one is normal and scrolling up the sprite
        ;one is flipped and scrolling down the sprite
        ;so when the normal one goes off the top then the flipped one it all visible
        ;we always draw the back one first
        
        
fonty-twspeed    
If fonty<-64:fonty=64:EndIf     ;if it has moved off the top then reset the new start at a whole letter height back so we can then process the back one

fonty2+twspeed
If fonty2>64:fonty2=-64:EndIf  ;moved off the bottom, reset.

;draw both scrollers on thier own sprites

        ;normal
        StartDrawing(SpriteOutput(#scrollsprite))
        For i=1 To (800/64)+2
                t$=Mid(scroll$,letter+i,1)              ;next letter
                pos=FindString(alpha$,t$)-1     ;get the position in font alphabet
                GrabImage(#font,#tmpimg,64*pos,0,64,64)
                DrawImage(ImageID(#tmpimg),xmove+(i*64),fonty)
        Next i
        StopDrawing()
            
        ;flipped
        StartDrawing(SpriteOutput(#scrollsprite2))
        For i=1 To (800/64)+2
                t$=Mid(scroll$,letter+i,1)              ;next letter
                pos=FindString(alpha$,t$)-1     ;get the position in font alphabet
                GrabImage(#flippedfont,#tmpimg,64*pos,0,64,64)
                DrawImage(ImageID(#tmpimg),xmove+(i*64),fonty2)
        Next i
        StopDrawing()
        FreeImage(#tmpimg)
       
        
        xmove-speed
        If xmove=-128:xmove=-64:letter+1: EndIf
        If letter>Len(scroll$):letter=1:xmove=64*12:EndIf
  
        
EndProcedure

Procedure Bendit()
        
        cc=c            ;store current value
        For i=0 To 800 Step #clp
                ysine.f=#sineheight*Sin(curvestep*c)
                ClipSprite(#tubecopy,i,0,#clp,64)
                DisplayTransparentSprite(#tubecopy,i,ysine+300)
                c+(#PI*5)
        Next i
        c=cc            ;restore old value
        c-(#PI*5)       ;add to next y soine position
        
EndProcedure

Procedure MirrorImageX(ImageID) 
	; Mirrors an image around the X-axis 
	Width  = ImageWidth(ImageID) 
	Height = ImageHeight(ImageID) 
	hdc = StartDrawing(ImageOutput(ImageID)) 
		StretchBlt_(hdc,0,Height,Width,-Height-2,hdc,0,0,Width,Height, #SRCCOPY) ; 
	StopDrawing() 
EndProcedure 

Repeat
        event=WindowEvent()
        ClearScreen(0)
        
        Scroller()                              ;create the scrolltext first
        DrawBackTube()                          ;back raster
        DrawFrontTube()                         ;front raster
        
        GrabSprite(#tubecopy,0,300,800,64)      ;grab the currently drawn tube on the screen
        DisplaySprite(#blank,0,300)             ;blank the area first
        
        Bendit()
        
        FlipBuffers()        
        
Until GetAsyncKeyState_(#VK_ESCAPE)



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 170
; FirstLine = 31
; Folding = g
; EnableXP
; DPIAware
; DisableDebugger
; HideErrorLog