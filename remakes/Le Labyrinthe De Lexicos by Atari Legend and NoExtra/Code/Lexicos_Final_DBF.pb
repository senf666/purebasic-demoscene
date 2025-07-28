
;- 	Atari ST(e) Remake for DBFInteractive
;-	Le Labyrinthe de lexicos - Intro

;-	Code, ripping, converting etc:	KrazyK
;-	Language:			Purebasic 5.42
;-	Libraries:			Cusotm Vectorlines
;-	Set real tabs to 8 !

;-	Original:
;-	Code:	ZORRO 2
;-	Gfx:	Mister A
;-	Music:	Maktone (STe version)

;-	Note:	ST version used a Big Alec chiptune (not used here)



DataSection
AL:
IncludeFile"al.pb"		;-3D point
ALEnd:
ALJoints:
IncludeFile"aljoints.pb"	;-3D joints
jointsend:
leftpic:
IncludeBinary"gfx\left.bmp"
font:
IncludeBinary"gfx\font.bmp"
music:
IncludeBinary"sfx\lex1.mod"
musend:
noextra:
IncludeBinary"gfx\noex.bmp"



control:
;- Rotastion changes and timers
;-		xangle	yangle	zangle	timer
Data.f		0.053	,0.07,	0.004	,10.00
Data.f		0.03	,0.062,-0.009	,2000.00
Data.f		0.07	,0.01,	0.014	,3000.00
Data.f		0.03	,0.02,	0.001	,5000.00
Data.f		0.003	,0.02,	0.08	,5000.00
Data.f		0.001	,0.08,	0.001	,4000.00
controlend:	
	
EndDataSection

If InitSprite()=0 Or InitSound()=0
	MessageRequester("Oops!", "Could not initialize DirectX, bye!"):End
EndIf

Global FS=0	;fullscreen flag 0 or 1



#xres=640	;-Screen X
#yres=480	;-Screen Y
#off=40		;-pixel offset to make the PC screen proportionally accurate
#max_X=30	;-number of letters across
#max_Y=25+10	;-number of rows down

