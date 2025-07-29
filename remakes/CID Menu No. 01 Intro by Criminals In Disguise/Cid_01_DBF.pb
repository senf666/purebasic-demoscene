
;Criminals In Disguise
;Compact Disk 01

;Code:		Mad and Ram
;GFX:		Mad and Ram
;Music:		Mad Max
;Remake:	KrazyK

IncludeFile "sound_sndh.pbi"

;IncludeFile "C:\Program Files (x86)\PureBasic\WIP\Intro_Xenon\INTRO_XENON.PB"


Global fs=0				;fullscreen/windowed
Global xres=640,yres=480,offset=40	;40px top and bottom border in fullscreen *640x480) mode

If fs=0:yres=400:offset=0:EndIf		

title$="C.I.D   Menu CD 01"


InitSprite()
If fs=0
OpenWindow(1,0,0,xres,yres,title$,#PB_Window_ScreenCentered|#PB_Window_WindowCentered|#PB_Window_BorderLess)
OpenWindowedScreen(WindowID(1),0,0,xres,yres)
StickyWindow(1,1)
ElseIf fs=1
	OpenScreen(xres,yres,32,title$)
	
Else
	End
EndIf
SetFrameRate(60)
ShowCursor_(0)


;{ Scroller stuff

Global alpha$="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!(),.$?' "
Global scroll$=" C.I.D. PRESENTS  MENU 1  :^ YES THIS IS THE FIRST MENU FROM C.I.D.    IF YOU WANT TO CONTACT US PUT AN AD IN MICRO MART WITH THE WORD C.I.D. IN IT.   MEMBERS OF C.I.D. ARE....    POD    JUDGE DREDD    MAD     RAM    TINSMITH     AND  JAILER                            :^:^:^:^ I JUST THOUGHT I'D PAUSE FOR A BIT SO YOU COULD ADMIRE THE SCREEN....                    POD AND JUDGE DREDD ARE HACKERS AND PACKERS,MAD AND RAM ARE CODERS,TINSMITH AND JAILER ARE SWOPPERS.                        THIS MENU WAS PUT TOGETHER AT PODS HOUSE ON SATURDAY 25TH APRIL..   A COUPLE OF OUR MEMBERS USED TO BE IN ANOTHER GROUP.....                     THIS MENU WAS CODED BY MAD AND RAM...                     .... IF YOU WANT TO KNOW WHAT C.I.D. MEANS, YOU WILL JUST HAVE TO WAIT FOR THE NEXT MENU ....                      I THINK WE SHOULD DO SOME GREETS... GREETS TO..  ECLIPSE (KY GET IN TOUCH)   ADRENALIN   (ESPECIALLY TMB, GET IN TOUCH)   ELECTRONIC (ESPECIALLY TO THE SHADOW)     OUT OF ORDER   GENESIS INC.   EPIC  (CONTACT US...)    CYNIX    HOTLINE ELITE     REPLICANTS     MAD VISION     ICS (GET IN TOUCH)   POMPEY   FOFT   SUPERIOR    FUZION (REPLY BACK SOON)   WILD BOYS    BLUES BROTHERS   ROGER (YOU MUST BE THE FASTEST)  CRAIG (GOOD LUCK WITH THE EXAMS)  AXELL (SORRY ABOUT THE DELAY)  MICH OF SHEFFIELD (GET IN TOUCH)    MATT FROM KENT  AND ANYONE WE'VE MISSED.....                       RIGHT THAT'S ENOUGH SCROLLTEXT FOR NOW COS WE NEED SPACE FOR THE GAMES...  OH NO)   LOOK OUT ......          "
;^ character pauses for 2.5 seconds
Global scroll2$=scroll$	;make a copy of the scroll text

Global tlen=Len(scroll$)
Global speed=16
Global lwidth=64,lheight=32
Global xmove=xres*2
Global letter=1
Global ypos.f,angle.f=180
Global pausing=0	;pause flag
Global tm.f		;timer
CatchSprite(1,?font)
;}

;{ Menu and Logo stuff
CatchSprite(2,?menu)
CatchSprite(3,?mask)
Global menuxpos=(xres/2)-(SpriteWidth(2)/2)	;centre it 
Global redmax=224
Global redmin=32
Global intens.f=255
Global fade.f=-2.55

;}

;{ Rasterbar stuff
;10 bars in total

Structure RasterBars
	rastheight.f
EndStructure

Global Dim RasterBars.RasterBars(9)

RasterBars(0)\rastheight=2
RasterBars(1)\rastheight=2
RasterBars(2)\rastheight=4
RasterBars(3)\rastheight=4
RasterBars(4)\rastheight=6
RasterBars(5)\rastheight=12
RasterBars(6)\rastheight=16
RasterBars(7)\rastheight=20
RasterBars(8)\rastheight=24
RasterBars(9)\rastheight=28

Global rmin=32
Global rmax=396
Global rdiff=(rmax-rmin)/2
Global rmid=rdiff/2	;set centre raster point
CatchSprite(4,?bar)

#SineWaves=2
#SineHeight=170
Global BarSpeed.f=1.68
Global Dim rangle.f(9)			;each Bar has it's own angle array
For A=0 To 9:  rangle(A)=(A*1.4):Next A	;start each raster bar at a different height/angle
Global Dim NewYpos.f(9)			;each bar has it's own Y position array

;}

;{ Volume Meter stuff

CatchSprite(5,?vu)
Global vuwidth=SpriteWidth(5)
Global vuheight=SpriteHeight(5)
Global ch0,ch1,ch2
Global vol.f=SpriteHeight(5)/15		;clip height per volume
;}


Procedure MoveRasterBars()
	
	For Index=0 To 9
		rangle(Index) + #SineWaves*BarSpeed	
		NewYpos(Index)=#SineHeight*Sin(Radian(rangle(Index)+(Index*2*#SineWaves)))
		ClipSprite(4,0,0,xres,RasterBars(Index)\rastheight)
		DisplayTransparentSprite(4,0,NewYpos(Index)+rmid*2+14)
	Next Index
	
EndProcedure

Procedure Scroller()
	
	
	If pausing=1	;are we paued?
		If ElapsedMilliseconds()-tm>2500	;2.45 seconds paused yet?
			pausing=0			;reset the pause flag
			tm=0				;zero the timer
		EndIf
	EndIf
	
	For X=1 To 12 
		t$=Mid(scroll$,letter+X,1)			;read next letter
		If t$="^" And tm=0				;pause character read?
			pausing=1				;set pause flag	
			tm=ElapsedMilliseconds()		;start the timer
			ReplaceString(scroll$,"^"," ",#PB_String_InPlace,letter,1)	;replace the pause character
		EndIf
		pos=FindString(alpha$,t$,0,#PB_String_NoCase)	;find position in the alpha$
		If pos>0					;only display if valid
			ClipSprite(1,0,(pos*lheight)-lheight,lwidth,lheight)
			DisplayTransparentSprite(1,xmove+(X*lwidth),ypos+offset)
		EndIf
	Next X
	
	angle+0.03:ypos=96*Sin(angle)+210			;increase the up/down scroll position even when paused
	
	If pausing=0 And tm=0					;only scroll if not paused
		xmove-speed:If xmove=-(lwidth*2):xmove=-lwidth:letter+1:EndIf
		If letter>tlen:letter=1:xmove=xres*2: scroll$=scroll2$: EndIf
	EndIf

	
	
	
EndProcedure

Procedure Logo()
	DisplayTransparentSprite(2,menuxpos,offset,intens,redmax)
	DisplayTransparentSprite(3,menuxpos,offset,255,RGB(0,0,224))
	intens+fade.f
	If intens<=redmin:fade=2.55:EndIf
	If intens>redmax:fade=-2.55:EndIf
	
	
	
EndProcedure

Procedure MakeStars()
	
	;create 66 stars in 3 different fields, give them a random x,y position
	
	Global starmax=66
	Structure StarField
		sx.f
		sy.f
		sspeed.f
	EndStructure
	
	Global Dim Starfield.StarField(66)
	
With StarField(X)
	For X=0 To 21
		\sx=Random(xres-1)
		\sy=Random(yres-1-offset,offset)
		\sspeed=4
	Next x	
	For X=22 To 44
		\sx=Random(xres-1)
		\sy=Random(yres-1-offset,offset)
		\sspeed=6
	Next x	
	For X=45 To 65
		\sx=Random(xres-1)
		\sy=Random(yres-1-offset,offset)
		\sspeed=8
	Next x	
EndWith

	
EndProcedure

Procedure Stars()
	StartDrawing(ScreenOutput())
	With StarField(X)
		For X=0 To 65
			Box( \sx,\sy,2,2,#White)			;Box ignores screen boundaries unlike Plot
			\sx+\sspeed					;move the stars to the right 	
			If \sx>xres					;edge of screen ?
				\sx=0					;start back at 0 again
				\sy=Random(yres-1-offset,offset)	;new random y position
			EndIf
		Next x
	EndWith
	StopDrawing()
	
EndProcedure

Procedure VUMeters()
	;read each channel volume
	ch0=osme_getchannelvu(0)	
	ch1=osme_getchannelvu(1)
	ch2=osme_getchannelvu(2)
	
	;height to clip of the vu sprite
	vclip0=vol*ch0	
	vclip1=vol*ch1	
	vclip2=vol*ch2	
	
	;clip and display the vu sprite
	ClipSprite(5,0,(vuheight-vclip0),vuwidth,vclip0)
	DisplayTransparentSprite(5,64,offset+268+(vuheight-vclip0))
	
	ClipSprite(5,0,(vuheight-vclip1),vuwidth,vclip1)
	DisplayTransparentSprite(5,256,offset+268+(vuheight-vclip1))
	
	ClipSprite(5,0,(vuheight-vclip2),vuwidth,vclip2)
	DisplayTransparentSprite(5,448,offset+268+(vuheight-vclip2))
	
	
	
EndProcedure


MakeStars()

OSMEPlay(?music,?musend-?music,1)	;start the tune

Repeat	
	If fs=0:w=WindowEvent():EndIf	;only process window events in windowed mode
	
	ClearScreen(0)
	
	MoveRasterBars()
	
	Scroller()
	
	Logo()
	
	VUMeters()
	
	Stars()
	
	
	FlipBuffers()
Until GetAsyncKeyState_(#VK_ESCAPE)
OSMEStop()






DataSection
	vu:	:IncludeBinary "gfx\vu.bmp"			;vu meter
	font:	:IncludeBinary "gfx\font.bmp"			;ripped font
	menu:	:IncludeBinary "gfx\menu.bmp"			;logo and menu
	mask:	:IncludeBinary "gfx\menumask.bmp"		;blue outline
	bar:	:IncludeBinary "gfx\bar.bmp"			;raster bar
	music:	:IncludeBinary "sfx\rings_of_medusa.sndh"	;menu music
	musend:
EndDataSection

; IDE Options = PureBasic 5.71 beta 1 LTS (Windows - x86)
; CursorPosition = 275
; FirstLine = 61
; Folding = Aw
; EnableXP
; Executable = CID_01.exe
; DisableDebugger
; VersionField0 = 1
; VersionField1 = 1
; VersionField2 = KrazyK
; VersionField3 = C.I.D Menu Disk 01
; VersionField4 = 1
; VersionField5 = 1
; VersionField6 = C.I.D Menu Disk 01
; VersionField7 = C.I.D Menu Disk 01
; VersionField8 = CID_01.exe
; VersionField9 = KrazyK
; VersionField10 = KrazyK