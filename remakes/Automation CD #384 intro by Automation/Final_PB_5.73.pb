;Automation Menu CD 384

;Code:		MONSTER
;Gfx:		MONSTER
;Music:		Crispy Noodle
;Released:	1990

;Win32 remake:	KrazyK	2011 - Updated 2023 for PB5.73
;Uses Purebasic Oldskool and OSME library


InitSound()	;required for disk drive sound
InitKeyboard()
KK_Window(640,400)

;{ drive load intro And depacker

track=0
KK_DiskDriveBoot()	;boot load sound
Repeat	
	event=WindowEvent()
	KK_DiskDriveLoad(1,400)	;1 track, 400 ms delay
	track+1
Until track=6

startime=ElapsedMilliseconds()
Repeat
	event=WindowEvent()
	KK_Depacker(1,640,400)
	FlipBuffers()
Until ElapsedMilliseconds()-startime>3000
;}


Global psg0,psg1,psg2		;vu channels
Global menuscreen,keeper,hz,hz50,hz60

Global Trans.f=0,offet=0 ;(offset=40 If fullscreen at 460x480)
Global t.f,t2.f,values,values2,ySin,xSin


;sine dots ======================
values=45
values2=180
Global stp.f=(#PI*2)/values
Global stp2.f=(#PI*2)/values2	
;================================

Declare FadeItOut()
Declare TypingFont()

Global typetimer,typer$,typelen,xtype,ytype,pausetimer,Letter=0,fading=0,pausing=0
Global TypeBox=CreateSprite(#PB_Any,16*23,132,#PB_Sprite_AlphaBlending)	;sprite to do the typing on
Restore typer								;start of the typing text
Read.s typer$								;read the fist line of text
typelen=Len(typer$)							;text length
typetimer=ElapsedMilliseconds()						;delay between each letter timer


Global TYPESPEED=16,TYPESPEEDMAX=60,TYPESPEEDMIN=16


Procedure GetBars()
Global redbar=CatchSprite(#PB_Any,?redbar)
Global bluebar=CatchSprite(#PB_Any,?blubar)

EndProcedure

Procedure GetAnim()
Global KeeperVU=CatchSprite(#PB_Any,?anim)
Global menuscreen=CatchSprite(#PB_Any,?menu)            ;- main menu pic
Global hz50=CatchSprite(#PB_Any,?hz50)                  ;- at 550,247
Global hz60=CatchSprite(#PB_Any,?hz60)
Global vubar=CreateSprite(#PB_Any,512,130)	;-sprite for scrolling vu
Global hz=hz50

EndProcedure

Procedure KeeperVU()
	psg0=OSMEGetVu(0)	;read channel 0
	Select psg0
		Case 1 To 12 	: ClipSprite(KeeperVU,0,196,196,196) 
		Case 13 	: ClipSprite(KeeperVU,0,0,196,196)
		Case 14 	: ClipSprite(KeeperVU,196,0,196,196)
		Case 15 	: ClipSprite(KeeperVU,197,196,196,196)	;slightly off by 1 pixel !
	EndSelect
	DisplaySprite(KeeperVU,16,16+offset)			;now display it
	
	
 EndProcedure

Procedure DoMenu()
DisplaySprite(menuscreen,0,offset)
DisplaySprite(hz,544,247+offset)

EndProcedure

Procedure BigVU()
        ;- red goes down first, then blue  
	;-right hand side of vu bar display = 530-16,248   16 pixels wide 126 pixels high  64 bars drawn  red,black,red,black....etc
          
        psg1=OSMEGetVu(1)			;read channel 1
	If psg1>15:psg=15:EndIf
	psg2=OSMEGetVu(2)			;read channel 2
	If psg2>15:psg=15:EndIf
	
    	DisplaySprite(vubar,16,248+offset)		;-re-display the current VU bars
							;
    	ClipSprite(bluebar,psg2*15,0,15,126)			;grab a volume slice of the bar
    	DisplayTransparentSprite(bluebar,530-16,249+offset)	;-blue
       	ClipSprite(redbar,psg1*15,0,15,126)
	DisplayTransparentSprite(redbar,530-16,248+offset)	;-red
	
	vubar=GrabSprite(#PB_Any,16+16,248+offset,512-16,130)	;-grab the current VU bars on screen
    
EndProcedure

Procedure GetFont()
	;pre-grab all characters into our array for later
	
	ClearScreen(RGB(0,160,0))
	Global Dim Chars(200)
	CatchImage(99,?smallfont)
		C=0
		For y=0 To ImageHeight(99)-1 Step 16
			For x=0 To ImageWidth(99)-1 Step 16
				Chars(C)=GrabImage(99,#PB_Any,x,y,16,16)
				C+1
			Next x
		Next y
		
		;create 32 flashing cursors
		Global counter=0
		Global cursmax=31
		Global Dim Cursor(32)
		
		For C=0 To 15
			Cursor(C)=GrabSprite(#PB_Any,0,0,16,16)	;green box cursor
		Next C
		For C=16 To cursmax
			Cursor(C)=CreateSprite(#PB_Any,16,16)	;blank
		Next C
		
		CatchImage(99,?smallfont2)
		C=97-32
		For y=0 To ImageHeight(99)-1 Step 16
			For x=0 To ImageWidth(99)-1 Step 16
				Chars(C)=GrabImage(99,#PB_Any,x,y,16,16)
				C+1
			Next x
		Next y
		
EndProcedure

Procedure FlashCursor()
counter+1
If counter>cursmax:counter=0:EndIf
DisplayTransparentSprite(Cursor(counter),246+(Letter*16)+8,16+(ytype*16)+4+offset,255-trans)	;slight corrections when drawing on the sprite
	
EndProcedure

Procedure TypingFont()

	
If ElapsedMilliseconds()-typetimer>TYPESPEED And fading=0 				;only draw every other frame and when not fading out
	typetimer=ElapsedMilliseconds()
	DisplayTransparentSprite(TypeBox,246,16+offset)					;show the text
	FlashCursor()
ProcedureReturn 
EndIf
	
If pausing=0 And fading=0						;only draw the next letter if we are not paused or fading
		Letter+1						;next letter
		c$=Mid(typer$,Letter,1)					;current letter
		If c$=Chr(2)						;pause control character?
			pausing=1					;set the flag
			pausetimer=ElapsedMilliseconds()		;start the pause tiemr for 4 seconds
			Goto breakout		
		EndIf
		If c$=Chr(3)						;pause and fade control character?
			pausing=1					;set the pause flag
			pausetimer=ElapsedMilliseconds()		;start the pause tiemr for 4 seconds
			fading=1					;set the fade flag
			Goto breakout		
		EndIf
		
		cval=Asc(c$)-32						;ascii value of the current letter in the string
		If cval>=0
			StartDrawing(SpriteOutput(TypeBox))					;draw on our sprite	
				DrawImage(ImageID(Chars(cval)),(Letter*16)-8,(ytype*16)+2)	;slight corrections when drawing on the sprite
			StopDrawing()
		EndIf
			
		If Letter>typelen					;end of line?
			Read.s typer$					;get next text line
			Letter=0					;back to the start
			ytype+1						;next line down if not
			If typer$=Chr($ff)				;end control charatere $ff
				Restore typer				;restart text
				Read.s typer$				;read 1st line
				ytype=0					;reset y position back to top
			EndIf		
		EndIf
		DisplayTransparentSprite(TypeBox,246,16+offset)		;show the text box
breakout:	
EndIf


If pausetimer>0 And fading=0 And ElapsedMilliseconds()-pausetimer>3000
	pausing=0
	pausetimer=0
EndIf

If fading=1
	FadeItOut()
Else
	DisplayTransparentSprite(TypeBox,246,16+offset)		;show the text box
	FlashCursor()
	
EndIf


	
EndProcedure

Procedure FadeItOut()
          
If fading=1
	If ElapsedMilliseconds()-pausetimer>3000
		DisplayTransparentSprite(typebox,246,16+offset,255-Trans)		;draw our typing box
        	Trans.f+5					;fade it
        	If Trans>255					;completely gone?
        		Trans=0					;transparent
			typebox=CreateSprite(#PB_Any,23*16,132,#PB_Sprite_AlphaBlending)	;re-create the typing box (or just clear it)
			fading=0:pausing=0:ytype=0		;reset everything
			Read.s typer$				;get next text line
			Letter=0				;start letter
			If typer$=Chr($ff)			;end of text yet?
				Restore typer			;start back at the top
				Read.s typer$			;read 1st line
				ytype=0				;start drawing at the top
			EndIf		
		EndIf	
	Else
		DisplayTransparentSprite(typebox,246,16+offset,255-trans);-trans)		;draw our typing box
		FlashCursor()
EndIf

EndIf	
        	
        	
EndProcedure

Procedure SinDots()

NumDots=16
StartDrawing(ScreenOutput())
For SDot=0 To NumDots
	t.f+stp
	t2.f+stp2.f         
	xSin=(260+(Sin(t2)*244))
	ySin=(200+(Sin(t)*62))
	Box(xSin+16,ySin+112+offset,2,2,#White)
Next SDot		
StopDrawing()
t.f-stp.f*NumDots
t2.f-stp2.f*NumDots
EndProcedure

GetBars()
GetAnim()
GetFont()


Repeat:Delay(1):Until IsScreenActive()


OSMEPlay(?music,?musend-?music,0)


Repeat
	ClearScreen(0)
	
	If fs=0:event=WindowEvent():EndIf
   
    	DoMenu()
    	KeeperVU()
    	BigVU()
    	TypingFont()
    	SinDots()
          
    	FlipBuffers()
       
          
    	ExamineKeyboard()
	
        If hz=hz60 : Goto NextHz:EndIf
        If KeyboardReleased(#PB_Key_0) And  hz=hz50
		hz=hz60 
	EndIf
NextHz:
        If KeyboardReleased(#PB_Key_0) And  hz=hz60 
		hz=hz50
	EndIf
	
	If KeyboardPushed(#PB_Key_Add) Or KeyboardPushed(#PB_Key_Equals)
		TYPESPEED+2
		If TYPESPEED>TYPESPEEDMAX:TYPESPEED=TYPESPEEDMAX:EndIf
	EndIf
	
	If KeyboardPushed(#PB_Key_Subtract) Or KeyboardPushed(#PB_Key_Minus)
		TYPESPEED-2
		If TYPESPEED<TYPESPEEDMIN:TYPESPEED=TYPESPEEDMIN:EndIf
	EndIf
	
Until GetEsc()
OSMEStop()
ClearScreen(0)
FlipBuffers()
End

DataSection
	
music:
IncludeBinary"sfx\hybunp4.sndh":musend:
smallfont:
IncludeBinary"gfx\smallfont2.bmp"
smallfont2:
IncludeBinary"gfx\smallfont3.bmp"




anim:
IncludeBinary"gfx\keepanims_256.bmp"
menu:
IncludeBinary"gfx\menupic_16.bmp"

hz50:
IncludeBinary"gfx\50hz.bmp"
hz60:
IncludeBinary"gfx\60hz.bmp"
redbar:
IncludeBinary"gfx\allred.bmp"
blubar:
IncludeBinary"gfx\allblu.bmp"


EndDataSection


IncludeFile "text.pb"

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 7
; Folding = Ag
; EnableXP
; UseIcon = Atari logo mask.ico
; Executable = Auto384.exe
; DisableDebugger
; CompileSourceDirectory