;[------  Screen stuff ----------

If FS=0
	OpenWindow(1,0,0,#xres,#yres,"",#PB_Window_ScreenCentered|#PB_Window_WindowCentered|#PB_Window_BorderLess)
	OpenWindowedScreen(WindowID(1),0,0,#xres,#yres)
	StickyWindow(1,1)
	ShowCursor_(0)
Else
	OpenScreen(#xres,#yres,32,"")
	SetFrameRate(60)
EndIf

CatchSprite(1000,?leftpic):leftwidth=SpriteWidth(1000)	;-Atari Legend side logo

;-Top and bottom border as ST screne is 320x200.  This makes the PC screen 640x400.
;-Therefore we need to blank the top and bottom out by 40 pixels to be accurate :-)
border=CreateSprite(#PB_Any,640,#off)

;]-

;[-------   3D Object setup ----------
Global xang.f,yang.f,zang.f
Global oblength=?ALEnd-?AL	
Global pntlength=?jointsend-?ALJoints
KK_VectorInit()				;-init the library
CreateSprite(10,640,480)		;-sprite to draw 3D AL on
KK_VectorObject(?AL,oblength,10)	;-capture the 3D object and set the sprite
KK_VectorPoints(?ALJoints,pntlength)	;-Catch the 3D points/joints
KK_VectorCentre(320+100,240,300)	;-set the centre
Global ADDR,ObCounter=0

Structure Control
	speedx.f
	speedy.f
	speedz.f
	timer.f
EndStructure

Global Dim ObControl.Control(100)		;-define our array
Global cnt_len=?controlend-?control		;-length to copy
Global cnt_max=cnt_len/(4*4)			;-how much data?
CopyMemory(?control,@ObControl(0),cnt_len)	;-copymemory - (don't use Read.f)

;]-


textbit:
IncludeFile"text.pb"		;-30 x 25 text blocks
textend:

Global TM=ElapsedMilliseconds()
Global TM2

Global TM3=ElapsedMilliseconds()
Global TM4

Global TimeDone=ObControl(ObCounter)\timer
Global newz.f=300
Global cx=840,FirstRun=1
Global Movein=0,Moveout=0,stepz.f=20
xang=90

Global fader=CreateSprite(#PB_Any,640,400)	;-sprite to draw the end wipe effect on
esc=0
IT=0

Global yWipe1=0,yWipe2=400-2
Global Wipe1Val=4
Global Wipe2Val=-4

;[----- text typing stuff -------------
CreateSprite(11,#xres-leftwidth,400)	;-sprite to draw text on
CatchImage(1000,?font)			;-ripped font strip
Global X=0,Y=0,tval,L=1,Wiping=0,WipeY=0,Tlen=Len(T$)
;]-


Procedure CheckTimer()
	
	If Movein=0 And Moveout=0
		TM4=ElapsedMilliseconds()	;move in /out timer
		If TM4-TM3>27000		;-move in/out (actually a 27 second gap?)
			Movein=1
			Moveout=0
		EndIf
	EndIf
	
	If Movein=1
		newz+stepz:If newz>1300:newz=1300:Moveout=1:Movein=0:EndIf
	EndIf
	If Moveout=1
		newz-stepz:If newz<300:newz=300:Moveout=0:Movein=0:TM3=ElapsedMilliseconds():TM4=0:EndIf
	EndIf
	
	
	TM2=ElapsedMilliseconds()	;-normal transition timer
	
	If TM2-TM>TimeDone		;-passed the timer?
		;- get new data to use
		ObCounter+1:If ObCounter=cnt_max:ObCounter=0:EndIf
		TM=ElapsedMilliseconds()
		TimeDone=ObControl(ObCounter)\timer
		TM2=0
	EndIf
EndProcedure

Procedure TextWriter()

StartDrawing(SpriteOutput(11))
If Wiping=0
	
	tval$=Mid(T$,L,1)
	If tval$="0":tval$="O":EndIf
	If tval$="2":tval$="Z":EndIf
	
	tval=Asc(tval$)-65
	
	If tval=-19:tval=26:EndIf	;-check for full stop
	
	If tval>=0 And tval<=26							
		GrabImage(1000,2000,tval*16,0,16,16)	;-grab a chanracter form the fontstrip
		DrawImage(ImageID(2000),X*16,Y*16)	;-only draw valid images
	EndIf
	
	L+1
	If L>=Tlen:X=0:Y=0:L=1:Wiping=1:Goto WipeOut:EndIf		;-reached end of the text?

	X+1
	If X=#max_X
		X=0:Y+1
		If Y=#max_Y
			Y=0:X=0:Wiping=1	;-start wiping the text sprite
			Goto WipeOut
		EndIf
	EndIf

Else
WipeOut:
	Box(0,WipeY,640,2,RGB(64,64,64))	;-wipe down the screen
	WipeY+2
	If WipeY>#yres:Wiping=0:WipeY=0:EndIf
EndIf


StopDrawing()


	
	
	
EndProcedure

Procedure Intro()
CatchSprite(999,?noextra)
xp=320-(SpriteWidth(999)/2)
yp=240-(SpriteHeight(999)/2)
fade.f=0
playing=0
CatchMusic(1,?music,?musend-?music)
MusicVolume(1,0)
PlayMusic(1)

Repeat
	If FS=0:w=WindowEvent():EndIf
	DisplayTransparentSprite(999,xp,yp,fade)
	fade+2.55
	MusicVolume(1,fade.f/2.55)
	If fade>=255:fade=255:EndIf

	FlipBuffers()
	ClearScreen(0)
Until fade=255

PT=ElapsedMilliseconds()

Repeat
	If FS=0:w=WindowEvent():EndIf
Until ElapsedMilliseconds()-PT>1000

Repeat
	If FS=0:w=WindowEvent():EndIf
	DisplayTransparentSprite(999,xp,yp,fade)
	fade-2.55
	If fade<0:fade=0:EndIf
	FlipBuffers()
	ClearScreen(0)
Until fade=0




EndProcedure

Procedure WipeFinish()
;RGB(112,0,80)
;-wipe stepped up and down at the same time

Repeat
If FS=0:w=WindowEvent():EndIf			;-check window events only in windowed mode
	

StartDrawing(SpriteOutput(fader))
	Box(0,yWipe1,640,2,RGB(112,0,80))
	yWipe1+Wipe1Val
	Box(0,yWipe2,640,2,RGB(112,0,80))
	yWipe2+Wipe2Val
StopDrawing()

DisplaySprite(444,0,#off)
DisplayTransparentSprite(fader,0,#off)

FlipBuffers()

Until yWipe1>=400

EndProcedure

Intro()

esc=0
Repeat
	CheckTimer()
	If FS=0:w=WindowEvent():EndIf					;-check window events only in windowed mode
	
	ClearScreen(RGB(64,64,64))

	TextWriter()							;-write text on the sprite
	DisplayTransparentSprite(11,leftwidth,#off)			;-show the sprite text
	
	xang+ObControl(ObCounter)\speedx
	yang+ObControl(ObCounter)\speedy
	zang+ObControl(ObCounter)\speedz
	
	If FirstRun=1 
		If cx<>400:cx-4
		Else 
			FirstRun=0
		EndIf
	EndIf
	KK_VectorCentre(cx,240,newz)
	
	ADDR=KK_VectorDrawObject(xang.f,yang.f,zang.f,RGB(192,192,192))	;-update the 3D AL object

	DisplayTransparentSprite(10,0,0)				;-display 3D AL Object
	DisplaySprite(1000,0,#off)					;-left pic
	DisplaySprite(border,0,0)					;-top border
	DisplaySprite(border,0,#yres-#off)				;-bottom border
	
	
FlipBuffers()
Until GetAsyncKeyState_(#VK_ESCAPE)

WipeFinish()
StopMusic(1)

; IDE Options = PureBasic 5.42 Beta 3 LTS (Windows - x86)
; CursorPosition = 305
; FirstLine = 119
; Folding = A+
; EnableUnicode
; EnableXP
; DisableDebugger
; EnablePurifier