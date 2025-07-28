;Awesome CD 7 
;Code & Graphics:	Ruthless & Magnum
;Music:			Lap
;Year:			1991
;Remake:		KrazyK 2015

;Purebasic 5.62 Source (x86)


DataSection
	allfont:
	IncludeBinary"gfx\allfont.bmp"		;my ripped font. This too a long time to put together!
	awe:
	IncludeBinary"gfx\awesomegold.bmp"	;cool gold logo !
	copper:
	IncludeBinary"gfx\copper.bmp"		;copper strip, cheating slightly ! :-)
	typefont:
	IncludeBinary"gfx\font2.bmp"		;text typing font
	music:
	IncludeBinary"sfx\lap_33.sndh":musend:	;ripped LAP music
	ydata:
	IncludeBinary"ydata.bin":ydataend:	;ripped sine table for logo bounce
	
	
EndDataSection


fs=0
#xres=640
#yres=480
#offset=0

InitSprite()

fs=0	;-windowed=0, fullscreen=1

If fs=0
	OpenWindow(0,0,0,#xres,#yres,"",#PB_Window_ScreenCentered|#PB_Window_WindowCentered|#PB_Window_BorderLess)
	OpenWindowedScreen(WindowID(0),0,0,#xres,#yres)
	StickyWindow(0,1)       ;-keep window on top
	ShowCursor_(0)          ;-hide the mouse
ElseIf fs=1
	OpenScreen(#xres,#yres,32,"")
Else
End
EndIf


;-==================== Scroller variables ==============================
Global Scroll$=Space(10)
Scroll$+"HELLO AND WELCOME TO ANOTHER SELECTION OF BRAND NEW GAMES...    THIS TIME RUTHLESS BRINGS YOU COMPACT MENU NUMBER SEVEN.      THE RELEASE DATE OF THIS MENU IS SATURDAY THE THIRD OF AUGUST AND YOU SHOULD HOPEFULLY RECIEVE THIS MENU ALONG WITH AWESOME MENUS EIGHT AND NINE......     GAME ONE WAS CRACKED FILED AND PACKED BY CAMEO OF THE REPLICANTS  THE DOCS WERE SUPPLIED BY THE SCORPION AND WRECKERS WAS CRACKED FILED AND PACKED BY ZELDA.....     I AM PLEASED TO SEE THAT THE SOFTWARE SCENE IS PICKING UP AGAIN, WHICH MEANS MORE MENUS AND LESS TIME IN BETWEEN MENUS....     CREDITS FOR THIS MENU GOTO......  CODING BY RUTHLESS AND MAGNUM..... AND MUSIC BY LAP.....      WHAT DO YOU THINK OF THIS GREAT FONT....   IT IS NICE TO LOOK AT BUT THERE ARE NO PUNCTUATION MARKS OR NUMBERS.....    ANYWAY I WILL DO THE GREETINGS AND LET YOU GET ON WITH PLAYING ONE OF THE GREAT GAMES...      AWESOME GREETS GOTO.... THE REST OF AWESOME WHO ARE.... ZELDA.... THE SCORPION.... ....THE EDITMAN.... ....PHOENIX.... ....DEMON X....   OTHER GREETS GOTO    ...THE SYNDICATE ESP. ONIXUS... ...THE MEDWAY BOYS ESP. GINO AND ZIPPY... ...THE POMPEY PIRATES ESP. GENIE AND THE ALIEN... ...THE SOURCE ESP. FROSTY AND KALAMAZOO... ...INNER CIRCLE ESP. GRIFF AND MASTER... ...MUG UK... ...NOW FIVE ESP. STORMLORD AND FALCON... ...THE RADICAL BANDITS ESP. THE RUDE DUDE AND DEREK MD... ...THE REPLICANTS ESP. CAMEO... ...MAD VISION ESP. THE HIGHLANDER... ...ELECTRONIC... ...THUNDERFORCE ESP. MATRIX AND VORTEX... ...THE QUARTET ESP. BLOODANGEL AND NICK... ...FOFT ESP. THE AVENGER... ...BENNY... ...SPECIAL FX ESP. JAM... ...THE BBC ESP. ANDY... ...IMPACT ESP. TOXIC... ...NEW POWER GENERATION... ...EVIL FORCE ESP. JASON ELITE... ...FUZION ESP. DOCNO... ...TSB... BAD BOYS IN BELGUIM ESP. PETER... ...ALAN B... ...THE ELITE... CLOCKWORK ORANGE ESP. QUATRO.......   NORMAL GREETINGS GOTO   ...AUTOMATION ESP. MOB AND TBE... ...X-RATED ESP. PEDRO AND MYSTIC... THE UNTOUCHABLES ESP. MATT... ...LOTUS... ...GENESIS INC ESP. REMEREZ AND LAWZ... ...EGOTRIPPERS ESP. KEGGS... ...MAGNUM... ...TIMEWARP ESP. DR BAD VIBES... ...TITANIC TARZAN ON ICELAND... ...IENX ESP. IVO... ...RAEGUN... ...TERMINATORS ESP. VAMPIRE... ...CARL... ...PRESIDENT... ...MARK ANTHONY... ...TATTOO... ...SUPERIOR... ...NEXT... ...ULM... AND THE OVERLANDERS...   OK I AM OFF NOW TO DO ANOTHER MENU       SO UNTIL AWESOME MENU EIGHT I WILL LEAVE YOU TO READ MY BORING DRIVEL AGAIN AND AGAIN AND AGAIN AND AGAIN AND AGAIN.....   ...LETS WRAP...    BYEEEEEEEEEE                 "
Global TLen=Len(Scroll$)
Global Xmove=#xres
Global Letter=0
Global TVal
#FontWidth=128
#FontHeight=128
#ScrollSpeed=16
CreateSprite(1,640,128)		;draw font images on this sprite then display it on screen
CopySprite(1,3)			;make a copy to copy back !
CatchImage(1,?allfont)		;our ripped 128x128 font strip
CreateImage(100,128,128)	;space
;-======================================================================


Declare FlipSprite(SNUM)

Global MenuText$=""
MenuText$+	"COMPACT MENU #7     "
MenuText$+	"                    "
MenuText$+	"1. F-15 STRIKE      "
MenuText$+	"   EAGLE II         "
MenuText$+	"2. F-15 STRIKE      "
MenuText$+	"   EAGLE II DOCS    "

;CLEAR THE SCREEN
MenuText$+	"                    "
MenuText$+	"                    "
MenuText$+	"                    "
MenuText$+	"                    "
MenuText$+	"                    "
MenuText$+	"                    "

MenuText$+	"3. WRECKERS         "
MenuText$+	"0. 50/60 HERTZ      "
MenuText$+	"                    "
MenuText$+	"                    "
MenuText$+	"NOW LOOK BELOW AND  "
MenuText$+	"READ THE SCROLLER..."

;CLEAR THE SCREEN
MenuText$+	"                    "
MenuText$+	"                    "
MenuText$+	"                    "
MenuText$+	"                    "
MenuText$+	"                    "
MenuText$+	"                    "



Global tm=ElapsedMilliseconds()

Global Awesome=CatchSprite(#PB_Any,?awe)						;Gold Awesome logo sprite
Global AwesomeFlipped=CopySprite(Awesome,#PB_Any):FlipSprite(AwesomeFlipped)		;Gold Awesome logo sprite flipped
Global AwesomeYPos.f=0
Global DataPos=1206-450
Global Counter=0

;disable backface culling for flipping sprites
Define d3d.IDirect3DDevice9
EnableASM
!extrn _PB_Screen_Direct3DDevice
!MOV dword EAX, [_PB_Screen_Direct3DDevice]
!MOV dword [v_d3d],EAX
DisableASM
#D3DRS_CULLMODE=22
#D3DCULL_CCW=1
;disable culling
d3d\SetRenderState(#D3DRS_CULLMODE,#D3DCULL_CCW)


Procedure FlipSprite(SNUM)
   SW= SpriteWidth(SNUM)  
   SH= SpriteHeight(SNUM)
; 1) 0,0 - 2) SW,0 - 3) SW,SH - 4) 0,SH   
; flipped  1 2 3 4 to 4 3 2 1
   TransformSprite(SNUM,0,SH,SW,SH,SW,0,0,0)
EndProcedure

Procedure MirrorSprite(SNUM)
   SW= SpriteWidth(SNUM)  
   SH= SpriteHeight(SNUM)
; 1) 0,0 - 2) SW,0 - 3) SW,SH - 4) 0,SH   
; mirrored 1 2 3 4 to 2 1 4 3
   TransformSprite(SNUM,SW,0,0,0,0,SH,SW,SH)
