;- Atari ST -- Stax Anarchy Intro

;-Coder:	BOD
;-Graphics:	BOD
;-Music:	Mad Max

;-Win32 Remake:	KrazyK
;-PureBasic 5.42 (x86) --- set tabs to 8 !

;- Feel free to modify, edit, change etc.  I wrote this in a couple of days so it can definitely be improved.
;- Don't forget where you got it from though.  A small credit would be nice ;-)


If InitSprite()=0:MessageRequester("Oops!","DirectX could not be initialized, quitting!"):End:EndIf


DataSection
	music:
	IncludeBinary"sfx\an.sndh"
	musend:
	
	font:
	IncludeBinary"gfx\Anarchy_font.bmp"
	
	anarchy_logo:
	IncludeBinary"gfx\anarchy.bmp"
	anarchy_pal:
	IncludeBinary"gfx\anarchy_raster.bmp"
	
	;-Stax logo layers
	stax1:
	IncludeBinary"gfx\staxlayer1.bmp"
	stax2:
	IncludeBinary"gfx\staxlayer2.bmp"
	stax3:
	IncludeBinary"gfx\staxlayer3.bmp"
	
;- ===================== STAX logo palette colours for each layer ===================	
	staxpalette:
	Data.l	128,0,0
	Data.l	64,0,0
	Data.l	224,0,0
	
	Data.l	0,0,128
	Data.l	0,0,64
	Data.l	0,0,224
	
	Data.l	160,160,160
	Data.l	64,64,64
	Data.l	224,224,224
	
	Data.l	0,160,0
	Data.l	0,64,0
	Data.l	0,224,0
	
	Data.l	160,160,0
	Data.l	64,64,0
	Data.l	224,224,0
	
	
	Data.l	0,160,160
	Data.l	0,64,64
	Data.l	0,224,224
	
	Data.l	160,0,160
	Data.l	64,0,64
	Data.l	224,0,224
	
	staxpalette_end:
	
EndDataSection


;-================ STAX logo palette setup =============================
Structure Cols
	sred.l
	sgreen.l
	sblue.l
EndStructure


Global Dim Stax_Palette.Cols(32)
;-Copy all the palette data into the array at once.
CopyMemory(?staxpalette,@Stax_Palette(0),?staxpalette_end-?staxpalette)
Global palette_pos=0	;-start at the beginning !!
Restore staxpalette

;{  Screen Setup
;-The ST could only normally show 320x200 so doubling this is 640x400
;-However, we can only open a 640x480 screen so there are 80 pixels spare.
;-Therefore to keep everything in proportion and correct we need to draw everything
;-at an offset of 40 pixels from the top of the screen.
;-Make sure we do not draw anything in the bottom 40 pixels.
;-Gotta keep it accurate, otherwise we would have stretched pixels which look shit.
;}

#scrx=640	;-screen width
#scry=480	;-screen height
#scroll_speed=4	;-scroll speed
#pausetime=4000	;-scroll pause time
#sine=124	;-sine height
#y_offset=40	;-from top of screen


FS=0	;-fullscreen or windowed 0/1

