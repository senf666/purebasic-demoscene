;Pure Energy CD 62A

;Code:		:Argonaut
;Gfx:		:Spaz, The Spy
;Music:		;Big Alec
;Win32 Remake	:KrazyK 2022

;Feel free to edit, copy, steal, butcher this code for own purposes - a credit is always nice though ;-)
;Don't forget to use my OSME library to run this code with music!

InitSprite()
InitKeyboard()
OpenWindow(0,0,0,640,480,"Pure Energy Win32 Remake - KrazyK 20022",#PB_Window_BorderLess|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0),0,0,640,480)


Global wavelen=1194
Global Dim wobble(wavelen*4)
CopyMemory(?wave,@wobble(0),wavelen*4)	

Structure mywave	;ripped movement data array
	xpos.l
	xmove.l
	counter.i
EndStructure

Global Dim mywave.mywave(wavelen)

For i=0 To 24		;scroller position array
	mywave(i)\xpos=wobble(i)
	mywave(i)\xmove=0
	mywave(i)\counter=0
Next i

Structure raster	;RGB raster colour array
	r.l
	g.l
	b.l
EndStructure
Global Dim raster.raster(26)
CopyMemory(?rastercols,@raster(0)\r,(25*3*4))	;copy all the raster colour data into the array


Global small$="                                                      WELCOME TO MENU - 62A - PRESENTED BY - B.F.G - FOR A CHANGE..........          THANKS MUST GOTO ARGONAUT OF THE UNT FOR THIS LIKE TOTALLY COSMIC INTRO EXPERIENCE.......WITH SOFTWARE BEING SO SCARCE WE'VE EVEN GONE FOR A 3 DISC MENU WITH - ANCIENT ART OF WAR IN THE SKIES -..........      THIS IS DISCS 1 AND 4, SO ENTER THIS DISC WHEN ASKED FOR THEM ( A BIT OBVIOUS ! ).........         DATA FOR DISCS 2 AND 3 CONTAINED ON 62B AND 62C - MAKE SURE YOU HAVE THEM -..........          -IMPORTANT- ON MENUS 60A AND 60B KEEP BOTH DISCS WRITE-PROTECTED OR DATA WILL BE LOST...........            PERSONAL MESSAGE TO ALL MY FORIEGN CONTACTS - BIG TROUBLE WITH FOREIGN POST IN THE LAST FEW MONTHS SO IF YOU GET NOTHING FROM ME SOON - PLEASE REPLY - THANX...........         SHORT OF SPACE SO LOOK OUT FOR THE LATEST WARES ON OUR MENU AND UTIL COMPILS..........            ---  STAY WINE GUM FREE IN 93 WITH   P U R E  E N E R G Y  ---                  STAY SAFE B.F.G                                                                           "
Global midtext$="     GREETINGS TO THE FOLLOWING RAVE HEADS ,,, THE JOKER ~STOP PLAYING THE SNES MARIO BOY~ ,,, CYNIX ~ZIMMERNOVA~ ,,, REPLICANTS ,,, TRSI ,,, CLIMAX ,,, D BUG ,,, HEMOROIDS ~SINK~ ,,, BUFF ,,, ANIMAL MINE ,,, TRIPOD MAN ,,, HIGHLANDER ,,, ADRENALINE ,,, POV ~MSD~ ,,, DNT CREW ,,, CHRONICLE ,,, TFS,,, QUAID ,,, AND ANYONE ELSE STILL ALIVE         TIME TO GO CLUBBIN         SEE YA!"
Global bigtext$="    PURE ENERGY MEMBERS ARE  '''  ZAK  '''  HARLEQUIN ~WINE GUM KING~  '''  BFG  '''  ILLUSION  '''  KUBIK  '''  TECHNOBLIP  '''  RUDE KID  '''  VAX.L  '''  INXS  '''  FIREKIND  '''  THEGN  '''  ME~STE  '''  HOLOGRAM            "


Global xmove=0,speed=16,letter=1,tlen=Len(small$)
CatchImage(0,?font)			;small font
CreateImage(30,640*2,20)

;mid font
CatchSprite(300,?midfont)
Global midh=128,midw=168,midy=midh*6,midletter=0


;big font = 360x256 +18 for space
CatchSprite(100,?bigfont)
TransparentSpriteColor(100,#White)
CatchSprite(200,?bigraster)
Global bigletter=1,bigy=260*2
Global bigalpha$="ABCDEFGHIJKLMNOPQRSTUVWXYZ?!.,() "

border=CreateSprite(#PB_Any,640,40)
ClearScreen(#Blue)
line=GrabSprite(#PB_Any,0,0,640,1)

CatchSprite(500,?logo)
Global ysine.f,angle.f,inc.f=0.015

CatchSprite(400,?flyer)
Global fly_x.f,fly_y.f,flyanglex.f,flyxinc.f=0.025*2,flyyinc.f=0.015*2,flyangley.f,flycount.f



Procedure makescrollers()
;create lots of 640 px scrolletext that we then draw back to back off the screen to move them!!
maxlen=16*Len(small$)		;scroller pixel width
numscrolls=(maxlen/640)+1
For n=0 To numscrolls
CreateSprite(40+n,640,20)	
StartDrawing(SpriteOutput(40+n))
For i=1 To 40
	tval=Asc(Mid(small$,letter,1))-32
	If tval<0:tval=0:EndIf
		GrabImage(0,1,16*tval,0,16,12)
		DrawImage(ImageID(1),xmove+(i*16)-16,4)
		letter+1
	Next i
StopDrawing()
;SaveSprite(40+n,Str(40+n)+".bmp")	;uncomment to see how this works. Cheating but works perfectly :-)
Next n



EndProcedure

Procedure bigvert()
	gap=18	;correction for font gap
	For big=1 To 3
		pos=FindString(bigalpha$,Mid(bigtext$,big+bigletter,1))-1
		If pos>=0								;valid letters only!
			DisplayTransparentSprite(200,0,bigy+(big*256)+(gap*big))	;raster block underneath
			ClipSprite(100,0,pos*32,32,32)					;grab the correct letter
			ZoomSprite(100,360,256)						;zoom it
			DisplayTransparentSprite(100,0,bigy+(big*256)+gap*big)		;draw it
		EndIf
	Next big
	bigy-6:If bigy=<-(256*2):bigy=-256+gap:bigletter+1:EndIf			;move up
	If bigletter>Len(bigtext$):bigletter=1:bigy=256:EndIf				;check for end and reset
EndProcedure

Procedure multiscroll()

	
With raster(i)
For i=0 To 24
	mywave(i)\counter+1				;next position in the array
	If mywave(i)\counter>wavelen			;reached end?
		mywave(i)\counter=0			;reset
	EndIf		
	x=0						;scroll sprite x position
	mywave(i)\xpos=wobble(mywave(i)\counter+i)	;calc new x position 
	If mywave(0)\xmove =<-(640*26)	;-16640		;reached max left position off screen?
		mywave(i)\xpos=wobble(i)		;back to start positions
		mywave(i)\xmove=0			;reset	
		mywave(i)\counter=0			;reset
	EndIf
	
	mywave(i)\xmove+mywave(i)\xpos*2		;read x position and multiply for our screen
	
	For n=40 To 67					;draw all the scroll sprites back to back off the screen and up and down
		DisplayTransparentSprite(n,mywave(i)\xmove+(640*x),38+(i*16),255,RGB(\r,\g,\b))	;draw with correct raster colour 
		x+1
	Next n
Next i
EndWith


EndProcedure

Procedure movelogo()
	;move logo up and down on a simple sine mvement
	angle.f+inc.f	
	If angle>=360:angle=0:EndIf
	ysine_pos=500*Sin(angle.f)	
	
	DisplayTransparentSprite(500,640-64,ysine_pos-120)
	
EndProcedure

Procedure flyer()
	;not as accurate as the original but had trouble ripping the path data.  Pretty close though
	flyanglex+flyxinc
	If flyanglex>360:flyanglex=0:EndIf
	fly_x=200*Sin(flyanglex)
	
	
	flyangley+flyyinc
	If flyangley>360:flyangley=0:EndIf
	fly_y=120*Cos(flyangley)

	DisplayTransparentSprite(400,fly_x+180,fly_y+160)
	
EndProcedure

Procedure midscroll()
	
For i=1 To 5
	tval=Asc(Mid(midtext$,midletter+i,1))-33
	If tval=93:tval=2:EndIf		;~		;replace this character!
	
	If tval>=0
		ClipSprite(300,0,tval*(midh/2),midw/2,midh/2)
		ZoomSprite(300,midw,midh)
		DisplayTransparentSprite(300,360+20,midy+(midh*i))
	EndIf
Next i
midy-4
If midy=-(midh*2):midy=-midh:midletter+1:EndIf
If midletter>Len(midtext$):midletter=1:midy=midh*6:EndIf

	
EndProcedure

Procedure inttext()
CatchSprite(600,?menu)	
spwidth=SpriteWidth(600)
spheight=SpriteHeight(600)
	
fade.f=0
fadeinc.f=2.55
Repeat	
	ClearScreen(0)
	event=WindowEvent()
	fade+fadeinc
	If fade>255:fade=255:EndIf
	DisplayTransparentSprite(600,320-(spwidth/2),240-(spheight/2),fade)
	FlipBuffers()
	ExamineKeyboard()
Until KeyboardReleased(#PB_Key_All)


Repeat	
	event=WindowEvent()
	ClearScreen(0)
	fade-fadeinc
	DisplayTransparentSprite(600,320-(spwidth/2),240-(spheight/2),fade)	
	FlipBuffers()
Until fade<=0:

	
EndProcedure

inttext()

makescrollers()


OSMEPlay(?music,?musend-?music,1)

	
Repeat
	event=WindowEvent()
	ClearScreen(0)

	bigvert()
	midscroll()

	multiscroll()

	movelogo()
	flyer()

	DisplaySprite(border,0,0):DisplaySprite(border,0,440)
	DisplaySprite(line,0,40):DisplaySprite(line,0,441)

	FlipBuffers()
	ExamineKeyboard()
Until KeyboardReleased(#PB_Key_Escape)

OSMEStop()
End

DataSection
	wave:
	IncludeFile "wobble.pb"						;small font wobble ripped data
	wavend:
	menu:		:IncludeBinary "gfx\menu.bmp"
	font:		:IncludeBinary "gfx\smfont.bmp"
	bigfont:	:IncludeBinary "gfx\bigfont.bmp"
	bigraster:	:IncludeBinary "gfx\bigraster.bmp"
	logo:		:IncludeBinary "gfx\logo.bmp"
	flyer:		:IncludeBinary "gfx\infoflyer.bmp"
	midfont:	:IncludeBinary "gfx\mid2.bmp"				;168x128 ; font rip is slightly fucked up!!
	music:		:IncludeBinary "sfx\PYM-Sickest_So_Far.sndh":musend:

rastercols:
Data.L  224,0,224
Data.L  192,0,224
Data.L  160,0,224
Data.L  128,0,224
Data.L  96,0,224
Data.L  64,0,224
Data.L  32,0,224
Data.L  0,0,224
Data.L  0,32,224
Data.L  0,64,224
Data.L  0,96,224
Data.L  0,128,224
Data.L  0,160,224
Data.L  0,192,224
Data.L  0,224,224
Data.L  0,224,192
Data.L  0,224,160
Data.L  0,224,128
Data.L  0,224,96
Data.L  0,224,64
Data.L  0,224,32
Data.L  0,224,0
Data.L  32,224,0
Data.L  32,224,0
Data.L  64,224,0

EndDataSection


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 9
; Folding = A+
; EnableXP
; UseIcon = BlueFuji.ICO
; Executable = PE_CD62A.exe
; DisableDebugger
; IncludeVersionInfo
; VersionField0 = 1
; VersionField1 = 1
; VersionField2 = KrazyK
; VersionField3 = Pure Energy CD62A - Win32 Remake
; VersionField4 = 1
; VersionField5 = 1
; VersionField6 = Pure Energy CD62A - Win32 Remake
; VersionField7 = Pure Energy CD62A - Win32 Remake
; VersionField8 = PE_CD62A.exe
; VersionField9 = KrazyK
; VersionField10 = KrazyK