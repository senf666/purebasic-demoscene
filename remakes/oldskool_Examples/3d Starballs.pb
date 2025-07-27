
UsePNGImageDecoder()

Procedure.f Randomise(max)
r.f=Random(max)/10000	;small floating point
m=Random(2,1)		
If m=1:r=-r:EndIf	;make if negative or positive
ProcedureReturn r.f

EndProcedure

wx=900:wy=600		;screen size
KK_Window(wx,wy)

CatchSprite(1,?ball)
CatchSprite(2,?ball2)
CatchSprite(3,?ball3)


;Init the Starballs here

xcont.f=Randomise(200)		;new x movement 
ycont.f=Randomise(200)		;new y movement 
zcont.f=Randomise(200)		;new z movement  
time=Random(5000,1000)		;random time display
timer=ElapsedMilliseconds()	;start the timer

KK_StarBallsInit(wx,wy,200,1,2,3,32);screen width,screen height,spriteID1,spriteID2,spriteID3,max sprite size

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
	
	KK_StarBallsDraw(xcont.f,ycont.f,zcont.f);x speed, y speed, z speed (all floats)
	
	FlipBuffers()	
Until GetEsc()


DataSection

;Use up to 3 sprite  for the 'starfield'
	ball: :IncludeBinary "data\04.png"
	ball2: :IncludeBinary "data\05.png"
	ball3: :IncludeBinary "data\02.png"
	

EndDataSection


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 27
; FirstLine = 1
; Folding = +
; EnableXP
; DisableDebugger
; CompileSourceDirectory
; EnablePurifier
; jaPBe Version=3.9.4.774
; Build=0
; CodePage=65001
; DontSaveDeclare
; EOF