If FS=0
	OpenWindow(1,0,0,#scrx,#scry,"",#PB_Window_BorderLess|#PB_Window_ScreenCentered|#PB_Window_WindowCentered)
	OpenWindowedScreen(WindowID(1),0,0,#scrx,#scry)
Else
	OpenScreen(#scrx,#scry,32,"")
EndIf
ShowCursor_(0)	;-no mouse cursor!

;{  ===========================  Starfiled Setup =========================

;-Here we create a multi dimension array to hold the values of the starfield.
;-We have 3 layters and 64 stars per layer.
;-Calculate some random vlaues for the initil x and y positions then set the speeds and colours for each layer.
;-The closer the stars, the faster they move and the brighter they are.
;}


#numstars=64
#starlayers=3
Structure StarVars
	star_x.l
	star_y.l
	star_speed.F
	star_colour.l
EndStructure

Global Dim Stars.StarVars(#starlayers,#numstars)

Procedure Create2DStarfield()
;-make some random initial x y positions
For S=1 To #starlayers
	For F=0 To #numstars-1
		Stars(S,F)\star_x=Random(#scrx)
		Stars(S,F)\star_y=Random(360,#y_offset)
	Next F
Next S
	
;-speed and colours 
For F=0 To #numstars-1
	Stars(1,F)\star_speed=2 : Stars(1,F)\star_colour=RGB(64,64,64)
	Stars(2,F)\star_speed=4 : Stars(2,F)\star_colour=RGB(128,128,128)
	Stars(3,F)\star_speed=8 : Stars(3,F)\star_colour=RGB(224,224,224)
Next F
	
EndProcedure


;- ===================STAX logo setup ====================
;-Logo has 1 main layer and 2 'shadow' layers
;-Catch the sprite layers starting at 50 - there is a reason for this!!
CatchSprite(50,?stax1)
CatchSprite(51,?stax2)
CatchSprite(52,?stax3)
Global coltimer			;-colour timer
Global Stax_angle,Stax_X.F	;-movement variables

;-====  Font & Scroller variables ========================
Global width=32,height=32	;-font dimensions
Global speed=#scroll_speed	;-scrolltext speed
Global xmove=#scrx		;-start off to the right 
Global letter=1			;-scrolltext start
Global spx			;-clipping

Global scroll$=	"    STAX STRIKES BACK ONTO YOUR SCREEN WITH ANOTHER AMIGA CONVERSION...  THIS TIME WE CONVERTED AN INTRO BY"
scroll$+	"        @     A N A R C H Y           THE CREDITS ARE AS FOLLOWS: ALL CODING AND LOGO DRAWING WAS DONE BY   "
scroll$+	"@        B O D           OF STAX. THIS FONT COMES FROM A FONT COLLECTION DISK AND THE MUSIC WAS COMPOSED BY "
scroll$+	"MAD MAX FROM THE EXCEPTIONS....      GREETINGS TO THE FOLLOWING PEOPLE...    ABSENCE. ACF DESIGN TEAM. ADM. "
scroll$+	"ADRENALINE. AGGRESSION. ANIMAL MINE. AVENA. AURA. CHECKPOINT. CONFUSIONS. CREAM. CRUOR. DIGI TALLIS. DISPLASY."
scroll$+	" DUNE. DEAD HACKERS SOCIETY. DEPRESSION. EFFECT. EKO. ELITE. EMPTY HEAD. ESCAPE. E.X.A. EXTREAM. FUN. I.C.E."
scroll$+	" IMPONANCE. IMPULSE. INFERIOR. INTER. IPIR. LAZER. LUZAK TEAM. LYNX. MAGGIE TEAM. MIND DESIGN. MJJ PROD. NEW"
scroll$+	" TREND. NEW BEAT DEVELOPMENT. NEWLINE. NEW POWER GENERATION. NO LIMIT CODING. NO CREW. PANDEMONIUM. P.H.F. "
scroll$+	"POPSY TEAM. POSITIVITY. PULSE. REBELSOFT. RDT. RESERVOIR GODS. RUNNING DESIGN TEAM. SECTOR ONE. SENTRY. ST "
scroll$+	"KNIGHTS. SHADOWS. SHELTER. SPIRITS. STOSSER SOFT. SUBLIME. SUPREMACY CORP. THE ADMIRABLES. THE BLACK LOTUS. "
scroll$+	"THE CAREBEARS. THE CHAOS WARRIORS. THERAPY. THE EAGLES. THE CHAOS ENGINE. THE GOLDEN DAWN. THE MISFITS. THE "
scroll$+	"MUGWUMPS . THE REBELIANTS. THE SENIOR DADS. THE VOTION. TSCC. TNB. TOONS. T.O.Y.S. TPN. TRIO. TUMULT. "
scroll$+	"TYPHOON. VECTRONIX. WILDFIRE. ZEAL.   THATS ALL FOR TODAY.......     TEXT RESTARTS.........................."
scroll$+	"....                    "
UCase(scroll$)			;-uppercase in case some rogue letters in there!

Global Tlen=Len(scroll$)	;-scrolltext length
Global Tval			;-ascii value
Global TM,TM2			;-pause timers
CatchSprite(100,?font)		;-ripped font - this took a while to rip, believe me!!

Structure CharPos	
	Char_Angle.F		;-hold the angle value, which is used to calculate the Y positions of each cahracter in the scrolltext
	Char_Y.F		;-holds the values of the Y positions of each letter in the scrolltext
EndStructure

Global Dim Chars.CharPos(Tlen+1);-create the letter array

Procedure Init_Scroller()
;-Start by giving initial y positions of each letter based on a sine angle value
cnt=0
For L=1 To Tlen								;-all letters please
	cnt+16								;-increase the angle
	Chars(L)\Char_Angle=cnt						;-set the initial angle
	Chars(L)\Char_Y=#sine*Sin(Radian(Chars(L)\Char_Angle))+200	;-and the initial Y position
Next L
;-===================================================================================
EndProcedure

Procedure Move2DStars()
StartDrawing(ScreenOutput())
For S=1 To #starlayers
	For F=0 To #numstars-1
		Box(Stars(S,F)\star_x,Stars(S,F)\star_y,2,2,Stars(S,F)\star_colour)
		Stars(S,F)\star_x-Stars(S,F)\star_speed
		If Stars(S,F)\star_x<=0:Stars(S,F)\star_x=#scrx:EndIf
	Next F
Next S
Line(0,440-83,640,2,#White)
StopDrawing()	
EndProcedure

Procedure Make_Anarchy_Palette()
CatchImage(0,?anarchy_pal)
CatchSprite(1,?anarchy_logo):TransparentSpriteColor(1,#White)
CreateSprite(2,640,1020)
StartDrawing(SpriteOutput(2))
	DrawImage(ImageID(0),0,0,SpriteWidth(1),1020)
StopDrawing()
EndProcedure

Procedure Scroll_Anarchy_Palette()
;- Simply clip a portion of the colour palette sprite and display it.
;- Then display the Anarchy logo with white as transparent so it shows through the back
Protected y_scroll
	
ClipSprite(2,0,scroll_y,640,SpriteHeight(1))
scroll_y+1:If scroll_y>1000-SpriteHeight(1):scroll_y=0:EndIf
DisplaySprite(2,20,440-SpriteHeight(1)-1)
DisplayTransparentSprite(1,20,440-SpriteHeight(1)-2)
EndProcedure

Procedure MoveStax()
Stax_angle+2					;-swing speed
If Stax_angle>=360:Stax_angle=0:EndIf		;-max 360
Stax_X=200*Sin(Radian(Stax_angle))+140		;-calculate x position

If ElapsedMilliseconds()-coltimer>5000		;-time up?
	palette_pos+3				;-then next colour in the palette please?
	coltimer=ElapsedMilliseconds()		;-start the timer again
	If palette_pos>21:palette_pos=0:EndIf	;-reached the last colour yet?
EndIf

For C=0 To 2					;-all 3 lsprite layers
	sr=Stax_Palette(palette_pos+C)\sred	;-get red value
	sg=Stax_Palette(palette_pos+C)\sgreen	;-get green value
	sb=Stax_Palette(palette_pos+C)\sblue	;-get blue value
	DisplayTransparentSprite(50+C,Stax_X,440-SpriteHeight(50+C),255,RGB(sr,sg,sb))
Next C

	
EndProcedure

Procedure Scroller()

;-Do all the letters in the scroll text, but only display the ones that are within the screen boundary.
;-Normally I would just draw a screen width (22 letters in this case) but this lead to complications when re-calculating the sine angles and my brain started to hurt!!
;-It's actually just as fast doing it this way I found out anyway!
	
	
For L=1 To Tlen-1	

	If TM>0					;-is the pause timer going?
		TM2=ElapsedMilliseconds()-TM	;-how long have we been paused?
		If TM2>#pausetime		;-pause time reached?
			TM=0			;-cancel the timer
			speed=#scroll_speed	;-reset the speed
		EndIf
	EndIf
	
	If Mid(scroll$,letter-1,1)="@"		;-pause character reached?
		speed=0				;-stop scrolling
		TM=ElapsedMilliseconds()	;-start the timer
		letter+1			;-next letter
		xmove+32			;-move forward to stop the jump!
	EndIf
	
	T$=Mid(scroll$,letter+L,1)		;-read 1 letter
	
	;-check the letters for the pause character, a space and the odd 2 characters at rhe end of the font sprite
	Select T$	
			
		Case "@"			;-pause character
			Tval=28			;-replace with a space
		Case ":"			;-colon
			Tval=26			;-ascii value position
		Case "."			;-stop
			Tval=27			;-ascii value position
		Case " "			;-space
			Tval=28			;-ascii value position
		Default
			Tval=Asc(T$)-65		;-all other characters
	EndSelect
		
	spx = Tval*width			;-calculate the clipping position
			
;- only draw the letters that are within the screen boundary and within the clipping zone.
	If (xmove+(L*width)>=-width And xmove+(L*width)<=(#scrx+width) And (spx>=0))
		ClipSprite(100,spx,0,width,height)			;-grab the font character
		DisplayTransparentSprite(100,xmove+(L*width),Chars(L+letter)\Char_Y)
	EndIf
	Chars(L)\Char_Angle+2						;-vertical speed of each letter
	Chars(L)\Char_Y=#sine*Sin(Radian(Chars(L)\Char_Angle))+206	;-calculate new y position
Next L

xmove-speed						;-scroll left
If xmove<=-(width*2):xmove=-width:letter+1:EndIf	;-moved off the screen by 2 letters?
If letter>=Tlen-22:letter=1:xmove=#scrx:EndIf		;-reached and of text/
	
EndProcedure

Init_Scroller()				;-set the initial y positions for each letter
Make_Anarchy_Palette()			;-make our big colour raster sprite
Create2DStarfield()			;-make our starfield
coltimer=ElapsedMilliseconds()		;-start the STAX colour timer
OSMEPlayMusic(?music,?musend-?music,1)	;-play the music
OSMESetVolume(100)			;-max volume

Repeat
	ClearScreen(0)
	If FS=0:w=WindowEvent():EndIf	;-process window events in windowed mode
	
	Scroll_Anarchy_Palette()
	MoveStax()
	Scroller()		
	Move2DStars()			;-stars are on the top layer - usually they are on the back!

	FlipBuffers()
	
Until GetAsyncKeyState_(#VK_ESCAPE)
OSMEStopMusic()
