
;Fuzion 141 Win32 Remake
;Author:	KrazyK
;Date:		22:12:2013
;Language:	Purebasic 5.21 LTS
;		Requires PureProcs library for Zippy's oldskool music engine (both included)
;		Doesn't use any v5.xx specific functions so should also work With 4.xx. (can't test this anymore so don't blame me)
;		Set JaPbe real tabs  to 8 to display correctly.

;-This was all done in about 8 hours from start to finish including searching for, ripping and converting a Count Zero tune that
;-didn't exist in the sndh archive.  Not that I could find it anyway and i tried all Count Zero files with all tunes numbers.
;-I'm making this available to DBF so that anyone new to PureBasic or wanting to learn how to do remakes etc could (maybe) learn a bit from it.
;-I've done more complicated remakes so this is a good starter as it shows the principles involved in setting the screen up and a simple scroller.
;-It also has a nice simple VU meter line routine that i've only just created!

InitSprite():InitKeyboard()
Global fs=0			;-fullscreen/windowed flag


;-Choose windowed or fullscreen here

title$="Fuzion Menu 141,  Win32 Remake"
#xscr=800:#yscr=600
fs=MessageRequester("HEY!","Do you want to see me in FullScreen?",#PB_MessageRequester_YesNoCancel)
If fs=#PB_MessageRequester_No
	
	OpenWindow(1,0,0,#xscr,#yscr,title$,#PB_Window_ScreenCentered|#PB_Window_WindowCentered|#PB_Window_BorderLess)
	OpenWindowedScreen(WindowID(1),0,0,#xscr,#yscr,0,0,0)
	StickyWindow(1,1)	;-window always on top
	ShowCursor_(0)		;-hide the pesky mouse cursor!
ElseIf fs=#PB_MessageRequester_Yes
	
	ExamineDesktops()
	OpenScreen(#xscr,#yscr,DesktopDepth(0), title$)
	SetFrameRate(60)
Else
	End
EndIf


Global mount=CatchSprite(#PB_Any,?mainpic)			;-mountain image	
ClipSprite(mount,0,16,SpriteWidth(mount),SpriteHeight(mount)-16);-clip it a bit as it's slightly too big!

CatchImage(1000,?font)				;-capture our fontstrip for later use

Global border=CreateSprite(#PB_Any,80,600)	;-fake side borders
Global chan=CatchSprite(#PB_Any,?channels)	;-vu boxes
Global fuzlogo=CatchSprite(#PB_Any,?logo)	;-fuzion logo

Global MOSM,*Play,*GetVU			;-music functions
Global muslen1=?musend-?music			;-music lengths
Global muslen2=?mus2end-?music2
Global muslen3=?mus3end-?music3
Global muslen4=?mus4end-?music4

;-----------  Set up the horizontal scroller variables here --------------------
Global T$=Space(12)+"   YO FANS !!    FUZION PRESENTS COMPACT DISK 141 WICH CONTAINS :   DEVIOUS DESIGN ( PART A FOR MENU 142 ! ), ANCIENT GAMES AND UNDER PRESSURE.   DEVIOUS DESIGN WAS FIXED ( THE ORIGINAL ELITE CRACK WENT BACK TO THE MAIN MENU AFTER THE FIRST 10 LEVELS ), FILED, LINKED, PACKED AND TRAINED BY ORION OF FUZION, UNDER PRESSURE CRACK BY CYNIX, FILED AND LINKED BY BVCA OF FUZION ( BUT VMAX MEMBER WHEN HE DID THIS CRACK ! ), ANCIENT GAMES SUPPLIED BY TICK TOCK OF PURE ENERGY ....               CONTACT US AT :      FUZION       BP 66        59420  MOUVAUX       FRANCE             LET'S FEED THE BEAST, LET'S RULE IN THE NIGHT, LET'S WRAP .....                                                    "
T$+Space(12)		;-add a bit of space on the end of the scroller		
Global tlen=Len(T$)	;-length of the scrolltext
Global speed=16		;-speed
Global xmove=640	;-start position on screen
Global startletter=1	;-start letter
;-------------------------------------------------------------------------------


Global V1,OLDV1,V2,OLDV2,V3,OLDV3	;-variables for the VU channels

Procedure GetFont()
	;-I prefer to have my fonts pre-rendered/captured for later use. Old 68000 habits die hard !
	CatchImage(1000,?font)
	img=0
	For x=0 To ImageWidth(1000) Step 64
		GrabImage(1000,img,x,0,64,64)	;-all in one long handy strip now.
		img+1
	Next x
	FreeImage(1000)
EndProcedure

Procedure SetupMovement()
	;- The following sine movements are not exactly accurate down to the floating point but pretty close enough to the original -----
	;-   Feel free to mess around with them and see what happens! 
	
	;------------- star sine movement setup ----------------------------------------------
	xvalues=130
	yvalues=200
	Global T.f=0
	Global t2.f=0,t3.f,t4.f
	Global stp.f=(3.1415927*2)/xvalues
	Global stp2.f=(3.1415927*2)/yvalues
	;------------------------------------------------------------------------------------
	
	;---------- skull movement setup -----------------------------------------------------
	
	xvalues=170*2
	yvalues=215*2
	Global Tsk.f=0
	Global t2sk.f=0
	Global stpsk.f=(3.1415927*2)/xvalues
	Global stp2sk.f=(3.1415927*2)/yvalues
	Global frame=0
	Global SkullTM,SkullTM2
	
	;------------------------------------------
	
	;------------  Setup the fuzion logo movement now ----
	xvalues=130
	yvalues=50
	Global fuzT.f=0
	Global fuzt2.f=0
	Global fuzstp.f=(3.1415927*2)/xvalues
	Global fuzstp2.f=(3.1415927*2)/yvalues
	;------------------------------------------------
	
EndProcedure

Procedure GetSkulls()
	;-All the skull animation was captured individually and assembled in a strip. 64 x 64
	myskulls=CatchSprite(#PB_Any,?skulls)	;-read the sprite 
	DisplaySprite(myskulls,0,0)		;-now draw it on the screen but don't show it by flipping the buffers!
	For x=1 To 8
		GrabSprite(1000+x,(x-1)*64,0,64,64);-grab each frame from 1001 to 1008 for ease of use
	Next x
	ClearScreen(0)
	FreeSprite(myskulls)
EndProcedure

Procedure Scroller()
	;-Very simple horizontal scroller
	StartDrawing(ScreenOutput())
		For a=1 To 12					;-read enough letter to have 1 either side of the screen 
		tval=Asc(Mid(T$,startletter+a,1))-32		;-return the correct font value for us
		If tval<0:tval=0:EndIf				;-correct any odd ones!
		DrawImage(ImageID(tval),xmove+(a*64),600-64-30)	;-draw it on screen
	Next a							;-next letter
	StopDrawing()
	
	;-Now move the whole lot to the left by the 'speed' value and if we have gone off the screen
	;-by 2 whole letters then adjust the next letter to the end of the screen -1 letter.
	;-We do this so that the font is seen moving off rather that just ending at the edge of the screen.
	xmove-speed:If xmove=-128:xmove=-64:startletter+1:EndIf	
	
	;-Now check if the end of the scrolltext has been reached and it it has then start again and adjust the position of the scroller
	If startletter>tlen-12:startletter=1:xmove=640:EndIf
EndProcedure

Procedure Borders()
	;-fake left and right borders!
	;-this had to be done as the original removed the top and bottom border creating a much larger screen.
	;-Normally I use 640x480 and the ST uses 320x200 so doubled it easily fits on proportionatly.
	;-In this case the screen when enlarged prortionally was 800x562, hence using 800x600
	;-So in order that the scroller doesn't show beyond the edge of the 'screen' we have to blank it out with fake borders.
	DisplaySprite(border,0,0)
	DisplaySprite(border,800-80,0)	
EndProcedure

Procedure VUBox()
	;-Here we do the fancy VU meter box stuff.
	;-Here i've used coloured boxes i created earlier to then draw the lines on.
	;-[1] Read the value of the channel which returns 0-15
	;-[2] Copy the current part of the meter to the right.
	;-[3] Draw a line joining the current value to the previous value.
	;-[4] Draw each box onto our main screen in the correct location.
	
	V1=CallCFunctionFast(*GetVU,0)*2			;double the value to fill the box
	StartDrawing(ImageOutput(501))				;draw on the green inside box bit
		GrabDrawingImage(701,0,0,100,34)		;grab the current vu part
		DrawImage(ImageID(701),1,0)			;and draw it to the right of the current vu
		LineXY(0,0,0,34,RGB(0,64,0))			;blank out the current vu
		LineXY(0,(34-V1),1,(34-OLDV1),RGB(64,128,64))	;join the last value to the current value
	StopDrawing()
	
	V2=CallCFunctionFast(*GetVU,1)*2			;double the value to fill the box
	StartDrawing(ImageOutput(502))				;draw on the green inside box bit
		GrabDrawingImage(701,0,0,100,34)		;grab the current vu part
		DrawImage(ImageID(701),1,0)			;and draw it to the right of the current vu
		LineXY(0,0,0,34,RGB(0,64,0))			;blank out the current vu
		LineXY(0,(34-V2),1,(34-OLDV2),RGB(64,128,64))	;join the last value to the current value
	StopDrawing()
	
	V3=CallCFunctionFast(*GetVU,2)*2			;double the value to fill the box
	StartDrawing(ImageOutput(503))				;draw on the green inside box bit
		GrabDrawingImage(701,0,0,100,34)		;grab the current vu part
		DrawImage(ImageID(701),1,0)			;and draw it to the right of the current vu
		LineXY(0,0,0,34,RGB(0,64,0))			;blank out the current vu
		LineXY(0,(34-V3),1,(34-OLDV3),RGB(64,128,64))	;join the last value to the current value
	StopDrawing()
	
	
	StartDrawing(ScreenOutput())				;Draw all the boxes on screen
		DrawImage(ImageID(501),133,19+30)
		DrawImage(ImageID(502),334,19+30)
		DrawImage(ImageID(503),534,19+30)
	StopDrawing()
	
	;-make a copy of the current channel values
	OLDV1=V1
	OLDV2=V2
	OLDV3=V3
	
	
EndProcedure

Procedure GetChannelBoxes()
	;-Create some coloured boxes to draw the vu lines on
	CreateImage(501,96,32)
	StartDrawing(ImageOutput(501))
		Box(0,0,96,34,RGB(0,64,0))
	StopDrawing()
	
	CreateImage(502,96,34)
	StartDrawing(ImageOutput(502))
		Box(0,0,96,34,RGB(0,64,0))
	StopDrawing()
	
	CreateImage(503,96,34)
	StartDrawing(ImageOutput(503))
		Box(0,0,96,34,RGB(0,64,0))
	StopDrawing()
	
	
	
EndProcedure

Procedure MakeStars()
	;-Crappy random star generator like the original!
	;-Create 2 sprites to draw on big enough so that they can move around the screen without reaching their edges.
	
	CreateSprite(555,668*2,214*2)	
	CreateSprite(556,668*2,214*2)	
	
	StartDrawing(SpriteOutput(555))
	s=0
		Repeat
		rx=Random(668*2)
		ry=Random(214*2)
		Box(rx,ry,1,1)
		s+1
	Until s=200		;-More stars on the background than the foreground
	StopDrawing()
	
	StartDrawing(SpriteOutput(556))
		s=0
		Repeat
			rx=Random(668*2)
			ry=Random(214*2)
			Box(rx,ry,1,1)
			s+1
		Until s=100
	StopDrawing()
	
EndProcedure

Procedure ShowStars()
	;-Calculate the x and y positions using Sin()
	;-Sin() returns a value of between -1 and 1 so we have to multiply it by a larger value to see any movement.
	;-That's why we use floating point values.
	
	T.f+stp
	t2.f+stp2.f
	xpos=(100+(Sin(T.f)*96))-400
	YPos=(200+(Sin(t2.f)*43))-100
	DisplayTransparentSprite(555,xpos,YPos)
	
	t3.f=T.f
	t4.f=t2.f
	t3.f+(stp*40)	;-Foreground 'stars' move faster then the background.
	t4.f+(stp2*40)
	
	xpos=(100+(Sin(t3.f)*96))-400
	YPos=(200+(Sin(t4.f)*43))-100
	DisplayTransparentSprite(556,xpos,YPos)
	
	
EndProcedure

Procedure MoveSkull()
	;-Same movement prinicle with the skull but a different path.
	Tsk.f+stpsk
	t2sk.f+stp2sk.f
	
	xpos=(340+(Sin(Tsk.f)*240))
	YPos=(240+(Sin(t2sk.f)*170))
	
	SkullTM2=ElapsedMilliseconds()-SkullTM	;-Get the time since we checked last
	If SkullTM2>60				;-60 milliseconds passed?
		frame+1				;-if so then next frame in the animation
		If frame=8:frame=0:EndIf	;-but don't exceed the maximum frames
		SkullTM=ElapsedMilliseconds()	;-restart the timer for the next frame
	EndIf
	DisplayTransparentSprite(1001+frame,xpos,YPos)	;-Our current skull animation frame.
EndProcedure

Procedure ReplayMusic(Addr,muslen,tune)
	;-Can't get rid of the slight pause between stopping and starting the routine.  it's how it is!
	PurePROCS_CloseLibrary(MOSM)				;-just close the replay library.  Sometime when the music it stopped it generates an error!
	MOSM=PurePROCS_OpenLibrary(?osmlib)			;-re-open the library
	*Play=PurePROCS_GetFunction(MOSM,"playOSMEMusicMem")	;-get the function address
	*GetVU=PurePROCS_GetFunction(MOSM,"getOSMEChannelVU")	;-get the function address
	CallCFunctionFast(*Play,Addr,muslen,tune)		;-now play dat toon!
EndProcedure

Procedure MoveFuzion()
	;-Move the Fuzion logo around on another Sin() path
	fuzT.f+fuzstp
	fuzt2.f+fuzstp2.f
	
	xpos=(200+(Sin(fuzT.f)*130))
	YPos=(200+(Sin(fuzt2.f)*32))		
	DisplayTransparentSprite(fuzlogo,xpos,YPos)
	
EndProcedure

GetFont()
SetupMovement()		;-Do all the sine movement calulations here
GetSkulls()		;-from 1001-1008
GetChannelBoxes()	;-Create the VU meter boxes
MakeStars()		;-Make some crappy random stars


;-Intro picture bit - press space to continue!
Intpic=CatchSprite(#PB_Any,?intro)
DisplaySprite(Intpic,80,100)
FlipBuffers()
Repeat
	If fs=0:w=WindowEvent():EndIf				;-process and ignore window events if running windowed mode
Until GetAsyncKeyState_(#VK_SPACE)


Global MOSM=PurePROCS_OpenLibrary(?osmlib)    			;-Return the library address
Global *Play=PurePROCS_GetFunction(MOSM,"playOSMEMusicMem") 	;-Return the address of the play function
Global *GetVU=PurePROCS_GetFunction(MOSM,"getOSMEChannelVU")	;-Return the address of the channel volume function
CallCFunctionFast(*Play,?music2,muslen2,1)                   	;-Play the initial music


SkullTM=ElapsedMilliseconds()	;-Start the frame timer for the skull animation

Repeat
	If fs=0:w=WindowEvent():EndIf				;-only check windo events in windowed mode or purebasic will complain!
	ClearScreen(0)						;-wipe everything	
	ShowStars()						;-crappy stars
	DisplaySprite(mount,0,600-SpriteHeight(mount)-14)	;-mountain image
	DisplaySprite(chan,0,30)				;-VU meter boxes at the top
	VUBox()							;-VU colured boxes
	Scroller()						;-erm..
	Borders()						;-fake it baby!
	MoveFuzion()						;-moving fuzion logo
	MoveSkull()						;-skull animation
	FlipBuffers()						;-show it all
	
	;-test the keyboard for the new music and change it only if it isn't already playing that tune.
	;-the ST original used the top row from esc to minus for the tunes.
	;-instead of using esc we will use the Grave key.  The dodgy key left of the 1 and under the escape key with 3 characters on it!
	;-who uses that key? I've never ever used ¬ or ¦ in my life.  Oh wait, I just did !!
	
	ExamineKeyboard()
	If tn<>6 And KeyboardReleased(#PB_Key_1):tn=6:ReplayMusic(?music,muslen1,tn):EndIf
	If tn<>7 And KeyboardReleased(#PB_Key_2):tn=7:ReplayMusic(?music,muslen1,tn):EndIf
	If tn<>2 And KeyboardReleased(#PB_Key_3):tn=2:ReplayMusic(?music,muslen1,tn):EndIf
	If tn<>3 And KeyboardReleased(#PB_Key_4):tn=3:ReplayMusic(?music,muslen1,tn):EndIf
	If tn<>4 And KeyboardReleased(#PB_Key_5):tn=4:ReplayMusic(?music,muslen1,tn):EndIf
	If tn<>5 And KeyboardReleased(#PB_Key_Grave):tn=5:ReplayMusic(?music,muslen1,tn):EndIf
	If tn<>8 And KeyboardReleased(#PB_Key_6):tn=8:ReplayMusic(?music,muslen1,tn):EndIf
	If tn<>$16 And KeyboardReleased(#PB_Key_7):tn=$16:ReplayMusic(?music4,muslen4,tn):EndIf
	If tn<>$17 And KeyboardReleased(#PB_Key_8):tn=$17:ReplayMusic(?music4,muslen4,tn):EndIf
	If tn<>$18 And KeyboardReleased(#PB_Key_9):tn=$18:ReplayMusic(?music4,muslen4,tn):EndIf	
	If tn<>1 And KeyboardReleased(#PB_Key_0):tn=1:ReplayMusic(?music3,muslen3,tn):EndIf
	If tn<>2 And KeyboardReleased(#PB_Key_Minus):tn=2:ReplayMusic(?music2,muslen2,tn):EndIf
	
	
Until KeyboardPushed(#PB_Key_Escape)
;GrabSprite(1,0,0,800,600):SaveSprite(1,"Fuzion_141.bmp")
PurePROCS_CloseLibrary(MOSM)
ClearScreen(0)
FlipBuffers()
End


DataSection
	channels:
	IncludeBinary"gfx\channels.bmp"		;-vu meters
	font:
	IncludeBinary"gfx\fuz141font.bmp"	;-nice lower border font
	logo:
	IncludeBinary"gfx\fuzionlogo.bmp"	;-moving logo
	skulls:
	IncludeBinary"gfx\skullanim.bmp"	;-skull animation frames
	
	mainpic:
	IncludeBinary"gfx\mountain.bmp"		;-mountain image
	intro:
	IncludeBinary"gfx\intro.bmp"		;-intro pic
	
	music:
	IncludeBinary"sfx\awesome.sndh"		;-count Zero music
	musend:
	music2:
	IncludeBinary"sfx\lap_27.sndh"		;-lap sndh tune
	mus2end:
	music3:
	IncludeBinary"sfx\lap_33.sndh"		;-another one!
	mus3end:
	music4:
	IncludeBinary"sfx\zero_rip.sndh"	;-manually ripped Count Zero music. Custom 68000 header and conversion by KrazyK.  Uses tunes $16,$17, & $18 only
	mus4end:
	
	osmlib:					;-oldskool music replay library by Zippy
	IncludeBinary"sfx\osmengine.dll"
EndDataSection
