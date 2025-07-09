;ZUUL Compact Disk 165
;Code:		Stix
;Gfx:		Zuul
;Music:		Mad Max
;Remake:	KrazyK 2024


#xres=640
#yres=400
InitSprite()
screenscale.f = DesktopScaledX(100) / 100
screenscalex.i = #xres / screenscale
screenscaley.i = #yres / screenscale
window = OpenWindow(0, 0, 0, screenscalex, screenscaley, "", #PB_Window_BorderLess | #PB_Window_ScreenCentered | #PB_Screen_NoSynchronization | #PB_Window_Invisible)
OpenWindowedScreen(WindowID(0), 0, 0, #xres , #yres, #True, 0, 0)
HideWindow(0, #False)

;Resize to 800x600
rx=800
ry=600
wxpos=WindowX(0)-((rx-#xres)/2)                ;centralize new positions
wypos=WindowY(0)-((ry-#yres)/2)
ResizeWindow(0,wxpos,wypos,rx,ry)
StickyWindow(0,1)
SetFrameRate(60)
SpriteQuality(#PB_Sprite_BilinearFiltering)
ClearScreen(RGB(32,0,0))
FlipBuffers()
Delay(1000)

;{ Init the gfx etc

Enumeration gfx
        #fontimg
        #text
        #textspr
        #zolt
        #land
        #grid
        #gridspr
        #scrollsprite
        #tmpimg
EndEnumeration

;scroller
CatchImage(#fontimg,?font)
CreateImage(#scrollsprite,640,40)
CatchImage(#land,?land)
Global Dim scrfont(100)
i=0
For y=0 To 4
        For x=0 To 9
                scrfont(i)=GrabImage(#fontimg,#PB_Any,x*64,y*41,64,41)
                i+1
        Next x
Next y
Global scroll$=UCase("                YEAH ! THAT'S THE MEGAMIGHTY - ZUUL - HERE !  AND THAT'S THE FABULOUS - NUCLEAR - SPEAKING TO YOU ! I HAVEN'T ANYTHING TO TELL , EXCEPT THAT I HAVE DONE MANY CD-COLLECTIONS AND THAT YOU MUST TAKE THEM ! A FEW GREETINGS NOW : THEY ARE MOSTLY SENT TO ALL OTHERS GUYS IN ZUUL ( SYNTAX ERROR , FRODON , HARRY , GRANDMASTER , STIX , LARRY LAFFER , KEN , XORF ... LORD NOVA FROM EMPIRE , SKAVEN FROM THE MASTERS , FUTUR MINDS ( SKYLINE ) , HOLOCAUST , CAMEO FROM THE REPLICANTS , AKIRA ( THE MAD COPYING GUY ! ) AND ALL OTHERS FRIENDS ! ... STOP HERE AND GO TO BED !                 (C) ZUUL 1991 - NUCLEAR -             ")
Global alpha$=""
alpha$+".!01234567"
alpha$+"89:'/=-?,A"
alpha$+"BCDEFGHIJK"
alpha$+"LMNOPQRSTU"
alpha$+"VWXYZ()   "
Global letter=1,xmove=-64,speed=8


;intro text
CatchImage(#text,?text)
CatchSprite(#text,?text)
DisplaySprite(#text,0,0)
GrabSprite(#zolt,0,0,274,58):TransparentSpriteColor(#zolt,RGB(32,0,0))  ;zolt sprite to dist
CreateSprite(#textspr,640,300):TransparentSpriteColor(#textspr,0)       ;draw the intro text on here
ClearScreen(#Black)
Global introdone=0,zolty=-56,ytext=17,xtext=0


;sine movers
Global xsine,ysine,xcount,ycount,xmax=418,ymax=350,oldx,oldy,xpos.f,ypos.f,pos
Global xcount2=200,ycount2=100,oldx2,oldy2,xpos2.f,ypos2.f


;Zuul back sprite grid
CatchImage(#grid,?grid)
CreateSprite(#gridspr,640*2,400*2):TransparentSpriteColor(#gridspr,#Black)
StartDrawing(SpriteOutput(#gridspr))    ;create grid of ZUULs
For y=0 To 8
        For x=0 To 10
                DrawImage(ImageID(#grid),x*128,y*110)
        Next x
Next y
StopDrawing()
Global gridx,gridy,xangle.f,yangle.f
Global xstep.f=(#PI*2)/500
Global ystep.f=(#PI*2)/500



;}

Procedure Intro()
        
        If zolty=0:gotext=1:EndIf
        
        DisplayTransparentSprite(#zolt,0,zolty)
        
        StartDrawing(SpriteOutput(#textspr))
        If zolty<0:zolty+1:EndIf
        If gotext=1
                GrabImage(#text,#tmpimg,xtext,ytext,16,20)
                DrawImage(ImageID(#tmpimg),xtext,ytext)
        EndIf
        xtext+16
        If xtext>640
                xtext=0        
                ytext+20
                If ytext>320
                        introdone=1
                EndIf
        EndIf
        StopDrawing()
        FreeImage(#tmpimg)
        DisplayTransparentSprite(#textspr,0,0)
        
EndProcedure

Procedure MoveBack()
        
        xangle+0.02
        gridx=200*Sin(xangle)
        yangle+0.06
        gridy=96*Sin(yangle)
        DisplayTransparentSprite(#gridspr,-320+gridx,-200+gridy)
        
EndProcedure

Procedure DrawTransparentImage(DestImage.l,SourceImage.l,xdest,ydest,transcol.l);Dest Image,Source Img,XDest,YDest,Transparency
	hdcSrc2 = CreateCompatibleDC_(DestImage)
	SelectObject_(hdcSrc2, ImageID(SourceImage))
	TransparentBlt_(DestImage,xdest,ydest,ImageWidth(SourceImage),ImageHeight(SourceImage),hdcSrc2,0,0,ImageWidth(SourceImage),ImageHeight(SourceImage),transcol)
	DeleteDC_(hdcSrc2)
EndProcedure

Procedure MoveZolt()
        
        oldx=xcount
        oldy=ycount
        For y=0 To 56 Step 2     
                xpos=PeekB(?sinex+xcount)*2.5
                ypos=PeekB(?siney+ycount)*2.5
                ClipSprite(#zolt,0,y,640,2)
                DisplayTransparentSprite(#zolt,Abs(xpos)-48,y+Abs(ypos)-16)
                xcount+1
                
        Next y
        
        xcount=oldx+1
        If xcount>xmax:xcount=0:EndIf
        ycount=oldy+1
        If ycount>ymax:ycount=0:EndIf
        
        oldx2=xcount2
        oldy2=ycount2
        For y=0 To 56 Step 2     
                xpos2=PeekB(?sinex+xcount2)*2.5
                ypos2=PeekB(?siney+ycount2)*2.5
                ClipSprite(#zolt,0,y,640,2)
                DisplayTransparentSprite(#zolt,Abs(xpos2)-48,y+Abs(ypos2)-16)
                xcount2+1
        Next y
        
        xcount2=oldx2+1
        If xcount2>xmax:xcount2=0:EndIf
        ycount2=oldy2+1
        If ycount2>ymax:ycount2=0:EndIf

        
        
        
EndProcedure

Procedure Scroller()
        hdc=StartDrawing(ImageOutput(#scrollsprite))
              DrawImage(ImageID(#land),0,0)
                For i=1 To 12
                        t$=Mid(scroll$,letter+i,1)
                        pos=FindString(alpha$,t$)-1
                        If pos<0:pos=58:EndIf
                        DrawTransparentImage(hdc,scrfont(pos),xmove+(64*i),0,#White)
                Next i
        StopDrawing()
        xmove-speed:If xmove=-128:xmove=-64:letter+1:EndIf
        If letter>Len(scroll$):letter=1:xmove=0:EndIf
        
        hdc=StartDrawing(ScreenOutput())
                Box(0,400-35,640,35,RGB(32,0,0))
                DrawTransparentImage(hdc,#scrollsprite,0,400-35,RGB(0,0,0))
        StopDrawing()
        
        
EndProcedure

Procedure MainLoop(m)
        
        Repeat  
                ClearScreen(RGB(32,0,0))
                If introdone=0
                        Intro()
                Else
                        MoveBack()
                        MoveZolt()
                        Scroller()
                EndIf
                FlipBuffers()
        Until GetAsyncKeyState_(#VK_ESCAPE)
        OSMEStop()
        End
        
EndProcedure

OSMEPlay(?music,?musend-?music,9)

thread=CreateThread(@MainLoop(),0)     


Repeat
        Delay(1)                                ;give some cpu back
        WindowEvent = WindowEvent()
        If fs=0
 	Select WindowEvent
 	        Case #WM_LBUTTONDOWN
                        SendMessage_(WindowID(0), #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
                Case #WM_LBUTTONUP
  			SendMessage_(WindowID(0), #WM_NCLBUTTONUP, #HTCAPTION, 0)
  	EndSelect
        EndIf
 
ForEver




DataSection
        font:   :IncludeBinary "gfx\fonts9.bmp" ;64x41
        land:   :IncludeBinary "gfx\land.bmp"
        text:   :IncludeBinary "gfx\intext.bmp"
        grid:   :IncludeBinary "gfx\square.bmp" ;128x110
        music:  :IncludeBinary "sfx\mad.sndh"
        musend:
        
        ;ripped sine data from priginal ST .prg file
        sinex:  :IncludeBinary "zuul1_sine.bin"
                 IncludeBinary "zuul1_sine.bin"
        siney:  :IncludeBinary "zuul2_sine.bin"
                 IncludeBinary "zuul2_sine.bin"
        
        
EndDataSection

; IDE Options = PureBasic 6.12 LTS (Windows - x86)
; CursorPosition = 5
; Folding = A-
; EnableThread
; EnableXP
; DPIAware
; UseIcon = Icon_22.ico
; Executable = Zuul_165.exe
; SubSystem = directx9
; DisableDebugger
; HideErrorLog
; Compiler = PureBasic 6.12 LTS (Windows - x86)
; SharedUCRT