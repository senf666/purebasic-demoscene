;3D StarBalls example
;KrazyK 2018

;This example produces random directions and random display times


Procedure.f Randomise(max)
r.f=Random(max)/10000	;small floating point
m=Random(2,1)		
If m=1:r=-r:EndIf	;make if negative or positive
ProcedureReturn r.f

EndProcedure


KK_StarBallInfo()	;info box


wx=900:wy=600		;screen size
InitSprite()

OpenWindow(1,0,0,wx,wy,"",#PB_Window_BorderLess|#PB_Window_ScreenCentered|#PB_Window_WindowCentered)
OpenWindowedScreen(WindowID(1),0,0,wx,wy)
StickyWindow(1,1)
ShowCursor_(0)

CatchSprite(1,?ball)

;Init the Starballs here

KK_StarBallsInit(wx,wy,200,1,32)	;x screen size, y screen size, number of sprites,spriteid,maximum sprite size
KK_StarBallsSpeed(0.01,0.00,0.0)	;starting speeds

xcont.f=0.02				;first x movement 
ycont.f=0				;first y movement 
zcont.f=0				;first z movement 
time=Random(5000,1000)			;random time display
timer=ElapsedMilliseconds()		;start the timer

Repeat
	w=WindowEvent()
	ClearScreen(0)
	
	If ElapsedMilliseconds()-timer>time	;milliseconds for each movement
		xcont.f=Randomise(200)		;new x movement 
		ycont.f=Randomise(200)		;new y movement 
		zcont.f=Randomise(200)		;new z movement 
		time=Random(5000,1000)		;new random time display
		timer=ElapsedMilliseconds()	;start the timer
	EndIf
	
	KK_StarBallsDraw(xcont.f,ycont.f,zcont.f)	;x speed, y speed, z speed
	
	FlipBuffers()	
Until GetAsyncKeyState_(#VK_ESCAPE)

DataSection

ball: :IncludeBinary "ball4.bmp"

EndDataSection


; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 58
; FirstLine = 19
; Folding = +
; EnableXP
; DisableDebugger
; CompileSourceDirectory
; EnablePurifier