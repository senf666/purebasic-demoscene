;-	Awesome Intro 16 Win32 Remake
;-	KrazyK 2015
;-	January 2015
;-	PureBasic 5.24 LTS
;-	Custom UserLibraries: KK_Rasters, OSMELibrary


DataSection
	font:
	IncludeBinary"gfx\menu16font.bmp"
	awe:
	IncludeBinary"gfx\awesome16.bmp"
	music:
	IncludeBinary"sfx\lap_28.sndh"
	musend:
	
EndDataSection

InitSprite()

#Windowed=0
#FullScreen=1

FS=#Windowed						;fullscreen or windowed - the choice is yours ;-)

#ScreenWidth=640
#ScreenHeight=480

If FS=1
	KK_Screen(#ScreenWidth,#ScreenHeight,60)	;width, height, refresh rate
Else
	KK_Window(#ScreenWidth,#ScreenHeight)
EndIf


;- ============================  raster bar variables =====================================
Global MidPos=(450/2)-20		;centre of the sine movement	
Global Dim angle.F(12)			;array for the y positions of each raster bar
For A=1 To 11:angle(A)=0+ (A*14):Next A	;start each raster bar at a different height/angle
Global Dim NewYpos.F(12)		;each bar has it's own Y position array

#SineWaves=2				;only 2 waves
#SineStep=20				;width of each chunk in the raster bar
#SineHeight=165				;maximum height to move the rasters from the centre point
#BarSpeed=1.68				;how fast?


;-================ Scroller variables ====================================

Global Scroll$=UCase(Space(32)+"WELCOME TO THIS DISK WHICH HOLDS THE TITLE OF AWESOME MENU 16!   YOUR HOST FOR THIS FULL OVERSCAN MENU IS RUTHLESS.    I WOULD LIKE TO DEDICATE THIS MUSIC TO QUEERTRO OF COCKUP ORGASM, HEY THAT'S WRONG, LET ME GET MY C.O. DICTIONARY...    AHA, SORRY IT IS ACTUALLY SUPPOSED TO READ AS...  I WOULD LIKE TO DEDICATE THIS MENU TO QUATTRO OF CLOCKWORK ORANGE BECAUSE HE KEEPS ON ASKING ME TO SEND HIM SOME LAP MUSIC - WON'T YOUR 'ULTIMATE RIPPER' HARDWARE CARTRIDGE LET YOU RIP IT WITH IT'S BUILT IN MUSIC RIPPER, WHAT'S THAT YOU DON'T KNOW HOW TO USE IT.   OH DEAR, WELL JUST TO MAKE YOU HAPPY I WILL PUT SOME LAP MUSIC FILES ON THE NEXT MENU (WITH REPLAY CODE OF COURSE, A BIT USELESS TO YOU OTHERWISE - DON'T YOU AGREE!!!).  ONLY KIDDING QUATTRO.    OR WAS I?   HO!  HO!  HO!      NOW ONTO THE MEMBERS OF AWESOME, I WOULD LIKE TO TAKE THIS OPPORTUNITY TO LET ZELDA KNOW THAT AS FROM THIS MENU HE IS NO LONGER A MEMBER OF AWESOME.  DON'T TAKE IT PERSONALLY, 3 OTHERS WILL BE KICKED OUT SOON AS WELL!    A BIG WELCOME TO OUR NEW MEMBER WHO WILL BE GOING UNDER THE NAME OF 'DOMINION'  HE IS A VERY GOOD CRACKER, CODER, FILER AND PACKER.   YOU CAN EXPECT TO SEE LOTS OF HIS WORK ON FUTURE AWESOME MENUS!!!   HE IS THE GUY WHO CODED THE POMPEY PIRATES THE FULL SCREEN INTRO ON THEIR MENU 88 AND THE CONTROLABLE SPACESHIP ON THEIR MENU 91.   TECHNO WILL BE LEAVING THE CREW OF HIS OWN ACCORD TOWARDS THE END OF THE YEAR AND HE WILL BE GREATLY MISSED!     MEMBERS OF AWESOME NOW ARE:-  RUTHLESS, FROSTY, K-KLASS, DOMINION, TECHNO, THE BALD EAGLE, JOLLY ROGER, THE EDITMAN, ONIXUS AND PHOENIX...    NOW YOUR CHANCE TO JOIN ONE OF THE WORLDS BIGGEST CREWS...  YES, HERE IS YOUR CHANCE TO JOIN AWESOME.  IF YOU CAN CRACK, FILE, CODE, OWN A MODEM OR YOU FEEL YOU DO SOMETHING ELSE WHICH WOULD BE USEFUL TO US, THEN PLEASE CONTACT US, DO NOT WRITE TO OUR P.O. BOX IN ICELAND BUT WAIT FOR THE BRITISH P.O. BOX ADDRESS COMING SOON ON A NEW AWESOME MENU!          CREDITS FOR THIS MENU GOTO... CODING BY:- ECSTASY OF THE REPLICANTS, G.F.X BY:- MAGNUM OF TWB, AND MUSIC BY:- LAP....     RIGHT DUDES, VERY QUICK 'WORD TO THE MOTHER' GREETS GOTO...   THE REST OF AWESOME, THE REPLICANTS (CAMEO, COBRA, SNAKE, ECSTASY AND ALL THE OTHERS), THE SYNDICATE - OUR PARTNERS IN CRIME (FLOSSY AND BEAST, PLEASE CALL ME FLOSSY!), THE REST OF E.S.C. (T.S.B. ESP. ZINE, I AM GLAD YOU ARE BACK!), FUZION (KELLY-X, DOCNO AND DRAGON), THE SYNIX, HAL, EGB, MAGNUM, THE POMPEY PIRATES (GENIE, YUM-YUM, PACMAN, LITTLE LULU AND MY NEW CONTACT SPARKY - NICE TALKING TO YOU DUDE!), SUPERIOR (WANDERER AND AXE), GRIFF, GINO, FACTORY (HIGHLANDER AND SPY 3), LYNX (HEADHUNTER), N.P.G. (TGA), ORION (SPIFF), UNTOUCHABLES (MATT AND TONY), QUATTRO, RIP (TITANIC TARZAN - WHAT HAS HAPPENED TO THE LETTERS?), ELECTRONIC, PROWLER, THE SOURCE (KALAMAZOO AND MUG), EVIL FORCE (JASON ELITE), THE RADICAL BANDITS (T H E  R U D E  D U D E AND HIS SUPPLIER), FUTUR MINDS (SKYLINE), THE AVENGER, BLOODANGEL, PEDRO, NOW 5 (FALCON), ANGELS OF MERCY (BUT ESPECIALLY KIM), THE FOX, TEDDY, GEORGE, NEW PIRATES, IMAGINA, EVOLOUTION (MONSTER BEETLE - HOPE YOU LIKE YOUR INTRO), THE P.H.F. CODERS FORM HULL (CODING FOR FUN), ROBERTO FROM ITALY, H.A.C. (DOCTOR BYTE), V MAX (THANX FOR GREET), JOBIL, NEXT, STUART, JOKER AND TO ALL OTHERS THAT I HAVE FORGOTTEN...   NO TIME FOR ANYMORE BULLSHIT SO UNTIL THE NEXT SAGA OF THE 'HOTEST SOFTWARE AROUND' RUTHLESS SUMMONS A WRAP.     LET'S WRAP DUDES!                          ")
Global Tlen=Len(Scroll$)		;scroll text length
Global Xmove=0				;start the scrolltext at the edge of the screen
#FontWidth=32				;font width
#FontHeight=32				;font height
#ScrollSpeed=4				;nice n slow
Global Letter=0				;start letter of our scrolltext
CatchSprite(4,?font)			;the font i ripped from the original .prg file (STeem is a wonderful program !)

;-=================================================================

KK_RasterInit()					;initialize my raster bar routine
BlueBar=KK_RasterCreate(1,640,36,RGB(0,0,224))	;blue raster scroll bar
Awesome=CatchSprite(#PB_Any,?awe)		;AWESOME logo with the menu text

Procedure CreateRasterBars()			;create each colour raster bar according to the original ST palette
	;when calling this function it returns the raster bar as a sprite.
	
	Global Raster1=KK_RasterCreate(1,640,48,RGB(224,0,0))
	Global Raster2=KK_RasterCreate(1,640,48,RGB(224,128,0))
	Global Raster3=KK_RasterCreate(1,640,48,RGB(224,192,0))
	Global Raster4=KK_RasterCreate(1,640,48,RGB(160,192,0))
	Global Raster5=KK_RasterCreate(1,640,48,RGB(0,224,0))
	Global Raster6=KK_RasterCreate(1,640,48,RGB(0,224,128))
	Global Raster7=KK_RasterCreate(1,640,48,RGB(0,224,192))
	Global Raster8=KK_RasterCreate(1,640,48,RGB(0,160,224))
	Global Raster9=KK_RasterCreate(1,640,48,RGB(0,0,224))
	Global Raster10=KK_RasterCreate(1,640,48,RGB(160,0,224))
	Global Raster11=KK_RasterCreate(1,640,48,RGB(224,0,192))
EndProcedure

Procedure MoveRasterBar(Index,Bar)
	BarX=0
	BarWidth=0
	
	angle(Index) + #SineWaves*#BarSpeed
	If angle(Index) >= 360:angle(Index) = 0:angle(Index) = 0:EndIf
	
	Repeat
		NewYpos(Index)=#SineHeight*Sin(Radian(angle(Index)+(BarX*#SineWaves)))
		ClipSprite(Bar,(BarX*#SineStep),0,#SineStep,48)
		DisplayTransparentSprite(Bar,(BarX*#SineStep),NewYpos(Index)+MidPos)
		BarX+1
		BarWidth+#SineStep
	Until BarWidth=640		;until the length of the bar
	
	
EndProcedure

Procedure Scroller()
	;simple scroll routine. There a a number of ways to do this but I prefer this method as it's easy to remember!
	
	For L=1 To (#ScreenWidth/#FontWidth)+2							;enough characters on screen and 1 either side so we scroll on and off the screen smoothly
		Tval=Asc(Mid(Scroll$,L+Letter))-32						;get the ascii value of our letter in the scroll text
		ClipSprite(4,#FontWidth*Tval,0,#FontWidth,#FontHeight)				;grab a character from the ripped font strip
		If IsSprite(4):	DisplayTransparentSprite(4,Xmove+(L*#FontWidth),385+40):EndIf	;only show it if it's a valid sprite
	Next L

	Xmove-#ScrollSpeed:If Xmove=-(#FontWidth*2):Letter+1:Xmove=-#FontWidth:EndIf		;move the scroller left and get the next letter only if we have scrolled a whole letter off the screen first
	If Letter>Tlen:Letter=0:Xmove=#ScreenWidth:EndIf					;have we reached the end of our scroll text?, then start again.
	
EndProcedure

Procedure RasterBars()
	;each raster bar moves in exactly the same sine wave, just slight behind each other so we get a nice delayed wave effect
	MoveRasterBar(1,Raster11)
	MoveRasterBar(2,Raster10)
	MoveRasterBar(3,Raster9)
	MoveRasterBar(4,Raster8)
	MoveRasterBar(5,Raster7)
	MoveRasterBar(6,Raster6)
	MoveRasterBar(7,Raster5)
	MoveRasterBar(8,Raster4)
	MoveRasterBar(9,Raster3)
	MoveRasterBar(10,Raster2)
	MoveRasterBar(11,Raster1)
EndProcedure


CreateRasterBars()

OSMEPlayMusic(?music,?musend-?music,1)		;call my custom OSME library

Repeat
	If FS=#Windowed:w=WindowEvent():EndIf	;only process window events in windowed mode.
	ClearScreen(0)				;wipe
	RasterBars()				;move our lovely raster bars
	DisplayTransparentSprite(Awesome,0,40)	;main image with logo and menu text
	DisplaySprite(BlueBar,0,385+40)		;our created blue scroll raster bar
	Scroller()				;scroll the text on the blue raster bar
	FlipBuffers()
Until GetAsyncKeyState_(#VK_ESCAPE)		;escape pressed?

OSMEStopMusic()					;stop the music!
 
; jaPBe Version=3.12.8.877
; FoldLines=0040004E005000600062006E0070007D
; Build=6
; ProductName=Awesome Menu 16 Win32 Remake
; ProductVersion=1
; LegalTrademarks=KrazyK
; FileDescription=Awesome Menu 16 Win32 Remake
; FileVersion=1
; InternalName=Awesome Menu 16 Win32 Remake
; LegalCopyright=KrazyK
; OriginalFilename=Menu16
; Language=0x0000 Language Neutral
; FirstLine=21
; CursorPosition=23
; UseIcon=GFX\Atari logo.ico
; ExecutableFormat=Windows
; Executable=Menu16.exe
; DontSaveDeclare
; EOF