EndProcedure

Procedure MakeCopper()					;fake copper colours for ST !
	CatchImage(1000,?copper)			;copper strip
	ResizeImage(1000,640,(32*6)+20)			;6 rows of menu text + gaps
	CreateImage(1001,640,(32*6)+20)			;blank image for drawing the copper effect on
	
	CreateSprite(1001,640,(32*6)+20)		;also create a sprite to draw onto to show
	TransparentSpriteColor(1001,#White)
	CopySprite(1001,1002)				;make a copy
	
	CreateSprite(2000,640,(32*6)+20)
	TransparentSpriteColor(2000,#White)
	CopySprite(2000,2001)
	
	CatchImage(2000,?typefont)			;our ripped text typing font
	
	Global CopperY=0
	Global TypeX=0
	Global TypeY=0
	Global TypeLines=1				;6=max
	Global TypeLetter=1				;20-max
	Global TypeScreens=1				;5=max
EndProcedure

Procedure DrawCopperOnImage()				;draw on copper image buffer 1001, the type text buffer image.  Draw it on sprite 1001
	
	StartDrawing(SpriteOutput(1001))
		DrawImage(ImageID(1000),0,CopperY)
		DrawImage(ImageID(1000),0,CopperY+((32*6)+20))
	StopDrawing()
	CopperY-2
	If CopperY=<-((32*6)+20):CopperY=0:EndIf	;move the copper screen up the image until it is reaches it's minumum position
	DisplaySprite(1001,0,0)
	
EndProcedure

Procedure MakeBorders()
	ClearScreen(RGB(0,0,160))					;blue
	Global BlueBorder=GrabSprite(#PB_Any,0,0,640,160)	;
EndProcedure

Procedure Scroller()
	DisplaySprite(BlueBorder,0,362)			;display blue border
	DisplayTransparentSprite(AwesomeFlipped,0,850-AwesomeYPos);display the gold awesome flipped logo
	StartDrawing(SpriteOutput(1))			;draw on the scroll sprite
		For L=1 To 7 				;7 letters
		TVal=Asc(Mid(Scroll$,Letter+L))		;calculate hte correct character number
		Select TVal
			Case 65 To 90			;A to Z
				TVal-65			
			Default 			;every other letter = space
				TVal=100
		EndSelect
		GrabImage(1,2,TVal*128,0,128,128)	;grab our font character as an image from the ripped font strip
		DrawImage(ImageID(2),Xmove+(L*#FontWidth),0)
	Next L
	StopDrawing()

DisplayTransparentSprite(1,0,222)	;display the sprite scroll
CopySprite(1,2)				;make a copy of it to flip
FlipSprite(2)
DisplayTransparentSprite(2,0,373)	;display it lower down
DisplaySprite(BlueBorder,0,470)		;display blue border at bottom of screen like the original


Xmove-#ScrollSpeed:If Xmove=-(#FontWidth*2):Xmove=-#FontWidth:Letter+1:EndIf
If Letter=TLen:Letter=0:Xmove=#xres:EndIf
	
	
EndProcedure

Procedure AwesomeBounce()
	AwesomeYPos=PeekW(?ydata+DataPos)*1.5
	DisplayTransparentSprite(Awesome,0,AwesomeYPos-225)
	DataPos-4
	If DataPos<=0:DataPos=1206-450:	EndIf
EndProcedure

Procedure TypeText()					;draw the copper effect of a buffer, then draw the type text on another buffer and display it on the copper buffer
	
DrawCopperOnImage()					;draw the copper effect on the copper image buffer 1001

If ElapsedMilliseconds()-tm>60				;only draw every other frame
	
StartDrawing(SpriteOutput(2000))			;text typing sprite buffer
	TypeletterVal=Asc(Mid(MenuText$,TypeLetter))-32	;calculate the ascii value of out menu text letter
	GrabImage(2000,3000,32*TypeletterVal,0,32,32)	;grab the correct font image from the strip
	If IsImage(3000)
		DrawImage(ImageID(3000),TypeX,TypeY,32,32)	;ok to draw it on our sprite buffer
	EndIf
StopDrawing()
	TypeLetter+1
	TypeX+32
	If TypeX=640
		TypeX=0
		TypeY+32+4
		TypeLines+1
	EndIf
	
	If TypeLines=7
		TypeLines=1
		TypeScreens+1
		TypeY=0
		TypeX=0
	EndIf
	
	If TypeScreens=5
		TypeX=0
		TypeY=0
		TypeLines=1
		TypeScreens=1
		TypeLetter=1
		CopySprite(2001,2000)
	EndIf

	tm=ElapsedMilliseconds()
EndIf
	
DisplayTransparentSprite(2000,0,0)
	
EndProcedure



MakeBorders()
MakeCopper()

OSMEPlayMusic(?music,?musend-?music,1)

Repeat
	If fs=0:event=WindowEvent():EndIf	
	
	ClearScreen(0)
	TypeText()				;behind Awesome logo
	AwesomeBounce()				;behind scroll text
	Scroller()				;128 x 128 scroll text
	
	FlipBuffers()
Until GetAsyncKeyState_(#VK_ESCAPE)
OSMEStopMusic()
End