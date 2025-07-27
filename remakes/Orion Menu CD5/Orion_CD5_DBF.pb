;Orion Menu CD 5

;Code:	Spiff/Spike
;Gfx:	Spike/Tantal
;Music:	Mad Max
;Remake:KrazyK - October 2021


#xres=800
#yres=600
InitSprite()
InitKeyboard()

OpenWindow(0,0,0,#xres,#yres,"Orion CD 5 - Win32 Remake -by KrazyK",#PB_Window_ScreenCentered|#PB_Window_BorderLess)
OpenWindowedScreen(WindowID(0),0,0,#xres,#yres)
StickyWindow(0,1)		;window on top
ShowCursor_(0)			;hide the mouse

;{ Gfx and scroller setup
Global scrollfont=CatchSprite(#PB_Any,?font128)
Global typefont=CatchImage(#PB_Any,?font32)
Global spider=CatchSprite(#PB_Any,?logo)
Global blueras=CatchSprite(#PB_Any,?blueraster):ZoomSprite(blueras,#xres,SpriteHeight(blueras))
Global vu=CatchSprite(#PB_Any,?redraster)

Global xoffset=80,yoffset=40		;maintain some screen accuracy

Global scroll$="           HI YOU OUT THERE!!      THIS IS ORION!      WE'RE BACK WITH MENU 5!      I (SPIKE) RELEASED IT ONE DAY BEFORE THE   MEGA FUN II!           IF YOU WANT TO KNOW WHAT'S ON THIS DISK YOU HAVE TO READ THE UPPER SCROLLER!!!!     THERE IS A NEW MEMBER IN OUR CREW!!   TANTAL     HE'S A GRAPHIX MAN!    THE SPIDER ON THIS MENU IS HIS FIRST PRODUCT!!     VERY GREAT ART WORK!    SO I GO ON WITH THE OTHER CREDITS     CODE BY SPIFF      SPIDER BY TANTAL       BIG FONT, LOGO, COMPILING,..... BY SPIKE           SOME GREETINGS ( IN REALLY REALLY REALLY NO SPECIAL ORDER!!!) HI TO ALL MEMBERS OF ORION     TEDDY (GREAT ANTI-VIRUS!   I LOOK FORWARDFOR A GREAT SWISS-MEGA-DEMO SCREEN!!!)      SPIFF   (SEE US AT 					MEGA FUN II)TANTAL OF TALUSA    (WHAT ABOUT A NEW BIG FONT?)       BURN CREW     (MORGAN   SEND MORE GREAT SOUNDS!)      THE DEBUG BOYS   (HEY HOKI  GIVE ME A CALL!!)        RUBBY W.   (MONEY OR DIE!!)        ANIMAL MINE (PENGUIN    SEE YA AT MEGAFUN II, SNAIL   WHEN CAN I GET THE FREEZER???)                THE WILD BOYS    (HI POWERMAN!)              THE UNTOUCHABLES (GREAT DISK MAG!!   I LOOK FORWARD FOR MORE GREAT UNT-PRODUCTS!)             REDZONE OF THE REANIMATORS (GREAT GRAFIX)       FUZION            RIPPED OFF          THE CONCEPTORS   (DEMON    YOU'LL GET THE GRAPHIX SOON!        TGE,       TBC    (ESP. FIX)  TDA          T.O.P.         (GREAT DEMOS!),          TSB   (ZINE, JUDGE DREED)          LAZER (HEY DO YOU STILL EXIST, WHY DON'T YOU ANSWER MY LETTER???)       EMPEROR    (HEY ICE-T DON'T TOUCH MY SISTER)          THE LORDS         HARRY OF THE MCA          THE POMPEY PIRATES         RED EAGLE            THE PUNISHER (RUK)........I DIDN'T GET THE GREETINGS FROM SPIFF ........THEN THERE IS NOTHING MORE TO TELL YOU!   LET'S WRAP!                                              "
Global speed=16,tlen=Len(scroll$),xmove=800,letter=1		;scroller variables
#fontsize=128							;big font width and height
Global alpha$=" !ABCDEFGHIJKLMNOPQRSTUVWXYZ')(-,? "		;my ripped font format

Global	spr_height=SpriteHeight(vu)		;vu bar height
Global	spr_width=SpriteWidth(vu)		;vu bar width
Global	vuheight.f=spr_height/15		;clip height per volume
Global 	vusize.f

;}

;{ Typer setup 
Global ypos,yline=-8,yinc=4							;typer variables
Global count,tcount=1,counter,frame,dofade=#False
Global typeback=CreateSprite(#PB_Any,640,256)					;do the typing font on here
Global alpha2$=" !'#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ"	;my ripped font format

Global Dim type.s(100)
Restore typer
count=0
Repeat
	Read.s r$		;read the text into the array
	type.s(count)=r$	
	count+1
Until r$=Chr($ff)			;end char
Global typeframe=ElapsedMilliseconds()	;start the timer
Global fps.f=1000/60			;how many ms per frame
;}

Procedure vubars()
	;The vu bars expand equally up and down from the middle of the blue raster
	
	DisplayTransparentSprite(blueras,0,448+offset)	;draw the blue raster first
	
	;read the channel volumes
	v0=OSMEGetVU(0)
	v1=OSMEGetVU(1)
	v2=OSMEGetVU(2)
	
	;calculate the height of the bar based on the volume and draw the clipped bar in the correct position
	
	vusize=(v0*vuheight)					
	ClipSprite(vu,0,(spr_height/2)-(vusize/2),spr_width,vusize)
	DisplayTransparentSprite(vu,xoffset,456 +(spr_height/2) -(vusize/2))
	
	vusize=(v1*vuheight)
	ClipSprite(vu,0,(spr_height/2)-(vusize/2),spr_width,vusize)
	DisplayTransparentSprite(vu,xoffset+224,456 +(spr_height/2) -(vusize/2))

	vusize=(v2*vuheight)
	ClipSprite(vu,0,(spr_height/2)-(vusize/2),spr_width,vusize)
	DisplayTransparentSprite(vu,xoffset+448,456 +(spr_height/2) -(vusize/2))
	

EndProcedure

Procedure scroller()
For l=1 To (#xres/128)+2
	c$=Mid(scroll$,l+letter,1)					;get the next letter in the scrolltext
	xgrab=FindString(alpha$,c$) * #fontsize-128			;calculate the position in our alphabet where the letter is
	ClipSprite(scrollfont,xgrab,0,#fontsize,#fontsize)		;grab the letter
	DisplayTransparentSprite(scrollfont,xmove+(l*#fontsize),448)	;draw it
Next l
xmove-speed:If xmove=-#fontsize*2:xmove=-#fontsize:letter+1:EndIf	;move left and
If letter>tlen:letter=1:xmove=#xres:EndIf				;reset to start
EndProcedure

Procedure fader()
		
	StartDrawing(SpriteOutput(typeback))			;draw on the typer back sprite
		If yline>256					;beyond?
			yline=-8				;reset back to bottom for next fade
			dofade=#False				;reset the flag
		EndIf
		Box(0,yline+yinc,640,4,#Black)			;draw the black box to remove the text
		yline+yinc					;move up 2px
	StopDrawing()
	DisplayTransparentSprite(typeback,xoffset,yoffset+70)	;draw the typer back sprite
	
EndProcedure

Procedure typer()
	
If dofade=#True:fader():ProcedureReturn :EndIf	
	
t$=type.s(counter)						;next line
typelen=Len(t$)							;character length of the line
DisplayTransparentSprite(typeback,xoffset,yoffset+70)		;show the current typing sreen sprite

If typeframe>0 And ElapsedMilliseconds()-typeframe<fps*5	;draw every 5th frame
	ProcedureReturn 					;drop out
EndIf

	StartDrawing(SpriteOutput(typeback))			;draw on the back sprite
		tnext$=Mid(t$,tcount,1)				;next letter
		If tnext$=Chr($ff)				;end of whole text
			counter=0:tcount=1:count=1:ypos=0:dofade=#False	;reset all variables
			StopDrawing()
			ProcedureReturn 			;drop out of the routine
		EndIf
		
		If tnext$="@"					;end of screeen character found?
			dofade=#True:tcount=1:ypos=0:counter+1:StopDrawing():ProcedureReturn	;reset variables
		EndIf
		
		txgrab=(FindString(alpha2$,tnext$)*32) - 32		;calculate the position of the letter in the font
		If txgrab<0:txgrab=0:EndIf				;no negative values!
		tmping=GrabImage(typefont,#PB_Any,txgrab,0,31,36)	;grab the letter
		DrawImage(ImageID(tmping),tcount*31,ypos)		;draw it in the correct position
		tcount+1						;next letter on the line
		FreeImage(tmping)					;free the temp image
		typeframe=ElapsedMilliseconds()				;restart the timer for the next frame
	StopDrawing()
	
	If tcount>typelen+1						;end of line?
		ypos+32							;move down by 32px
		tcount=1						;start of line
		counter+1						;next text from the array
	EndIf

EndProcedure

OSMEPLay(?music,?musend-?music,1)		;play the chiptune

Repeat
	w=WindowEvent()
	
	DisplayTransparentSprite(spider,(#xres/2)-(SpriteWidth(spider)/2),0)	;x centred main logo
	
	vubars()	
	
	scroller()
	
	typer()
	
	FlipBuffers()
	ClearScreen(0)
	
	ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape)
OSMEStop()

End


DataSection
	
	font128: : IncludeBinary "gfx\font128.bmp"
	font32: : IncludeBinary "gfx\bluefont.bmp"
	logo: :IncludeBinary "gfx\spider.bmp"
	blueraster: :IncludeBinary "gfx\blueraster.bmp"
	redraster: :IncludeBinary "gfx\redvu.bmp"
	music: :IncludeBinary "sfx\menu5.sndh"
	musend:
	
	
typer:
Data.s	"PRESS"
Data.s	"1. FOR"
Data.s	""
Data.s	"PABLO AND THE GOLD"
Data.s	"OF MONTEZUMA"
Data.s	"          "
Data.s	"@"

Data.s	"PRESS"
Data.s	"2. FOR"
Data.s	" "
Data.s	"PABLO AND THE GOLD"
Data.s	"OF M. EDITOR"
Data.s	"          "
Data.s	"@"


Data.s	"PRESS"
Data.s	"3. FOR"
Data.s	" "
Data.s	"TITANIC BLINKY"
Data.s	"          "
Data.s	"@"

Data.s	"PRESS"
Data.s	"4. FOR"
Data.s	" "
Data.s	"EASY RIDER 4.0"
Data.s	"(REASSEMBLER)"
Data.s	"          "
Data.s	"@"

Data.s	"PRESS"
Data.s	"5. FOR"
Data.s	""
Data.s	"EXORCIST II"
Data.s	" "
Data.s	"(ANTI-VIRUS OF TSB)"
Data.s	"          "
Data.s	"@"

Data.s	"PRESS"
Data.s	"6. FOR"
Data.s	" "
Data.s	"ORION ANTI-VIRUS"
Data.s	"          "
Data.s	"@"

Data.s	"IF YOU WANT TO "
Data.s	"CONTACT US,    "
Data.s	"THEN WRITE TO "
Data.s	"          "
Data.s	"          "
Data.s	"@"

Data.s	"SPIKE OF ORION"
Data.s	" "
Data.s	"P.O.BOX 332"
Data.s	" "
Data.s	"CH-8134 ADLISWIL"
Data.s	" "
Data.s	"SWITZERLAND   "
Data.s	"          "
Data.s	"@"

Data.s	"OR TO"
Data.s	"@"

Data.s	"SPIFF OF ORION"
Data.s	" "
Data.s	"P.O.BOX 73"   
Data.s	""
Data.s	"CH-6370 STANS"
Data.s	" "
Data.s	"SWITZERLAND"
Data.s	"          "
Data.s	"@"
Data.s	Chr($ff)		;end of text character
	
EndDataSection
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 86
; Folding = I-
; EnableXP
; UseIcon = Atari logo mask.ico
; Executable = Orion_Cd5.exe
; DisableDebugger
; IncludeVersionInfo
; VersionField0 = 1
; VersionField1 = 1
; VersionField2 = KrazyK
; VersionField3 = Orion Menu CD 5 - Win32 Remake
; VersionField4 = 1
; VersionField5 = 1
; VersionField6 = Orion Menu CD 5 - Win32 Remake
; VersionField7 = Orion Menu CD 5 - Win32 Remake
; VersionField8 = Orion_CD5.exe
; VersionField9 = KrazyK
; VersionField10 = KrazyK