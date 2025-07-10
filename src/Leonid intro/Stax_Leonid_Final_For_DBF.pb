;STAX LEONID intro screen

;Code:        Bod
;Gfx:         Bod,Sodan
;Muzak:       Mad Max
;Released:    June 2005
;Remake:      Ripping & Coding KrazyK 2022 

;DBFInteractive.com
;Feel free to edit and use any of this code.  A credit is always nice if you use it in any of your prods though ;-)

KK_Window(640,480)

;{ star sprite field setup =============

Global maxstar=200            ;maximum number of sprites

;Create an array for the starfile with x,y,size and speed
CatchSprite(500,?star)        ;full size sprite
                            
Structure spritefield
	starx.f                   
	stary.f
	starsizex.i
	starsizey.i
	starspeed.f
EndStructure


Global Dim spritefield.spritefield(maxstar+1)
Global ymax=350

With spritefield(i)
For i=0 To maxstar/5
	\starx=Random(640)
	\stary=Random(ymax,16)
	\starsizex=20
	\starsizey=2
	\starspeed=5
Next i

For i=maxstar/5 To maxstar/4
	\starx=Random(640)
	\stary=Random(ymax,16)
	\starsizex=16
	\starsizey=1
	\starspeed=4
Next i

For i=maxstar/4 To maxstar/3
	\starx=Random(640)
	\stary=Random(ymax,16)
	\starsizex=8
	\starsizey=1
	\starspeed=3
Next i

For i=maxstar/3 To maxstar/2
	\starx=Random(640)
	\stary=Random(ymax,16)
	\starsizex=4
	\starsizey=1
	\starspeed=2
Next i

For i=maxstar/2 To maxstar
	\starx=Random(640)
	\stary=Random(ymax,16)
	\starsizex=2
	\starsizey=1
	\starspeed=1
Next i
EndWith



;}

;{ Scroller setup ==================

Global scroll$="  WELL, HERE'S ANOTHER INTRO I'VE FINALLY MADE PUBLIC...  THIS SCREEN WAS CODED BY BOD OF STAX WITH THIS FONT ALSO BY BOD, LOGO BY SODAN OF STAX AND MUSIC BY MAD MAX....     "
CreateImage(20,640,118)		;draw the scrolltext on this image first
Global xmove=640              	;start position of the scrolltext
Global speed=16               ;scroller speed
Global letter=1               ;start letter
Global angle.f=360,oldangle.f ;sine wave calc and copy 
Global ypos,ymove             ;sine wave and raster y position
CatchImage(0,?font)           ;ripped and fixed font
CatchImage(10,?raster)        ;raster image that we scroll up 'behind' the scrolltext 
Global rasth=ImageHeight(10)  ;height of the raster image
#slice=8                      ;width of each clipped part of the scroller to 'bend'
#stp=0.015                    ;step increment of the calulation for the sine wave
CreateImage(40,640,360)       ;draw the sine wave on this image as we have a starfield behind it that we need to show through the #Black background

;}

