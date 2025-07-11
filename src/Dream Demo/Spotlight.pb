;The Dream Demo - Spotlight Screen

;Coder:		Marlon	
;Gfx:		Ackerlight, Knighthawks,Vision Factory,Krazy Rex
;Music:		Mad Max
;Year:		1989
;Remake:	KrazyK - 2019  


;This code is being made availble to all at DBF to mess with and improve and generally play around with.
;Feel free to use any bits of it wherever you want - but don't forget where it came from.  A credit is always nice ;-)

InitSprite()


IncludeFile "sound_sndh.pbi"		;sndh replay

title$="The Spotlight Demo - Win32 Remake - KrazyK 2019"
Global xres=800,yres=600
Global loffset=35	;used to position all graphics vertically central (looks neater, I hate to see uneven gaps in the top/bottom borders!)


OpenWindow(1,0,0,xres,yres,title$,#PB_Window_WindowCentered|#PB_Window_ScreenCentered|#PB_Window_BorderLess)
OpenWindowedScreen(WindowID(1),0,0,xres,yres)
StickyWindow(1,1)

SetFrameRate(60)
ShowCursor_(0)

;{ Scroller Stuff
Global speed.f=10		;sine speed
Global scrollspeed.f=8		;scroll speed
Global xmove=800		;start at edge of screen
Global scroll$="                THERE'S NOT A PROBLEM THAT WE CAN'T FIX, CAUSE WE CAN DO IT IN THE MIX! ;                            ; HI EVERYBODY OUT THERE! ;                            ; THE ST CONNEXION PRESENTS THE 'SPOTLIGHT DEMO'. ;                            ; (YES, AGAIN A DEMO-CONVERSION!)... ;                            ; THE ORIGINAL DEMO WAS CODED BY ACKERLIGHT (THE FRENCH LIGHT) ON THE AMIGA AT THE END OF 1988, BUT MARLON FELL IN LOVE WITH IT, SO HE DECIDED TO CONVERT IT TO THE ST. ;                            ; CREDITS COMING UP: ALL CODING BY MARLON, GRAPHICS BY ACKERLIGHT FOR THE MAIN LOGO, KNIGHTHAWKS FOR THE FONT (NEVER USED BEFORE!), VISION FACTORY FOR THE ONE BITPLANE FONT, AND, OF COURSE, KRAZY REX FOR ADDITIONAL GRAPHICS (YES THERE ARE SOME!). ;                            ; COOL MUSIC COMPOSED BY MAD MAX... ;                            ; AND NOW, LET ME TELL YOU THIS DEMO'S HISTORY, BECAUSE THERE HAS BEEN A LOT OF DIFFERENT VERSIONS OF IT, BEFORE THE FINAL VERSION WHICH YOU ARE STARING AT RIGHT NOW (NONE OF THOSE VERSIONS WERE RELEASED THOUGH). ;                            ; THE FIRST VERSION OF THE SPOTLIGHT DEMO DIDN'T LOOK LIKE THAT AT ALL: THE LOGO WAS MORE OR LESS THE SAME AS DEFENDER OF THE CROWN'S TITLEPIC (NICE ONE DONE BY KRONOS, BUT IT SIMPLY DIDN'T FIT THE DEMO), AND THE SCROLLER WAS UGLY (TOO BIG FONT)! THAT'S WHY WE DECIDED TO RIP THE ORIGINAL DEMO'S GRAPHICS, IN ORDER TO GIVE IT THE TOUCH OF CLASS THAT IT NEEDED... ;                            ; THE SECOND VERSION OF IT WAS EXACTLY LIKE THIS ONE, EXCEPT THE FACT THAT IT WAS NOT IN OVERSCAN! STILL, IT WAS QUITE NICE (DATE: SEPT. 1989). TIME PASSED, AND ONE DAY, I ASKED MARLON: 'WOT ABOUT DOING THE SCROLLER IN LEFT-RIGHT OVERSCAN?'. 'GRUMBLE, GRUMBLE' SAID MARLON, BUT HE DID IT, AND WE PROUDLY SHOWED THE 3RD VERSION OF IT AT THE REPLICANTS' COPY PARTY IN NOVEMBER 1989. ;                            ; EVERYBODY THOUGHT IT WAS PRETTY NICE (THAT'S AT LEAST WOT THEY SAID), BUT STEPRATE OF EQUINOX ASKED MARLON AFTER A FEW MINUTES, WITH A GRIN ON HIS FACE: 'WHY ARE THE STARS AND THE UPPER LOGO NOT IN OVERSCAN LIKE THE SCROLLER?'. YOU CAN IMAGINE MARLON'S REACTION TO SUCH A QUESTION (WHO ELSE BUT STEPRATE OF EQUINOX COULD HAVE ASKED IT???), SO I DON'T NEED TO SPELL IT OUT FOR YOU!   IN XMAS 1989, THE FOURTH VERSION OF THE SPOTLIGHT DEMO WAS READY, IN COMPLETE FULLSCREEN, WORKING ON ALL ST'S, EXCEPT THE ST-E'S (WE DIDN'T HAVE ANY WHICH WE COULD USE FOR TESTS!). ;                            ; THIS VERSION HAS BEEN FIXED FOR STE'S TOO AND SLIGHTLY IMPROVED: ALL THE TABLES THAT WERE DONE WITH THE GFA-BASIC, ARE NOW DONE IN ASSEMBLER, WE THUS SAVE DISKSPACE (THE PACKED VERSION OF THIS DEMO IS ONLY 30 KB LONG)... THAT'S ABOUT IT, THIS IS VERSION 5.0, AND THE LAST ONE!! ;                            ; AND NOW A SPECIAL MESSAGE TO ALL CODERS WHO PRETEND TO DO FULLSCREENS (OR OVERSCANS): TRY YOUR ROUTINES ON OLD ST'S TOO! WE ARE TIRED OF DEMOS THAT DO NOT WORK PROPERLY ON OUR ST'S (AND THERE ARE A LOT, INCLUDING VERY RECENT ONES...). OUR NEWEST FULLSCREEN ROUTINE (NOT THIS ONE: WE'RE NOT SURE OF IT, AS MARLON IS MESSING A BIT WITH THE MFP...) WORKS ON ANY ST FROM 1985 TO 1990, AND ONLY USES 80 BYTES...   NOW THERE'S NO EXCUSE LEFT FOR YOU... SPECIAL GREETINGS TO THE VERY FEW CREWS THAT MANAGE TO MAKE OVERSCANS THAT WORK PROPERLY ON MY FOUR-YEAR-OLD-SINGLE SIDED-BELOVED-520 ST: LEVEL 16, TCB (SOMETIMES, BUT NOT ALWAYS!), OVERLANDERS (SAME GOES TO YOU!!), THE GERMAN ALLIANCE AND ULM. OTHERS CAN GO AND GET LOST... ;                            ; MARLON HAS ALSO FOUND A WAY TO INCLUDE MAD MAX TUNES (OR ANYONE'S TUNE) IN THE NOP'S, WHICH MEANS THAT HE DOESN'T LOSE ANY LINES AT THE BOTTOM, BUT ALSO THAT WE ARE NOT SURE IF THIS DEMO WORKS ON ALL ST'S! ;                            ; WITH OUR NEW SOUNDTRACKER ROUTINE, WE COULD HAVE PLAYED THE ORIGINAL MUSIC OF THE DEMO TOO (ELECTRONIC RAMBLING BY PAT, FOR INTERESTED PEOPLE!), BUT THE DEMO WAS FINISHED BEFORE THE ROUTINE, AND MARLON DIDN'T WANT TO DO THE WHOLE THING AGAIN, SO TOUGH SHIT AS A WELL-KNOWN ENGLISH CREW WOULD SAYS! ANY COMPLAINTS CAN BE SENT TO THE ST CONNEXION, B.P. 36, 78860 SAINT NOM LA BRETECHE!! ;                            ; YOU MAY WONDER WHY THERE IS A DREAM DEMO LOGO ON THE SCREEN... WELL, THE ANSWER TO THAT QUESTION IS RATHER SIMPLE: THIS SCREEN IS ONE OF THE OLD GENERATION SCREENS, THAT WE RELEASE NOW, BEFORE IT'S TOO LATE! AS YOU PROBABLY HAVE GUESSED, THIS DEMO WAS SUPPOSED TO BE A PART OF THE DREAM DEMO. BUT ALAS, THE DREAM DEMO IS NOT FINISHED (IT HAS THE WORLD-RECORD OF THE MOST LATE DEMO: ABOUT 18 MONTHS!), WHEREAS THIS SCREEN IS READY SINCE DECEMBER 1989. THAT'S WHY WE DROPPED THE IDEA OF INCLUDING IT IN A DEMO THAT WON'T BE RELEASED BEFORE XX.XX.XXXX (FILL IN THE BLANKS!). YOU MAY THINK THAT THIS IS GETTING EMBARRASSING FOR US, AND YOU ARE PROBABLY RIGHT... BUT THE THING IS, THAT OUR 3 CODERS ARE NOW VERY BUSY WITH THEIR STUDIES: BELZEBUB HAS ENTERED SUP TELECOM IN BREST (FAR WEST!), MORDOR IS IN HIS THIRD YEAR OF MEDECINE, AND MARLON IS ABOUT TO FINISH SCHOOL. THEY HAVE THEREFORE VERY LITTLE TIME FOR DEMOCODING WHICH MEANS THAT I AM UNABLE TO GIVE YOU AN APPROXIMATE RELEASE DATE FOR THE DREAM DEMO. BESIDES, OUR NEW DEMOS ARE VERY TOUGH TO CODE, AS THEY INCLUDE MEGAFAST SOUNDTRACKER ROUTINES IN FULLSCREENS AMONG OTHER, AND THIS IS NOT THE KIND OF DEMO THAT YOU FINISH IN THREE HOURS (SUIVEZ MON REGARD)! SO BE PATIENT, YOU WON'T BE DISAPPOINTED, BELIEVE ME! ;                            ; AND NOW, NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP... POOR MARLON, HE IS NOW FED UP WITH THEM! ;                            ; LET'S TALK ABOUT SOMETHING ELSE NOW... ;                            ; WOT ABOUT ST AND AMIGA MUSIC?   OK... ;                            ; THERE ARE A LOT OF MUSIC COMPOSERS ON THE AMIGA, OF COURSE BECAUSE SOUNDTRACKER HAS BEEN USED BY A LOT OF PEOPLE SINCE ITS BIRTH, IN 1987. TO MY OPINION, TWO MUSIC COMPOSERS ARE REALLY LEADING: ROMEO KNIGHT OF RED SECTOR (HE HAS DONE THE CEBIT '90 DEMO'S SOUNDTRACK AMONG A LOT OTHERS), AND UNCLE TOM (A SWEDE, UNTIL RECENTLY A MEMBER OF SCOOPEX). THOSE TWO MUSIC FREAKS ARE THE AMIGA'S MAD MAX! THEY BOTH USE VERY SPECIAL AND NEW SOUNDS, AND MANAGE TO COMPOSE MINDBLASTING TUNES WITH THEM. I REALLY LOVE THEIR WORK! STARBUCK OF SPREADPOINT IS ALSO VERY GOOD (HE HAS FOR INSTANCE COMPOSED THE SPREADPOINT TUNE THAT WE PUT ON OUR SOUND DISK II, AND THE WOOOW DEMO'S SOUNDTRACK), AND SO ARE WALKMAN OF IT AND JESPER KYD OF THE SILENTS. BUT IN FACT, THERE ARE A LOT OF MUSICIANS ON THE AMIGA, BECAUSE MANY DIFFERENT EDITORS HAVE BEEN CODED AND SPREAD ON IT, PUBLIC DOMAIN OR NOT. SOUNDTRACKER IS OF COURSE THE MOST USED, BUT THERE ARE ALSO OTHERS, LIKE FUTURE COMPOSER FOR INSTANCE (BASED UPON MAD MAX'S AMIGA REPLAY ROUTINE, HAVE A LOOK AT THE TFMX DEMO). THEY HAVE ALL BEEN WELL SPREAD, THUS LETTING ANYONE START COMPOSING HIS OWN TUNES. THIS HAS NOT BEEN THE CASE ON THE ST, AS VERY FEW MUSIC EDITORS EXIST (NONE OF THEM BEING REALLY GOOD!). BUT THINGS ARE NOW CHANGING, AND I MUST ADMIT THAT I HOPE TO SEE SOME NEW TALENTS ON THE ST, USING ALL THOSE MUSIC EDITORS THAT KEEP COMING UP, AMONG OTHER THE HMS SOUNDTRACKER (BY ESAT SOFTWARE). AFTER ALL, WE MADE THE REPLAY ROUTINE FOR IT! ;                            ; OK, I THINK IT'S TIME TO LEAVE, GO READ SOME OTHER INTERESTING TEXTS, TO BE FOUND ANYWHERE ON THIS DISK... ;                            ; VANTAGE, THE MAD SCROLLTEXT WRITER WUZ HERE AGAIN........... ;                            ; ROLLLL.......                                                                                  "
Global scroll2$=scroll$	;make a copy`
Global tlen=Len(scroll$)
Global letter=1
Global speedcount=1		;whenever a ; is found we speed up/slow down tethe scroll text
Global angle.f			
Global sswaves.f=2		;sine waves
Global sineheight.f=36		;height of the wave
Global sinestep.f=20		;size of each slice


Enumeration 
	#fontimage
	#scrollbuf
	#tempimg
	#fontraster
	#frasterback
	#rastback
	#rastback2
	#reflection
	#connex
	#biglogo
	#rasterimage
	#circ
	#logobuffer
	#tempsprite
EndEnumeration

CreateImage(#logobuffer,800,220)		;draw logo and circle on here 
CatchImage(#fontimage,?font)			;ripped font
CreateImage(#scrollbuf,800,32)			;draw scrolltext on here
CatchSprite(#rasterimage,?raster)		;ripped rater
CatchSprite(#reflection,?reflect)		;reflection part
CatchImage(#fontraster,?fraster)		;font raster

CreateImage(#frasterback,800,128)		;draw raster on here
StartDrawing(ImageOutput(#frasterback))
For y=0 To 128 Step 32
		DrawImage(ImageID(#fontraster),0,y,800,32)
Next y
StopDrawing()
CreateImage(#rastback,800,32*4)
;}

;{ Logos Stuff

CatchSprite(#biglogo,?logo)
CatchImage(#connex,?stconn)
Global xlogo=(800/2)-(SpriteWidth(#biglogo)/2)	;x centre position
Global index=53
Global shift=0
Global tm=ElapsedMilliseconds()-4000	;start the timer but add 4 seconds onto it so that the logo starts pouring immediately

Structure Pour
	posy.f			;inital starting position of each horizontal slice
	ymax.f			;final destination of each elice
EndStructure

Global Dim pour.pour(54)	;create the array

For y=53 To 0 Step -1
	pour(y)\posy=Y		;set the initial y position of each horizontal slice of the logo
	pour(y)\ymax=Y+54	;set the final y position of each horizontal slice of the logo
Next y

Global Dim PreShift(54)		;preshifted logo sprite array
Global pourdown=1		;start the demo with the logo pouring down first
;}

;{ VU Bar Stuff

Enumeration 
	#vu0
	#vu1
	#vu2
	
EndEnumeration

CatchSprite(#vu0,?vublue)
CatchSprite(#vu1,?vuwhite)
CatchSprite(#vu2,?vured)

Global vol.f=32/15	;per volume size
;}




Procedure MakeSpotlight()
	
	;In this routine we draw the big logo on the back buffer then the spotlight on top.  
	;The spotlight will appear grey, RGB(56,56,56), on the black background
	;So we need to then draw the mask over the left and right edges of the logo so it is the same colour as the spotlight.
	;We then grab the logo with the spotlight as a sprite and add it to our array and set the transparency colour to RGB(56,56,56)

	
	CreateSprite(#circ,184,184)				;sprite for the spotlight
	StartDrawing(SpriteOutput(#circ))
		Circle(184/2,184/2,184/2,#White)		;white spotlight that will show as RGB(56,56,56) on the black background
	StopDrawing()
	
	Global spotmax=308					;number of preshifted frames
	Global Dim PreshiftSpot(spotmax+1)			;our sprite capture array for later
	Global spots=0						;initialize
	Global cx.f=308						;initial starting circle x position
	Global cy.f=124						;initial starting circle y position
	
	Global xspeed=4,yspeed=2				;spotlight speeds
	
	CatchSprite(2000,?mask)					;RGB(56,56,56) mask either side of the logo
	CreateSprite(1000,800,220)				;blank sprite to use to clear the screen
	CatchSprite(1001,?inttext)				;intro text to show whilst calculating the spotlight preshifts
	ClearScreen(0)
	FlipBuffers()
	
	Repeat
		w=WindowEvent()								;just so windows doesn't freak out and crash!
		DisplaySprite(1000,0,108)						;blank out the central part of the screen temporarily
		DisplayTransparentSprite(#biglogo,0,108)				;draw the big logo on screen
		DisplayTransparentSprite(#circ,cx.f,cy,56)				;draw the spot on top of the logo.  The white circle show on the black baground with a colour of RGB(56,56,56) so we must remove it
		DisplayTransparentSprite(2000,0,108,255,RGB(56,56,56))			;mask around both ends of the logo to the same colour as the spotlight.
		PreshiftSpot(spots)=GrabSprite(#PB_Any,110,108,574,219)			;grab the central part with logo and spotlight on it
		TransparentSpriteColor(PreShiftspot(spots),RGB(56,56,56))		;set transparency 

		;SaveSprite(PreshiftSpot(10),"gfx\preshift\spot"+Str(spots)+".bmp")	;save (for testing only)	
		
		cx+xspeed			;move the spot left/right
		cy+yspeed			;move the spot up/down
		
		If cx>=(xres-184); And cx>oldx	;have we moved to the right of the boundary of the screen?
			xspeed=-xspeed		;make the x movement minus
		EndIf
		
		If cx<=0			;are we at the left edge?
			xspeed=Abs(xspeed)	;make the x movement to positive
		EndIf
		
		If cy>=184			;reached the lower y boundary?
			yspeed=-yspeed		;set y speed to minus
		EndIf
		
		If cy<=60			;reached the upper y boundary?
			yspeed=Abs(yspeed)	;set y speed back to positive
		EndIf
		
		spots+1				;next sprite
		ClipSprite(1001,0,0,800,238)	
		DisplaySprite(1001,0,108)	;intro text
	Until spots=spotmax 
	ClipSprite(1001,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
	ClearScreen(0)
	DisplaySprite(1001,0,108)		;bash space!
	FlipBuffers()
	Repeat	:w=WindowEvent():Until GetAsyncKeyState_(#VK_SPACE)
	
	spotmax=spots
	spots=0
	FreeSprite(1000)	;black
	FreeSprite(1001)	;intro text
	FreeSprite(2000)	;mask	
EndProcedure

Procedure MoveSpotLight()
	
	DisplayTransparentSprite(PreshiftSpot(spots),110,108+offset)
	spots+1
	If spots=spotmax:spots=0:EndIf
	
	
EndProcedure

Procedure VUBars()
	
	;get each channel volume
	ch0=osme_getchannelvu(0)
	ch1=osme_getchannelvu(1)
	ch2=osme_getchannelvu(2)
	
	;calculate the width based on volume
	ch0_size.f=ch0*vol.f	 
	ch1_size.f=ch1*vol.f 
	ch2_size.f=ch2*vol.f 
	
	;resize the bar and draw it central
	ZoomSprite(#vu0,800,ch0_size)
	DisplayTransparentSprite(#vu0,0,16 - (ch0_size/2)+offset)	
	
	ZoomSprite(#vu1,800,ch1_size)
	DisplayTransparentSprite(#vu1,0,16+32 - (ch1_size/2)+offset)
	
	ZoomSprite(#vu2,800,ch2_size)
	DisplayTransparentSprite(#vu2,0,16+64 - (ch2_size/2)+offset)
	
	
EndProcedure

Procedure BendIt()
GLET=0
GX=0
angle.f +speed.f
hdc=StartDrawing(ImageOutput(#rastback))
Box(0,0,800,128,#Black)		;blank it

Repeat
	NewYpos=SineHeight*Sin(Radian(angle+(GLET*speed.f)))
	GrabImage(#frasterback,#tempimg,(GLET*SineStep),NewYpos+sineheight,SineStep,32)		;grab a piece of the pink raster
	KK_DrawTransparentImage(hdc,#tempimg,(GLET*SineStep),NewYpos+sineheight,#White)		;draw it in the new potiotion
	GrabImage(#scrollbuf,#tempimg,(GLET*SineStep),0,SineStep,32)				;grab a piece of the scrolltext
	KK_DrawTransparentImage(hdc,#tempimg,(GLET*SineStep),NewYpos+sineheight,#White)		;draw it on top of the pink raster
	GLET+1
	GX+SineStep
	FreeImage(#tempimg)
Until GX=>xres

StopDrawing()

	DisplayTransparentSprite(#rasterimage,0,340+offset)					;raster
	CopyImage(#rastback,#rastback2):ResizeImage(#rastback2,800,96)				;copy the raster
	
	Width  = ImageWidth(#rastback2) 
	Height = ImageHeight(#rastback2) 
	hdc = StartDrawing(ImageOutput(#rastback2)) 
		StretchBlt_(hdc,0,Height,Width,-Height-1,hdc,0,0,Width,Height, #SRCCOPY) 	;flip it upside down 
	StopDrawing()	
	
	hdc=StartDrawing(ScreenOutput())
		KK_DrawTransparentImage(hdc,#rastback,0,340+offset,0)				;top scrolltext
		KK_DrawTransparentImage(hdc,#rastback2,0,340+90+offset,0)			;reflected scrolltext
	StopDrawing()
	
	DisplayTransparentSprite(#reflection,0,340+102+offset,220)				;reflection on top to fade the bottom scroller a bit

EndProcedure

Procedure Scroller()
	
	For T=1 To 27					;enough characters to fill the screen
		t$=Mid(scroll$,letter+T,1)
		If t$=";"				;speed change
			speedcount+1
			ReplaceString(scroll$,";"," ",#PB_String_InPlace,letter+T-1,1)	;replace the speed character with a blank
			If Bool(speedcount%2 = 0)	;is even
				scrollspeed=16

			EndIf
			If Bool(speedcount%2 <> 0)	;is odd
				scrollspeed=8
				speed=10
			EndIf
		EndIf
		ypos=Asc(t$)-32				;return the ascii value of the character and use it a y position*32 for the strip font
		StartDrawing(ImageOutput(#scrollbuf))
			GrabImage(#fontimage,#tempimg,0,ypos*32,32,32)	
			DrawImage(ImageID(#tempimg),xmove+(32*T),0)
		StopDrawing()
	Next T
	xmove-scrollspeed:If xmove=-64:xmove=-32:letter+1:EndIf
	If letter>=tlen:letter=1:speedcount=1: xmove=800:scroll$=scroll2$ :EndIf
	
	BendIt()
	
EndProcedure

Procedure PreShiftLogo()
	
	;Preshift our ST Connexion logo for future use 
;{	;pouring down routine (finally worked it out!!)
	;bottom 2 pixels are clipped then zoomed to the height of the original sprite
	;it is then displayed moving down to the new position which is the height of the sprite below the current position
	;next 2 pixels up are then moved and repeated
				
	Pour(index)\posy+1				;move each line down 1 pixel every time we come back here
	shift+1						;frame count
	If Pour(index)\posy>=pour(index)\ymax		;maximum moving height reached?
		pour(index)\posy=pour(index)\ymax	;set it to max
	EndIf
	StartDrawing(ImageOutput(#connex))							;draw directly on the original image
		GrabDrawingImage(#tempimg,0,index,768,2)					;clip 2 pixels from the bottom and work upward
		DrawImage(ImageID(#tempimg),0,pour(index)\posy,768,54);pour(index)\size)	;draw and resize
	StopDrawing()
	index-1											;keep going up from pixel 53
;} End out rout
	
preshift(shift)=CreateSprite(#PB_Any,768,108)	;create a memory sprite
StartDrawing(SpriteOutput(PreShift(shift)))	;start drawing on it
	DrawImage(ImageID(#connex),0,0)		;draw the shifted image
StopDrawing()
;SaveSprite(PreShift(shift),"gfx\preshift\pre"+Str(shift)+".bmp")	;save it (for testing only)
	
EndProcedure

Procedure PourConnexion()
	
	If ElapsedMilliseconds()-tm>5000 And pourdown=1	;more then 5 seconds passed and flag set to pour down?
		shift+1					;next sprite in the preshifted array
		If shift>53				;maximum reached?
			shift=53			;set to last sprite
			tm=ElapsedMilliseconds()	;restart the timer
			pourdown=0			;reset the pourdown flag
		EndIf
	EndIf
	
	
	If ElapsedMilliseconds()-tm>5000 And pourdown=0	;more than 5 seconds passed and flag set to pour back up?
		shift-1					;previous sprite in the preshifted array
		If shift=0				;first sprite?
			shift=1				;set back to the start
			tm=ElapsedMilliseconds()	;restart the timer
			pourdown=1			;set the poudown flag
		EndIf
	EndIf
	
	DisplayTransparentSprite(PreShift(shift),0,0+offset)		;draw our preshifted ST Connexion logo
	
	
EndProcedure

Procedure MakeStars()
	
	;create 66 stars in 3 different fields, give them a random x,y position
	
	Global starmax=60
	Structure StarField
		sx.f
		sy.f
		sspeed.f
	EndStructure
	
	Global Dim Starfield.StarField(66)
	
With StarField(X)
	For X=0 To 19
		\sx=Random(xres-1)
		\sy=Random(340+offset,offset)
		\sspeed=2
	Next x	
	For X=20 To 39
		\sx=Random(xres-1)
		\sy=Random(340+offset,offset)
		\sspeed=4
	Next x	
	For X=40 To 59
		\sx=Random(xres-1)
		\sy=Random(340+offset,offset)
		\sspeed=6
	Next x	
EndWith
EndProcedure

Procedure Stars()
	StartDrawing(ScreenOutput())
	With StarField(X)
		For X=0 To 60-1
			Box( \sx,\sy,2,2,#White)			;Box ignores screen boundaries unlike Plot
			\sx+\sspeed					;move the stars to the right 	
			If \sx>xres					;edge of screen ?
				\sx=0					;start back at 0 again
				\sy=Random(340+offset,offset)		;new random y position
			EndIf
		Next x
	EndWith
	StopDrawing()
	
EndProcedure

Repeat	
	PreShiftLogo()	;preshift the ST Connexion logo into our sprite array
Until shift=53
shift=1	;reset the counter


MakeStars()
MakeSpotlight()

osmeplay(?music,?musend-?music,1)


Repeat
	w=WindowEvent()
	ClearScreen(0)
	
	VUBars()
	Stars()
	
	PourConnexion()
	
	MoveSpotLight()
	
	Scroller()
	
	
	FlipBuffers()
	
	
Until GetAsyncKeyState_(#VK_ESCAPE)

osmestop()

End




DataSection
	mask:		:IncludeBinary "gfx\mask.bmp"
	inttext:	:IncludeBinary "gfx\int.bmp"
	fraster:	:IncludeBinary "gfx\fontraster.bmp"
	reflect:	:IncludeBinary "gfx\reflection.bmp"
	font:		:IncludeBinary "gfx\fontstrip.bmp"
	vured:		:IncludeBinary "gfx\redbar.bmp"
	vublue:		:IncludeBinary "gfx\bluebar.bmp"
	vuwhite:	:IncludeBinary "gfx\whitebar.bmp"
	raster:		:IncludeBinary "gfx\raster.bmp"
	logo:		:IncludeBinary "gfx\logo2.bmp"
	stconn:		:IncludeBinary "gfx\stconnextion.bmp"
	music:		:IncludeBinary "sfx\marlon3.sndh"
	musend:
	
	
EndDataSection

