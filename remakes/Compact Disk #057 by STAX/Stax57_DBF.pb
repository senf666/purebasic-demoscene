;Stax Menu 57
;Code:		Matt
;Gfx:		Matt
;Music:		Sally
;Released:	April 1994

;Remake:	
;KrazyK November 2021


InitSprite()
OpenWindow(0,0,0,640,480,"Stax 57",#PB_Window_ScreenCentered|#PB_Window_BorderLess)
OpenWindowedScreen(WindowID(0),0,0,640,480)

Global offset=40		;vertical offset to keep the ST perspective screen positions

Global sinelen=?sinend-?sinedat	;length of the sine data

;{ -- Create the raster background ------
CreateImage(1,640,400)
StartDrawing(ImageOutput(1))
DrawingMode(#PB_2DDrawing_Gradient)
	BackColor(RGB(96,128,224))
	GradientColor(0.0001,RGB(96,128,224))
	GradientColor(0.2,RGB(0,224,32))
	GradientColor(0.3,RGB(0,0,192))
	GradientColor(0.4,RGB(0,128,224))
	GradientColor(0.5,RGB(198,224,224))
	GradientColor(0.6,RGB(224,224,32))
	GradientColor(0.7,RGB(224,0,0))
	GradientColor(0.8,RGB(64,0,0))
	GradientColor(0.9,RGB(224,0,224))
	GradientColor(0.99999,RGB(96,128,224))
	LinearGradient(320,0,320,400)
	Box(0,0,640,400)
StopDrawing()
;}

;{ Image setup and vars --
CatchImage(30,?logo)				;stax logo
CreateImage(31,ImageWidth(30),ImageHeight(30))	;scroll rasterback on the stax logo
Global ylogo					;stax logo raster var

Global yblinds=440				;y position start
CatchImage(100,?blinds)				;cheap blinds effect cheat!
CreateSprite(100,640,30)			;draw the blinds on here first

CatchImage(60,?fontcol):ResizeImage(60,640,30)	;bottom scroller colours
CatchImage(61,?lowerfont)			;lower font
CreateImage(62,640,30)				;font strip to draw on
Global fontback=CreateImage(#PB_Any,640,13*30)	;draw all the sine scrollers on here first!
CatchImage(10,?sinefont)			;main sine moved font
CreateImage(50,640*2,32)			;scroll strip to draw on first
CreateImage(2,640,448)				;scroll raster back on here
Global ymove=0					;raster move var



;}

;{ VU setup and vars

CatchSprite(50,?vubar)		;sprite
Global vuh=SpriteHeight(50)	;height
Global vuw=SpriteWidth(50)	;width
Global vol.f=vuh/15		;vertical height per volume
;}

;{ Scrollers setup and vars ---
;main multi sine scroller
Global sinecounter=0		;sine data start
Global sinex=640		;edge of screen
Global sinescroll$=UCase("                THIS IS COMPACT DISK FIFTY SEVEN BROUGHT TO YOU BY MATT OF STAX .......       HIT FOLLOWING PADS...     KEY ONE...  TCB FLASHBACK DEMO     KEY TWO... SPACEBALLS DEMO...    KEY THREE... NO COOPER DEMO     KEY FOUR... FLYING BRAINS SCREEN     KEY FIVE... MONA LISA DEMO     KEY SIX... BONUS SCREEN                                           ")
Global sineletter=1		;start here!
Global scrollen=Len(sinescroll$);scroll length
Global sinealpha$="ABCDEFGHIJKLMNOPQRSTUVWXYZ'',.:/!? "	;my ripped font format


;lower scroller
Global lowerscroll$=UCase("                          WOW !!!   LOOK AT THIS... YOU WILL GET A REAL FLASH IN YOUR EYES WHEN LOOKING TO CAREFULLY !!!   MATT WHO REALLY LIKES BIZARRE COLOR STRUCTURES PROUDLY PRESENTS COMPACT DISK 57 !!!  YO ALL BORING ZOOM-EXPERTS: THIS IS AN OLD-STYLED INTRO (THATS WHY WE USE THIS OLD-STYLED CHARACTERS) BUT IT FITS EXCELLENT ONTO THIS DISK !!!   THE FAST AND SWINGING BACKGROUNG SCROLLERS WILL GUIDE YOU THROUGH THIS MENU, HOPE YOU CAN READ IT ALL WITHOUT ANY PROBLEMS !!!  IF YOU GET BLIND AFTER HAVING READ THIS SCROLLTEXT THEN DO NOT COME TO ME AND SAY YOU HAVEN'T BEEN WARNED....   THIS BORING SHOCKER-INTRO WAS WRITTEN BY MATT THE MAD...  THE SOUND IS ALSO RIPPED BY MATT BUT I AM SORRY I DON'T KNOW WHO HAS COMPOSED THIS VERY NICE TUNE...   LONG TIME SINCE YOU HAVE HEARD A TUNE WITHOUT HALF-DIGI-DRUMS AND SID-EFFECT, EH !!!  BUT STAX ALWAYS BRINGS YOU REFRESHING INTROS... WAH !!!  I AM JUST KIDDIN' OF COURSE...           ARE YOU STILL READING THIS ???   WELL, THEN TAKE NOTE WE ARE ACTUALLY AGAIN DOING A NEW MEGA-DEMO, THIS TIME I CAN TELL YOU ITS GETTING REALLY VERY BIG...  YOU WON'T BE ABLE TO COMPARE IT WITH OUT PARTY-DEMO OR THE FANTASIA DENTRO (WHICH IS STILL NOT OUT BECAUSE NOBODY WANTS TO PUT IT TOGETHER !!!) BECAUSE IT REALLY GETS EXCEPTIONAL....     I MEAN EXCEPTIONAL AS A STAX-DEMO, NOT EXCEPTIONAL AS AN ORDINARY DEMO.....   PLEASE IF YOU GET NEW SOFTWARE (GAMES,DEMOS,TOOLS,UTILITIES ETC.) FOR THE ATARI ST/STE THEN CONTACT ME !!!  YOU CAN WRITE EITHER TO ME, TO ANY OTHER STAX MEMBER OR TO EVERY (GERMAN) CONTACT FROM ME TO GET INTO THE BUSINESS !!!    I WARMLY REMEMBER SOME YEARS AGO WHEN I DID NOT FIND THE TIME TO DO ANYTHING ELSE EXCEPT DUPLICATING NEW STUFF !!!  DAY BY DAY I RECEIVED NEW GAMES, MY POST-BOX NEARLY ALWAYS WAS GOOD FILLED AND I HAD HUGE PROBLEMS IN BUYING ENOUGH DISKS FOR ALL THE STUFF !!!  TODAY ITS BORING...  ONLY SOMETIMES I RECEIVE NEW SOFTWARE, IN FORMER TIMES I EXCHANGED LETTERS WITH ALMOST 10 DISKS OR SO BUT TODAY ITS NORMAL JUST TO SWAP 1 OR 2 DISKS EACH TIME...    PUH... WELL, THAT'S LIFE !!! UNFORTUNATELY COMPUTERS AREN'T EVERYTHING IN LIFE SO I WANNA SEND A BIG KISS TO MY LOVELY GIRLFRIEND  --- TINA ---  WHO REALLY LIKES LISTENING TO HOUSE OF PAIN...        QUITE OKEY, I CANNOT SAY ANYTHING AGAINST THIS GROUP !!!         OKEY, HERE YOU HAVE A LITTLE TIP....  PLEASE TAKE CARE, I WON'T REPEAT IT... IF YOU ARE SHORT BEFORE BLINDED BY THIS CRAPPY COLOR-DISASTER JUST ESCAPE YOURSELF BY PRESSING THE SAME !!!   GOT IT ???  I AM REALLY A SILLY WRITER, EH !?!?!  I HOPE YOU UNDERSTOOD THIS HINT ANYWAY !!!    MAYBE YOU SEE SOME RASTERS FLACKERING BUT THATS BECAUSE YOU ARE ALREADY NEARLY BLIND !!!  ITS NOT A PROGRAM-ERROR !!!   WOW, WHAT A JOKE !!!      SALLY ACTUALLY HAS RETURNED INTO THE SCENE... AT LEAST HE TOLD ME SO !!!   WELL, TO MAKE IT CLEAR... HE HAS NOT THE TIME TO KEEP UP HIS CONTACTS, IN FACT I AM ACTUALLY HIS ONLIEST CONTACT (I THINK SO) BUT ANYWAY HE IS NOT DEAD AT ALL !!! HE WANTS TO CONTINUE DOING SOME STUFF (SOUNDS,CODE ETC.) BUT DUE TO HIS UNIVERSITY-ACTIVITIES HE HAS NEARLY NO TIME NOW")
lowerscroll$+UCase(".... THATS THE WHOLE ANSWER To ALL THOSE QUESTIONS ABOUT HIM !!!   SALLY TOLD ME HE WAS REALLY SURPRISED THAT SO MANY PEOPLE ASKED ABOUT HIM, HE HAD NOT EXPECTED THAT ANYBODY WOULD CARE IF HE IS Not THERE ANYMORE !!!    I RECEIVED SOME NICE NEW SOUNDS FROM HIM WHICH ARE As USUAL QUITE NICE BUT ANYWAY THIS TIME A BIT DIFFERENT To HIS FORMER ONES, SO LOOK OUT For Next INTROS WHERE I MAY USE THEM !!!      STAX IS:     MATT (CODER,FRONT-MAN,ORGANIZER,FOUNDER)     MIKE (CODER,ARTIST,LOADSA INSPIRATION And MORAL SUPPORT)     BOD (CODER)     TYAN (MUSICIAN, NO SWAPPER ANYMORE... ALL HIS CONTACTS MIGHT HAVE RECOGNIZED THAT ALREADY !!!)     SALLY (MUSICIAN,CODER)     TARZAN BOY (MUSICIAN,CODER)     DUX (FOUNDER)     EXTERMINATOR (ARTIST)                  WANNA Read A FEW GREETINGS ???   HA HA HA, I GUESS YOU WANT BUT TODAY I AM Not SO SHORT (As NORMALY).... YOU HAVE To Read A BIT FURTHER BUT NOW I HAVE NO TIME SO LETS QUIT A While Until ANOTHER DAY WHEN MY MIND IS REFRESHED OF WRITING BULLSHIT !!!  ITS ACTUALLY APRIL, THE 8TH IN 1994 And THE TIME IS VERY EARLY, EXACTLY: 01.08 A.M. .......  WOAH !!!!  I NEED To GO INTO MY LITTLE BED...  TOMORROW IS WEEKEND, YEAH... I HAVE To BE FIT THEN !!!    GOOD NIGHT THEN........                                                                          BACK I AM........    ITS NOW APRIL THE 29TH IN 1994...  I AM ACTUALLY NEARLY READY With MY EXAMS... EXCELLENT FEELING As I BELIEVE IT WAS Not TOO BAD AT ALL.... EXCEPT GERMAN PERHAPS WHERE I WAS Not ABSOLUTELY CLEVER AT ALL !!!   THIS MOTHERFUCKING STATE SEEMS To BRING ME LOADSA PROBLEMS With MY CIVIL JOB WHICH I AM GOING To START IN JULY JUST AFTER MY HOLIDAYS (IN SPAIN As USUAL).....   I FOUND SUCH A NICE POSITION IN A WORK STATION VERY NEAR MY HOME BUT NOW THE STATE SEEMS To PUNISH ME BECAUSE UP TODAY THEY HAVE Not GIVEN THEIR PERMISSION THAT I REALLY CAN BEGIN With THIS JOB !!!         HOWEVER, I AM HOPING THIS WILL End POSITIVE !!!                      DO YOU KNOW THAT WE ARE ACTUALLY AGAIN DOING YET ANOTHER NEW DEMO For THE ATARI ST ???  YES, YOU HEARD RIGHT... For THE ATARI ST (And STE OF COURSE) !!!  Not For THE FALCON....    WE ARE STILL ACTIVE (VERY ACTIVE To TELL THE TRUTH) ON THE ST And STE SO WE DECIDED To PRODUCE ONE LAST BIG DEMO....  THIS TIME ITS GETTING REALLY VERY BIG I CAN PROMISE YOU...   BUT THEREFORE IT WILL TAKE QUITE A LONG TIME Until ITS READY BUT WE HOPE If THIS TIME HAS COME THERE ARE STILL SOME FREAKS LEFT ON THE ST And STE EXCEPT US !!!   THAT DEMO WILL GET BETTER THAN ALL OUR PREVIEWS PRODUCTIONS TOGETHER !!!  YOU WILL SEE IN IT BOTH OLD And NEW EFFECTS, JUST VERY MUCH OF EVERYTHING !!!   MAYBE ALSO ONE (Or MORE ?) GAME WILL BE INCLUDED BUT ACTUALLY THIS GAME SEEMS To BE ONLY For STE MACHINES !!!     HOWEVER, I WON'T TALK TOO MUCH ABOUT IT IN THIS LOUSY SCREEN SO JUST KEEP OPEN YOUR EYES, ESPECIALLY IN ABOUT ONE YEAR WHEN IT MIGHT BE READY (OR AT LEAST NEARLY HALF READY !!!)      HA, HA ,HA....    NEARLY ALL MEMBERS WHO ARE WORKING ON THIS DEMO NOW WILL SOON BE ON UNIVERSITIES OR IN THEIR JOBS SO THIS ")
lowerscroll$+UCase("IS A TERRIBLE EFFECT WHICH SURELY LETS THE PRODUCTION SLOW DOWN A LOT.... BUT As LONG As ITS FUN WE WILL Continue IT !!!      THATS ABOUT THIS...  BELIEVE IT OR NOT !?!?!    DO YOU REALLY BELIEVE WE ARE DOING A NEW DEMO For THE ST ???     HO,HO,HO....  BELIEVER !!!     STAX IS A RELIGION...  WE ARE IMMORTAL !!!    BELIEVE IN US And YOU WON'T DIE, TOO....   BUT THE QUESTION IS:  IS IT WORTH To LIVE ForEver ON THIS BEATIFUL (!) PLANET !????  I HOPE THEY ARE FINDING SOME OIL IN EX-YUGOSLAVIA SOON SO THAT UNCLE SAM WILL TRY To MAKE PEACE SERIOUSLY !!!       IN OUR TODAYS NEWSPAPER WAS AN ARTICLE WHERE SOME IDIOTS WANTS To MAKE A NEW LAW WHICH LET EVERYBODY WHO WANTS To WALK IN THE FOREST PAY MONEY For THIS !!! YES, YOU HEARD RIGHT....  SOME PEOPLE REALLY WANTS To TURN THE FOREST INTO A COMERCIAL AREA !!!  IS THIS INCREDIBLE Or WHAT ??? GERMANY IS GETTING BETTER And BETTER... DAY BY DAY !!!   I AM WONDERING THAT I CAN TYPE THIS SCROLLTEXT WITHOUT HAVING TO PAY SOME BILLS For IT !?!?!?     I AM GETTING MAD IN THESE TIME !!!     FUCK YOU EVERBODY !!!               I HOPE YOU ALL SEE A LITTLE HOPE IN STAX COMPACT DISKS IN THIS DAYS... If YOU DON'T LIKE THEM YOU CAN DELETE THEM !!!  And YOU HAVE Not To PAY ONE COIN For IT... WE ARE ONE OF THE LAST DEMOCRACIES ON THIS PLANET !!!       BEST WISHES To FOLLOWING PEOPLE:                   ADMIRABLES (NIRVANA And STURM), AMBASSADORS (DIGITALBRAIN), ANIMAL MINE (DOMM , MC , PENGUIN , SETHOS , SHADOWMASTER, TITAN And ZAXX), AURA (BDC), BIZONIA, BLUE SOFTWARE, BREAKPOINT SOFTWARE (JON), CHANNEL 5, CHANNEL 38 (STALLION), CHARON, CRAZY GANG (ROBERT), CROSSBONES (THE FOX), CYCLONES (MR.COKE), DARREN LOMAX, DBA (BONUS And TRONIC), DETONATORS (BEWEISE , H-CL And NOFX), DIAMOND DESIGN (DRAX), DNT (FLIPS), DULL (XTC ONE), ETERNITY (DARKMIND), FAA, FREESTYLE CREW (SMILEY), GELLY SOFT INC. (ROB), HEMOROIDS (JURI-17), INTER (QUESTOR), KRUZ (GOZER), LAZER (PHOTON , ST NINJA , THE ENERGIZER And STAX), LENSH MOB (DOC), MIK/AL BLANKO, MR.COOL, NEW TREND (MR.BOND And LIG LURY), NEWLINE (TIN And JURI), NPG (APOLLO , CARNERRA , LONE STARR And JARON), PAULO SIMOES, PERCY, PERSISTENCE OF VISION (MAC SYS Data), PSYCHONOMIX (CORPSE GRINDER), REDLITE (DAN), REPLICANTS (LITTLE GUY), RISK (DANNY.O , SEPP JO And MC FLY), SENTRY (ISO And XLR8), STF (FLAYER), STRANGER (FREDDY), SYNERGY (WINGLEADER), SYNDICATE (SLAYER), TDD (INTEGER), TESLA UNIT (LEAD BALOON And SUNSHINE), T'PAU, THE MANIAC, THE TEUTONICK KNIGHTS, TNB (DRIZZT), TNS (HAWK), TRINITY, TRSI, TSN (DIGIT), TTG (DOMINATOR) And VECTRONIX (HI THERE ! GOT MY INTRO ???) !!!                         WOW! QUITE A LOT REGARDS...  MANY OF THE MENTIONED PEOPLE MAY Not BE IN CONTACT With US ACTUALLY ANYMORE.... THATS BECAUSE TYAN WHO WAS OUR MAIN SWAPPER IN THE LAST TIME (Or AT LEAST HE WAS SUPPOSED To BE IT !!!) HAS STOPPED MOST OF HIS CORRESPONDENCE !!!   SO ALL GUYS WHO ARE OUT ACTUALLY CAN EASILY GET IN TOUCH With OTHER STAX MEMBERS To KEEP THE CONTACT !!!  WE WOULD BE VERY PLEASED ABOUT THIS As ITS A PITY TYAN GIVES UP SO MANY CONTACTS !!!   If YOU ")
lowerscroll$+UCase("WANT TO RECEIVE ALL OUR LATEST (Or PREVIOUR) MENUES SO SIMPLY GET IN TOUCH, TOO !!!  JUST SEND ENOUGH STUMPS And DISKS And I WILL PASS YOU THE MENUES !!!  If YOU FILL YOUR DISKS With SOME NEWS YOU HAVE OF COURSE Not To SUPPORT THE STUMPS !!!     GOT IT ???  FAIR OFFER I THINK !!!  PLEASE GERMAN FREAKS OUT THERE CONTACT US !!!  THE SCENE SUCKS SO THE LAST PEOPLE ALIVE ON THE ST MUST BE STANDING TOGETHER !!!         HEY CARNERA OF NPG !!!    ITS OKEY THAT YOU HAVE NOW A FALCON 030 And THAT YOU PUT ALL YOUR ENERGY IN THIS MACHINE BUT IS THIS ALSO A GOOD REASON To STOP A FRIENDSHIP ???   I DON'T KNOW WHY BUT SINCE OUR LAST MEETING I HAVEN'T HEARD FROM YOU EVEN I WROTE SEVERAL LETTERS To YOU !!!   IT SEEMS I WAS WRONG ALL THE YEARS BEFORE BELIEVING YOU ARE SOMETHING LIKE A FRIEND And Not AN ORDINARY COMPUTER CONTACT ONLY !!!    OKEY, FORGET IT... THAT MAY BE THE SCENE IN THESE DAYS...  EVERYBODY WITHOUT A FALCON SEEMS To BE OUT And IS Not WORTH To DELIVER ANY RESPECT...   I HOPE THIS DOES Not GO ON LIKE THIS.......      I TELL YOU SOMETHING: ALL THE FAMOUS CONTACTS SOMETIMES GET TOO CRAZY...  THEY ARE GOING MAD And FORGET WHERE THEY COME FROM !!!   SO I THINK THE BEST CONTACTS (And FRIENDS ?) ARE UNKNOWN PEOPLE As THEY HAVE NO REASON To BECOME TERRIBLE !!!      ....... OKEY, PLEASE WAIT A While BECAUSE ITS  PLAY OFF TIME  !!!   I  H A V E  To LOOK THOSE AMERICAN BASKETBALL COZ I WANT To GET MOTIVATION For MY SOON COMING BASKETBALL EXAMS !!!      DUNK...DUNK....DUNK................................     HMMM... OKEY, BETTER Not !?!?    ITS TIME To End NOW... I AM FED UP ....   UUAHHH !!!    ENJOY THIS MENUE Or LET IT BE !!!  BUT DO Not PUNISH ME For DOING IT As I AM Not DOING IT For YOU BUT For MY PERSONAL BUSINESS !!!     LOOK OUT For OUR Next COMING MENUS... WE HAVE ALREADY READY SOME VERY NICE INTROS (ALSO ONE SPECIALLY For THE STE) BUT STUFF IS RARE CURRENTLY...  BUT WE ARE COMING BACK SOON !!!    MAYBE EVEN With OUR LITTLE DENTRO MAINLY CODED BY MIKE (FANTASIA)....       THATS IT, I HAVE NO MORE TOPICS SO LETS WRAAAAAAZZZZZZZZZZ..................          ")
Global xmove=-64	;scroller start position
Global letter=1

;}

;----------------- Procedures ------------------
Procedure vubars()
	
	v0=OSMEGetVu(0)*vol.f			;read each channel volume
	v1=OSMEGetVu(1)*vol.f
	v2=OSMEGetVu(2)*vol.f
	
	If v0=0:v0=4:EndIf			;need a small bar even when there is silence as per original
	If v1=0:v1=4:EndIf
	If v2=0:v2=4:EndIf
	
	ClipSprite(50,0,vuh-v0,vuw,v0)			;clip the vu sprite at the correct height
	DisplayTransparentSprite(50,480,4+vuh-v0+offset)	;draw it in the correct place
		
	ClipSprite(50,0,vuh-v1,vuw,v1)
	DisplayTransparentSprite(50,544,4+vuh-v1+offset)
	
	ClipSprite(50,0,vuh-v2,vuw,v2)
	DisplayTransparentSprite(50,608,4+vuh-v2+offset)
	
EndProcedure

Procedure scrolllogo()
	hdc=StartDrawing(ImageOutput(31))
		DrawImage(ImageID(1),0,ylogo-480)		;raster
		DrawImage(ImageID(1),0,ylogo)			;raster
		KK_DrawTransparentImage(hdc,30,0,0,#White)	;draw the stax logo with white as transparent
	StopDrawing()
	ylogo+4							;move the raster down
	If ylogo=>480:ylogo=0:EndIf	
	
	hdc=StartDrawing(ScreenOutput())
		KK_DrawTransparentImage(hdc,31,32,72+offset,#Black)	;now draw the logo with the raster behind it with black as transparent directly to the screen
	StopDrawing()
EndProcedure

Procedure scrollback()
	StartDrawing(ImageOutput(2))
		DrawImage(ImageID(1),0,ymove)		;raster
		DrawImage(ImageID(1),0,ymove+480)	;raster
	StopDrawing()
	ymove-4						;move it up
	If ymove=-480:ymove=0:EndIf	
	
EndProcedure

Procedure blinds()
	StartDrawing(SpriteOutput(100))
		Box(0,0,640,30,0)			;black it out
		GrabImage(100,101,0,yblinds,10,30)	;grab a section of the blinds
		DrawImage(ImageID(101),0,0,640,30)	;draw it on the image back
	StopDrawing()
	FreeImage(101)
	yblinds+2					;move it up
	If yblinds>=564:yblinds=0:EndIf			;end?,reset
	
	
	For y=0 To 12
		DisplayTransparentSprite(100,0,offset+y*30)
	Next y
	
	
EndProcedure

Procedure bottomscroll()
;this fucked up somehow and I had to fix it .
;not happy but it might have somethinmg to do with the width of the font image!
;couldn't be bothered to mess with it anymore and it works!	
	
	hdc=StartDrawing(ImageOutput(62))
	DrawImage(ImageID(60),0,0)		;font raster colour
	For i=1 To 12
		tval=Asc(Mid(lowerscroll$,letter+i,1))-33	;usually 32!!
		ch.s=Mid(lowerscroll$,letter+i,1)
		If ch.s="!":tval=1:EndIf	;fix odd characters!
		If ch.s=".":tval=14:EndIf
		If ch.s=",":tval=12:EndIf
		If ch.s="(":tval=8:EndIf
		If ch.s=")":tval=9:EndIf
		x = (tval % 10)*64	;calc the position to grab the char from
		y = (tval - (tval%10))/10*30
		GrabImage(61,63,x,y,64,30)				;grab
		KK_DrawTransparentImage(hdc,63,xmove+(i*64),0,#White)	;draw it with white as transparent
	Next i
	StopDrawing()
	
	xmove-8:If xmove=-128:xmove=-64:letter+1:EndIf		;move left
	If letter=Len(lowerscroll$):letter=0:xmove=-64:EndIf	;end?,reset
	
	hdc=StartDrawing(ScreenOutput())
		KK_DrawTransparentImage(hdc,62,0,480-48-30,#Black)
	StopDrawing()
	
	
	
EndProcedure

Procedure sinescroll()
	
	scrollback()							;move the raster back image up
	
	hdc=StartDrawing(ImageOutput(50))
	Box(0,0,640*2,32,0)						;black our scroll strip image out
	For l=1 To 34							;lots of character off screen
		tchr.s=Mid(sinescroll$,l+sineletter,1)			;read a scroll character
		tval=FindString(sinealpha$,tchr.s,#PB_String_NoCase)-1	;find it
		GrabImage(10,11,tval*32,0,32,30)			;grab it
		KK_DrawTransparentImage(hdc,11,sinex+(l*32),0,#Black)	;draw it
		FreeImage(11)						;bin it!
	Next l
	StopDrawing()
	
	sinex-4:If sinex=-64:sinex=-32:sineletter+1:EndIf		;move it left
	If sineletter=scrollen:sineletter=1:sinex=640:EndIf		;end of scroller?, then reset
	
	hdc=StartDrawing(ImageOutput(fontback))
		DrawImage(ImageID(2),0,0)						;raster moved back image
		For y=0 To 13
			xpos.w=EndianW(PeekW(?sinedat+sinecounter +(y*4)))*2		;next sine data offset 
			KK_DrawTransparentImage(hdc,50,xpos-(184*2),y*30,#White)	;draw it with white as transparent
		Next y
	StopDrawing()
	
	hdc=StartDrawing(ScreenOutput())
		KK_DrawTransparentImage(hdc,fontback,0,40,#Black)	;now draw all the rastered scrollers with black as transparent on top of the blinds effect
	StopDrawing()		
	sinecounter+2							;next sine position						
	If sinecounter>=sinelen/2:sinecounter=0:EndIf			;end of data?, then reset
	
EndProcedure

;------------------------------------------

OSMEPlay(?music,?musend-Music,1)		;new OSME library that I have modified to automatically calculate the length of the music

Repeat	
	ClearScreen(0)		;black
	
	event=WindowEvent()	;read but ignore window events
	
	blinds()		;blinds effect at the back
	
	sinescroll()		;13 rastered sine scrollers
	
	scrolllogo()		;rastered logo
	
	bottomscroll()		;coloured lower scroller
	
	vubars()		;vu music sync bars
	
	FlipBuffers()

	
Until GetAsyncKeyState_(#VK_ESCAPE)	;quit!

OSMEStop()				;stop da muzak!



DataSection
	blinds: :IncludeBinary "gfx\blinds.bmp"		;cheap blinds effect that works!
	sinefont:  :IncludeBinary "gfx\sfont.bmp"	;sine moved font
	lowerfont: : IncludeBinary "gfx\lowerfont.bmp"
	fontcol: :IncludeBinary "gfx\bottomraster.bmp"
	sinedat: : IncludeBinary "57sine.dat"		;data overlaps at the end so include it twice. Ripped form th eoriginal unpacked .prg file
		   IncludeBinary "57sine.dat"		;the original 68000 code copied the extra bit, but i'll just include it twice cos i'm lazy!
	sinend:
	logo: :IncludeBinary "gfx\staxlogo.bmp"		
	
	vubar: : IncludeBinary "gfx\vu.bmp"		
	
	music: :IncludeBinary "sfx\Stax_Menu _57.sndh"
	musend:
	
	
EndDataSection



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 162
; FirstLine = 12
; Folding = A1
; EnableXP
; UseIcon = Icon_2.ico
; Executable = Stax57.exe
; DisableDebugger
; IncludeVersionInfo
; VersionField0 = 1
; VersionField1 = 1
; VersionField2 = KrazyK
; VersionField3 = STAX CD 57 Win32 Remake
; VersionField4 = 1
; VersionField5 = 1
; VersionField6 = STAX CD 57 Win32 Remake
; VersionField7 = STAX CD 57 Win32 Remake
; VersionField8 = STAX57.exe
; VersionField9 = KrazyK
; VersionField10 = KrazyK