;{ Setup LEONID sprites ===============

CatchSprite(10,?leonid) ;ripped sprites
DisplaySprite(10,0,0)		;draw it on screen to grab (but don't show it)

Global leo_x.w,leo_ang.f,leo_y.f,leo_path,frame ;vars
Structure leo
	id.i
	index.i
	xpos.w
	ypos.l
	ang.f
EndStructure

Global Dim leo.leo(5)                           ;6 sprites
With leo(i)
	For i=0 To 5                                  ;give each sprite a start position and index
	\id=GrabSprite(#PB_Any,160-(i*32),0,32,32)    ;grab each letter of LEONID
	\index=i*2*4                                  ;start index
	\xpos=EndianW(PeekW(?Path+(i*2)))             ;initial x position read from the ripped data
	\ang+0.0314*\index : If \ang>360:\ang=0:EndIf ;start angle to calculate the y sine position
	\ypos=200*Sin(\ang)                           ;y position value
Next i
EndWith

;}


Procedure Starfield()
With spritefield(i)
For i=0 To maxstar                                    ;each sprite
  \starx+\starspeed                                   ;move right
  If \starx>640:\starx=0:\stary=Random(ymax,16): EndIf    ;off the right side?, calc a new x and y position
	ZoomSprite(500,\starsizex,\starsizey)         ;resize the sprite according to the layer
	DisplayTransparentSprite(500,\starx,\stary)   ;draw it
Next i
EndWith	
	
EndProcedure

Procedure MakeGrad()
CreateImage(100,100,112)                       ;make the yellow faded gradiant for the scrolling message
StartDrawing(ImageOutput(100))
DrawingMode(#PB_2DDrawing_Gradient)
	BackColor(RGB(32,32,0))
	GradientColor(0.1,RGB(96,96,32))
	GradientColor(0.2,RGB(128,128,64))
	GradientColor(0.3,RGB(224,224,96))
	GradientColor(0.4,RGB(224,224,160))
	GradientColor(0.5,RGB(224,224,224))
	GradientColor(0.6,RGB(224,224,96))
	GradientColor(0.7,RGB(128,128,64))
	GradientColor(0.8,RGB(96,96,32))
	GradientColor(0.999999,RGB(32,32,0))
	LinearGradient(50,0,50,112)
	Box(0,0,100,112)
StopDrawing()

CatchImage(101,?cred)     ;crew message
Global ycrew.f=112/2      ;start position
CreateImage(200,100,112)		;draw gradiant and credits on here

EndProcedure

Procedure MoveLeonid()
	
	With leo(i)
	For i=0 To 5
	  \index+4                                      ;skip 2 positions
	  If \index>(?pathend-?Path)-2:\index=0:EndIf   ;check for max
		\xpos=EndianW(PeekW(?path+\index)) *2         ;read a value from the ripped x path data
		\ang+0.0314 : If \ang>360:\ang=0:EndIf        ;increase angle for sine
		\ypos=150*Sin(\ang)+8                         ;new y position
		DisplayTransparentSprite(\id,\xpos,\ypos+170) ;draw a sprite
		Next i
	EndWith
	
EndProcedure

Procedure MoveCred()
	ycrew-1
	If ycrew< -ImageHeight(101):ycrew=0:EndIf             ;minimum reached?, reset
	hdc=StartDrawing(ImageOutput(200))                    ;draw on this image first
		DrawImage(ImageID(100),0,0)	                        ;draw the gradiant
		KK_DrawTransparentImage(hdc,101,0,ycrew-216,#White)	;draw the image above, level and below over the top of the yellow gradiant
		KK_DrawTransparentImage(hdc,101,0,ycrew,#White)     ; 
		KK_DrawTransparentImage(hdc,101,0,ycrew+216,#White) ;
	StopDrawing()
	
	StartDrawing(ScreenOutput())                  ;then display it on screen
		DrawImage(ImageID(200),4,480-112)           ;left side
		DrawImage(ImageID(200),536,480-112)         ;right side
	StopDrawing()
	
EndProcedure

Procedure Scroller()

ymove-2				                                          ;move the raster image up the scroll imgage first
If ymove<-(rasth):ymove=0:EndIf                         ;minimum reached?, reset

hdc=StartDrawing(ImageOutput(20))                       ;draw on the scrolltext image
For i=1 To (640/64)+2
 	DrawImage(ImageID(10),xmove+(64*i),ymove-rasth)       ;move the raster up
	DrawImage(ImageID(10),xmove+(64*i),ymove)             ;
	DrawImage(ImageID(10),xmove+(64*i),ymove+rasth)       ;
  tval=Asc(Mid(scroll$,letter+i,1))-32                  ;calc the ascii value of the next letter
	GrabImage(0,1,64*tval,5,64,118)                       ;now grab the correct letter
	KK_DrawTransparentImage(hdc,1,xmove+(64*i),0,#White)	;draw the grabbed letter in white as transparent so the raster shows behind ;-)
Next i
StopDrawing()
	
xmove-speed                                             ;move left
If xmove=-128:xmove=-64:letter+1:EndIf                  ;off screen?, next letter
If letter>Len(scroll$):letter=1:xmove=640:EndIf         ;last letter?, reset

angle-#stp:If angle<0:angle=360:EndIf                   ;increase angle for sine wave
oldangle=angle	                                        ;save the current angle after 1 increase

hdc=StartDrawing(ImageOutput(40))                       ;draw the bended wave on thie image first
Box(0,0,640,360,0)                                      ;clear it first
For i=0 To 640 Step #slice                              ;start cutting it up
	ypos=114*Sin(angle)                                   ;calc the next y position
	GrabImage(20,21,i,0,#slice,118)		                    ;cut it up
	KK_DrawTransparentImage(hdc,21,i,ypos+124,#Black)     ;draw it with black as transparent 
	angle+#stp                                            ;increase angle
Next i
FreeImage(21)                                           ;free the (not really needed, but tidy!)

StopDrawing()
;DeleteDC_(hdc)
angle=oldangle	                                        ;restore the old angle 

hdc=StartDrawing(ScreenOutput())                        ;draw the whole bended image on screen
	KK_DrawTransparentImage(hdc,40,0,10,#Black)            ;transparent black so the spritefield show behind
StopDrawing()
EndProcedure


bar=CatchSprite(#PB_Any,?bar)		;blue bar
stax=CatchSprite(#PB_Any,?logo) 	;STAX logo
MakeGrad()                      	;create the yellow gradiant


OSMEPlay(?music,?musend-?music,0)   	;start the music

Repeat
	Event=WindowEvent()
	ClearScreen(0)
	

	Starfield()
	Scroller()
	MoveLeonid()
	MoveCred()
	DisplayTransparentSprite(bar,0,10):DisplayTransparentSprite(bar,0,480-SpriteHeight(stax))	;blue bars
	
	DisplayTransparentSprite(stax,0,480-SpriteHeight(stax)); STAX logo
	
	FlipBuffers()
	
Until GetEsc()

OSMEStop()
End

DataSection
	bar:	:IncludeBinary "gfx\bar.bmp"
	font:	:IncludeBinary "gfx\fixedfont.bmp"
	raster:	:IncludeBinary "gfx\adraster.bmp"
	Leonid:	:IncludeBinary "gfx\leonid.bmp"
	cred:	:IncludeBinary "gfx\crew.bmp"
	logo:	:IncludeBinary "gfx\staxlogo.bmp"
	star:	:IncludeBinary "gfx\starsprite.bmp"
	path:	:IncludeBinary "gfx\path.bin"           ;ripped x co-ord data
	pathend:
	
	music:	:IncludeBinary "sfx\Cybernoid_2.sndh"
	musend:
	
EndDataSection
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 11
; Folding = A9
; EnableXP
; Executable = Stax_Leonid_9.exe
; DisableDebugger
; IncludeVersionInfo
; VersionField0 = 1
; VersionField1 = 1
; VersionField2 = KrazyK
; VersionField3 = Stax Leonid Win32 Remake
; VersionField4 = 1
; VersionField5 = 1
; VersionField6 = Stax Leonid Win32 Remake
; VersionField7 = Stax_Leonid
; VersionField8 = Stax_Leonid.exe
; VersionField9 = KrazyK
; VersionField10 = KrazyK