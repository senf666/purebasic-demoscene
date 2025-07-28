;-Adrenalin CD #33
;-Code:		Spaceman Spiff 
;-Gfx:		BioFeedback
;-Music:	Excellence in Art
;-Year:		1992
;-Remake:	KrazyK

;-Purebasic 5.62 source
;-set tabs to 8 for readability

;-Cracktro remake from the Atari ST by Adrenalin UK.
;-A nice 128x64 rastered main font along with a simple horizontal scrolling starfeld.
;-Also 9 slow reverse bouncing, rastered letters.
;-This source is provided as is so feel free to use any of it as you wish.  
;-A credit is always nice if you use any of it though ;-)


#xres=640
#yres=480
#yoff=40


InitSprite()

fs=0	;windowed=0, fullscreen=1

If fs=0
	OpenWindow(0,0,0,#xres,#yres,"",#PB_Window_ScreenCentered|#PB_Window_WindowCentered|#PB_Window_BorderLess)
	OpenWindowedScreen(WindowID(0),0,0,#xres,#yres)
	StickyWindow(0,1)       		;-keep window on top
	ShowCursor_(0)          		;-hide the mouse
ElseIf fs=1
	OpenScreen(#xres,#yres,32,"")
Else
End
EndIf

Global DLEN=(?admovend-?admove)		;-length of the movement data
Global MAX=(DLEN/4)-1			;-number of steps in the movement
Global Dim AdrMove(DLEN/4)		;-init our array to store the movement
CopyMemory(?admove,@AdrMove(0),DLEN)	;-and copy it into our array

Structure ADREN
	index.L	;-array position
	Spr.i	;-sprite id
EndStructure

Global Dim SPRITES.ADREN(DLEN)


For a=0 To 8
	SPRITES(a)\index=MAX-(12*a)	;-initial starting positions in the movement array
Next a
Global ay


Global scroll$="                              ADRENALIN U.K. OF T.B.A. PROUDLY PRESENT COMPACT DISK THIRTY THREE.    RELEASE DATE  31\3\93    TO GET INTOUCH WITH ADRENALIN KEEP READING....   THIS IS   D I V I N E  ON THE KEYBOARD PRESENTING HIS FIRST MENU OF THE YEAR    WELL WE HAVE ACTUALLY MADE IT    NUMBER  THIRTY THREE............AMAZING          WELL I HAD TO TRY AND MAKE IT INTERESTING   THERES NOTHING REALLY WORTH CELEBRATING FOR QUITE A WHILE   OUR BIRTHDAYS BEEN AND GONE   I SUPPOSE THE NEXT BIG DATE IN THE ADRENALIN CALANDER IS DISK 50.  WELL I THINK THIS DISK IS WORTH CELEBRATING.....     ON THIS DISK YOU WILL FIND CAMPAIGN. THIS GAME IS NOT A NEW RELEASE BUT MOOKIE DID SUCH A GREAT JOB ON IT WE DECIDED TO RELEASE IT. IT WAS CRACKED BY SECTION 1 AND TESTED  PACKED  AND LINK FILED BY MOOKIE OF ADRENALIN.......  ALSO ON THIS DISK YOU WILL FIND A START UP DOC AND KID KONG WHICH IS A PERFECT REPRESENTATION OF ATARIS CLASSIC DONKEY KONG IT WILL ONLY RUN HOWEVER ON 1 MEG MACHINES.  DONKEY KONG WAS REPACKED BY MYSELF DIVINE AND IT WAS SUPPLIED TO ME BY GRAPHITE.   THIS EXCELLENT MENU WAS CODED BY SPACEMAN SPIFF OF ADRENALIN.  THE MUSIC IS BY EXCELLENCE IN ART AND THE ART WORK IS BY BIOFEEDBACK OF ADRENALIN      NOW I AM DEDICATING THIS MENU TO PUBLIC RELATIONS SO IF YOU LIKE THE SOUND OF THIS PROJECT KEEP READING.  ADRENALIN 33 IS NOW THE OFFICIAL PR MENU TO BE A PART OF    THE BIG 33   GET INTOUCH WITH ADRENALIN.  THIS THING WORKS 2 WAYS YOU KNOW.  WE NOW HAVE A DECENT SECURE CONTACT ADDRESS FOR ANY MEMBER OF THE PUBLIC TO WRITE TO.  ALREADY WE HAVE HAD LETTERS FROM ALL OVER BRITTAIN AND NORTHEN EUROPE. IF YOU WANT TO GET MORE OF OUR COMPACTS OR IF YOU HAVE A TALENT LIKE KNOWING HUNDREDS OF ST PEOPLE OR YOU CAN PRODUCE GOOD ARTWORK OR YOU CAN WRITE MUSIC OR CODE MENUS WRITE TO THIS ADDRESS           ADRENALIN UK 33.     6 LIVINGSTONE AVENUE      CLAY LANE ESTATE     DONCASTER     SOUTH YORKSHIRE     ENGLAND.     THAT WAS.....     ADRENALIN UK 33.     6 LIVINGSTONE AVENUE      CLAY LANE ESTATE     DONCASTER     SOUTH YORKSHIRE     ENGLAND.      REPLYS ARE NOW 1000 PERCENT RELIABLE.  IF YOU TRIED WRITTING TO OUR OLD ADDRESS AND GOT NO REPLY TRY THIS ONE I YOU WILL DEFINATLEY RECEIVE A REPLY.  WRITE THAT ADDRESS ON PAPER... WRITE IT ON YOUR DISK LABELS.  GIVE IT YA MATES ALONG WITH THIS DISK           WE HOPE TO HERE FROM YOU SOON   WHO EVER YOU ARE........         NOW FOR THE GREETZ...... GREETINGS TO THE REST OF THE BRITISH ALLIANCE WHO ARE...     C.I.D.,     INSANITY,     OUT OF ORDER (ESP. SONIC),     SYNCRO SYSTEMS (ESP. RAZOR),     THE LEMMINGS (ESP. XENONCIDE)     AND   WILD! (ESP. SNAZ).     GREETINGS ALSO TO THE FOLLOWING...     ADMIRABLES,     ANIMAL MINE,     ANTHRAX      APOLLO,     BREAKPOINT SOFTWARE,     CHAOS (ESP. BEN),     CHRIS H (YORK),     CHRIS H (MID GLAM),     CHRIS H (STAFFS),     CONCEPTORS (ESP. DEMON),      CRACKDOWN (ESP. INSPIRAL),     CYNIX (ESP. SUPERNOVA AND QUATTRO),     D-BUG,     DEVIANT DESIGNERS,     DIGI TALLIS (ESP. ORMOLU),     ELITE,     (E) TRIPPER,     FREESOFT,     FUZION,     I.C.S.,     INDIE HEAD,     KGB,      MAD VISION,     MICRO MANIAC,     MUG U.K.,     NEON LIGHTS (ESP. THE CAFFEINE KID),     PERSISTENCE OF VISION (ESP. MAC SYS DATA AND BORIS),     POMPEY PIRATES (R.I.P.),     POWA,     PURE ENERGY (ESP. FALCON AND ZAK),      PULSION,     RIPPED OFF (ESP. STICK AND BILBO),     SAFARI (ESP. PANTHER AND RHINO),     SCANZ,     SECTION ONE (ESP. RED LICHTIE),     SPECIAL FX (ESP. JAM),     SUPERIOR,     SUPREMACY (GET IN TOUCH!!).     SYNDICATE,     THE EDGE,     THE JOKER THE REPLICANTS,     TIM,     UNTOUCHABLES (ESP. MAT)   AND     X-STATIC (ESP. SIGNET).       THATS ABOUT IF FOR ADRENALIN 33   THE BIG MOTHER 33  THE VERY IMPORTANT 33   REMEMBER TO USE THE CONTACT ADDRESS   DONT JUST DREAM ABOUT IT      DO IT.       STAY SAFE   BE LUCKY            DIVINE OUT          WRAP                                             HARDFLOOR TECHNO 93                  "
Global Tlen=Len(scroll$)
Global Letter=0
Global Xmove.f=#xres
Global SWidth=128,SHeight=64
Global ScrollSpeed.f=16
CatchSprite(0,?font)

CatchSprite(1,?logo)
CreateSprite(2,#xres,SpriteHeight(1))
CopySprite(2,3):CopySprite(2,4)
Global Sx1,Sx2,Sx3

CatchSprite(6,?tba)			;-tba text
Global rwidth=68,rheight=36
CatchSprite(40,?raster)

Procedure MoveAdrenalin()
	
Protected i,ay,Clipy
xoff=24
For i=0 To 8
	ay=AdrMove(SPRITES(i)\index):	Clipy=(ay-276) 				;-the difference between the minumum and the current array value
	SPRITES(i)\index+1:If SPRITES(i)\index>MAX:SPRITES(i)\index=0:EndIf
	ClipSprite(40,0,Clipy,rwidth,rheight)					;-clip part of the raster
	DisplayTransparentSprite(40,xoff+rwidth*i,ay+#yoff-36)			;-show raster box
	DisplayTransparentSprite(60+i,xoff+rwidth*i,ay+#yoff-36)
	;-raster sprite is 160 high, max bounce y=402,min bounce =276,diff=126
	;- if ay=300 then the y clipping = (300-276) the difference between the minumum and the current array value
Next i
	
	
EndProcedure


Procedure Adrenalin()
	CatchSprite(60,?a)	;a
	CatchSprite(61,?d)	;d
	CatchSprite(62,?r)	;r
	CatchSprite(63,?e)	;e
	CatchSprite(64,?n)	;n
	CopySprite(60,65)	;a
	CatchSprite(66,?l)	;l
	CatchSprite(67,?i)	;i
	CopySprite(64,68)	;n
	
	For S=60 To 68:TransparentSpriteColor(S,#White):Next S
	
	
EndProcedure

Procedure DoStars()
	DisplayTransparentSprite(2,Sx1,#yoff):	DisplayTransparentSprite(2,-#xres+Sx1,#yoff)
	Sx1+2:If Sx1=>#xres:Sx1=0:EndIf
	
	DisplayTransparentSprite(3,Sx2,#yoff):	DisplayTransparentSprite(3,-#xres+Sx2,#yoff)
	Sx2+4:If Sx2=>#xres:Sx2=0:EndIf
	
	DisplayTransparentSprite(4,Sx3,#yoff):	DisplayTransparentSprite(4,-#xres+Sx3,#yoff)
	Sx3+8:If Sx3=>#xres:Sx3=0:EndIf
	
	EndProcedure

Procedure MakeStarfield()
	;-very simple starfield creation by drawing the 'stars' on 3 separate sprites and moving them at different speeds
	For S=2 To 4
		StartDrawing(SpriteOutput(S))
			Star=0
			Repeat
				sx=Random(#xres,1)
				sy=Random(SpriteHeight(1),1)
				Box(sx,sy,2,2,RGB(0,128,160))
				Star+1
			Until Star=48
		StopDrawing()
	Next S
	
EndProcedure

Procedure Scroller()
	;because of the nature of the ripped font not being in a standard format we have to adjust it here.  Feel free to fix it you want to!
	For L=0 To 6
		T$=Mid(scroll$,Letter+L,1)
		Tval=Asc(T$)-65
		Select Tval
			Case -19:Tval=41	;.
			Case 27:Tval=42		;\	
			Case -21:Tval=39	;,
			Case -2:Tval=43		;?
			Case -25:Tval=44	;(
			Case -24:Tval=45	;?
			Case -23:Tval=46	;*
				
			Case -17:Tval=27	;0
			Case -16:Tval=28	;1
			Case -15:Tval=29	;2
			Case -14:Tval=30	;3
			Case -13:Tval=31	;4
			Case -12:Tval=32	;5
			Case -11:Tval=33	;6
			Case -10:Tval=34	;7
			Case -9:Tval=35		;8
			Case -8:Tval=36		;9
	
		EndSelect

		If Tval<0:Tval=48:EndIf
		
		ClipSprite(0,(Tval*SWidth),0,SWidth,SHeight)
		DisplayTransparentSprite(0,Xmove+(L*SWidth),168+#yoff)
	Next L

	Xmove-ScrollSpeed
	If Xmove<=-(SWidth*2):Xmove=-SWidth:Letter+1:EndIf
	If Letter>Tlen:Letter=0:Xmove=#xres:EndIf
	
EndProcedure

MakeStarfield()
Adrenalin()

OSMEPlayMusic(?music,?musend-?music,1)	;x86 OSME replay library

Repeat
	If fs=0:event=WindowEvent():EndIf
	
	ClearScreen(0)
	
	DoStars()							;-cheater starfield
	DisplayTransparentSprite(1,320-(SpriteWidth(1)/2),#yoff)	;-main logo
	
	Scroller()							;-scrolltext
	MoveAdrenalin()							;-bouncing letter
	
	DisplayTransparentSprite(6,320-(SpriteWidth(6)/2),246+#yoff)	;-tba text
	
	
	FlipBuffers()
Until GetAsyncKeyState_(#VK_ESCAPE)
OSMEStopMusic()
End



DataSection
	music:	:IncludeBinary"sfx\Bellis_Boot.sndh"
	musend:

	font:	:IncludeBinary"gfx\scrollfont.bmp"
	logo:	:IncludeBinary"gfx\adrenalin.bmp"
	tba:	:IncludeBinary"gfx\tba.bmp"
	raster:	:IncludeBinary"gfx\raster.bmp"
	
	a:	:IncludeBinary"gfx\a.bmp"
	d:	:IncludeBinary"gfx\d.bmp"
	r:	:IncludeBinary"gfx\r.bmp"
	e:	:IncludeBinary"gfx\e.bmp"
	n:	:IncludeBinary"gfx\n.bmp"
	l:	:IncludeBinary"gfx\l.bmp"
	i:	:IncludeBinary"gfx\i.bmp"
	
	;-y position data for the ADRENALIN movement
	admove:
	Data.L     402, 402, 402, 402, 401, 401, 401, 400, 400, 399, 399, 398, 398, 397, 397, 396, 396, 395, 395, 394, 393, 393, 392, 391, 391, 390, 389, 388, 388, 387, 386, 385, 384, 383, 382, 381, 380, 379, 378, 377, 376, 375, 374, 373, 372, 371, 370, 369, 367, 366, 365, 364, 362, 361, 360, 358, 357, 356, 354, 353, 351, 350, 348, 347, 345, 344, 342, 341, 339, 338, 336, 334, 333, 331, 329, 327, 326, 324, 322, 320, 318, 317, 315, 313, 311, 309, 307, 305, 303, 301, 299, 297, 295, 293, 291, 288, 286, 284, 282, 280, 277, 276, 278, 280, 283, 285, 287, 289, 291, 293, 295, 298, 300, 302, 304, 306, 308, 309, 311, 313, 315, 317, 319, 321, 322, 324, 326, 328, 329, 331, 333, 335, 336, 338, 339, 341, 343, 344, 346, 347, 349, 350, 351, 353, 354, 356, 357, 358, 360, 361, 362, 364, 365, 366, 367, 368, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 385, 386, 387, 388, 389, 389, 390, 391, 391, 392, 393, 393, 394, 394, 395, 396, 396, 397, 397, 398, 398, 398, 399, 399, 400, 400, 400, 400, 401, 401, 401, 401, 402, 402, 402, 402, 402, 402, 402, 403, 403, 403, 403, 403, 403, 402, 402, 402, 402, 402, 402, 402, 401, 401, 401, 401, 400, 400, 400, 400, 399, 399, 398, 398, 398, 397, 397, 396, 396, 395, 394, 394, 393, 393, 392, 391, 391, 390, 389, 389, 388, 387, 386, 385, 385, 384, 383, 382, 381, 380, 379, 378, 377, 376, 375, 374, 373, 372, 371, 370, 368, 367, 366, 365, 364, 362, 361, 360, 358, 357, 356, 354, 353, 351, 350, 349, 347, 346, 344, 343, 341, 339, 338, 336, 335, 333, 331, 329, 328, 326, 324, 322, 321, 319, 317, 315, 313, 311, 309, 308, 306, 304, 302, 300, 298, 295, 293, 291, 289, 287, 285, 283, 280, 278, 276, 276, 278, 280, 283, 285, 287, 289, 291, 293, 295, 297, 300, 302, 304, 306, 307, 309, 311, 313, 315, 317, 319, 321, 322, 324, 326, 328, 329, 331, 333, 334, 336, 338, 339, 341, 342, 344, 346, 347, 349, 350, 351, 353, 354, 356, 357, 358, 360, 361, 362, 363, 365, 366, 367, 368, 369, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 384, 385, 386, 387, 388, 388, 389, 390, 391, 391, 392, 393, 393, 394, 394, 395, 396, 396, 397, 397, 397, 398, 398, 399, 399, 399, 400, 400, 400, 401, 401, 401, 401, 402, 402, 402, 402, 402, 402, 402, 402, 403, 403, 403, 403, 402, 402, 402, 402, 402, 402, 402, 402
admovend:
	
	
EndDataSection
