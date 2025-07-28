
;Disk drive boot and depack test


KK_Window(800,600)

InitSound()
KK_DiskDriveBoot()	;disk drive boot sound

For d=1 To 7
	KK_DriveLoad(1,400)	;track load sound
Next d



#AUto23=1
#Auto501=2
#Pompey1=3
#Pompey2=4
#Atomik35=5
#Jam4=6
;depak=1;Random(6,1)		;random depack mode

timer=ElapsedMilliseconds()
Repeat
	w=WindowEvent()
	ClearScreen(0)
	KK_Depacker(#auto23,800,600)
	;KK_Depacker(dpak,800,600)	;random
	
	FlipBuffers()
Until ElapsedMilliseconds()-timer>4000 Or GetEsc()
	

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 22
; EnableXP
; DisableDebugger