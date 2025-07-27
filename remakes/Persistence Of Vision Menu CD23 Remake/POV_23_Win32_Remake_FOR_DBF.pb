;POV Menu Disc #23

;Code: MAC SYS DATA
;Gfx:	MAC SYS DATA
;Music:	MAD MAX

;Win32 Remake by KrazyK October 2021
;Feel free to play with this code and use it as you wish - A little credit is always nice though ;-)

InitSprite()

OpenWindow(0,0,0,800,600,"POV Menu CD #23 - Win32 Remake by KrazyK",#PB_Window_BorderLess|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0),0,0,800,600)
StickyWindow(0,1)		;stay on top
ShowCursor_(0)			;hide the mouse


;{ Array setup for sine data
;The sine wave data was ripped directly from the ST prg file using STEem and MonST.  It is in byte format.
Global datlen=(?datend-?dat)		;length of the ripped sine data

Structure ysine				;create a structure for the data
	index.i				;each 8 pixel vertical slice of the scroller has an index
	ypos.b				;the actual value of sine byte data
EndStructure

Global Dim ysine.ysine(datlen+1)	;create the array
For i=0 To datlen-1			;length of the data
	p.b=PeekB(?dat+i)		;read the sine byte
	ysine(i)\ypos=p.b		;store it in the array
	ysine(i)\index=i		;increase the index of each slice
Next i
;} ============================================

;{ Gfx setup etc

Global bottomraster=CatchSprite(#PB_Any,?blueraster)	;blue bottom raster
ZoomSprite(bottomraster,640,36)				;make it bigger to cover the bottom scrolltext
Global ripfont=CatchImage(#PB_Any,?font)		;my ripped font from the original menu
Global scrollimg=CreateSprite(#PB_Any,640,36)		;draw the scroll text  on here first
TransparentSpriteColor(scrollimg,#White)		;white is transparent so the raster shows through from the back
Global rasterimg=CatchSprite(#PB_Any,?raster)		;central bendy raster colour
Global scroll$="            MAC SYS DATA     @ PRESENTS         P.O.V. DISC 23    @  ALL CODING/GRAPHIX/PACKS BY M.S.D.         MUSIC IS FROM DUGGER AND WAS WRITTEN BY JOCHEN HIPPEL (MAD MAX).     HELLO TO -    THE REPLICANTS,   AUTOMATION,   SLIPSTREAM,   THE DEMO CLUB,   VISION FACTORY,   DPS,   ABE,   STEWART,   DR.SYNE,   BORIS,   ALY,   THE LOST BOYS,   TCB,   ST-SQUAD,   THE MEDWAY BOYS,   POMPEY PIRATES,   THE UNION,   SEWER SOFTWARE   AND   ANY OTHER MAJOR CREW I'VE MISSED.                WELL WHAT DO YOU THINK OF THIS NEW 'SINUS' SCROLLER?        I GOT THE IDEA FROM SLIPSTREAM ON THE AMIGA, IT CHANGES THE HEIGHT OF THE TEXT EVERY 4 PIXELS (A NIBBLE) AND IS DISPLAYED IN 1 PLANE. I THINK I COULD MAKE IT FASTER AND ALSO MAKE IT RUN IN 4 PLANES.        THE MENU WAS WRITTEN ON 16-6-90, I EXPECT THE SCROLL ROUTINE WILL APPEAR ON OTHER CREWS MENUS PRETTY SOON AS EVERYONE STEALS FROM EACH OTHER (DID YOU HEAR THAT OBERJE?)    IF YOU'RE INTO PROGRAMMING THEN GET A LOAD OF THIS... I WROTE A VERSION OF THIS SINE SCROLL THAT CHANGED THE WAVEFORM EVERY 2 PIXELS, THE EFFECT IS EXCELLENT BUT IT TAKES A LOT OF PROCESSOR TIME...    THE RESULT WAS A SLIGHT CLIPPING ON THE RIGHT HAND SIDE OF THE SCREEN WHERE THE RASTER WAS OVER RUNNING THE SCROLL.  IF I RE-WRITE THE CRAPPY ROXL SCROLL ROUTINE AND OPTIMISE THE SINE ROUTINE THEN I MAY BE ABLE TO USE IT ON A FUTURE DISC (I'D ALSO HAVE TO GET A DIFFERENT TUNE AS THIS ONE TAKES UP LOADS OF CYCLES!) - IF YOU'RE NOT INTO PROGRAMMING THEN YOU PROBABLY WON'T HAVE UNDERSTOOD A WORD SO THERE IS ONLY ONE ANSWER - LEARN 68000 ASSEMBLY LANGUAGE NOW.              I'VE JUST PLAYED LEAVIN TERAMIS BY SOME FOREIGN CREW (WHO ALSO WRITE DEMOS) AND I THOUGHT I RECOGNIZED THE STYLE OF THE TUNE, IT WAS WRITTEN BY MAD MAX AND IS PRETTY GOOD.     IF YOU'RE CAN HACK FILES, THEN DEPACK THIS ONE AND LOOK THROUGH THE CODE UNTIL YOU FIND THE TUNE 'COS IT'S GOT A CONTACT PHONE NUMBER FOR MAD MAX (WELL HIS BOSS'S PHONE NUMBER).              THIS IS MY 22ND DISC IN 8 MONTHS - NOT BAD SEEING I ONLY SUSSED OUT HOW TO PACK DATA FILES SOME 6 MONTHS AGO.   P.O.V. HAS BEEN GOING FOR JUST OVER 12 MONTHS, THE FIRST DISC WAS RELEASED WHEN AUTOMATION WERE ON DISC 48 (I SHOULD KNOW 'COS I RIPPED THE TUNE OUT OF IT).     I DIDN'T HAVE A HALF DECENT PACKER IN THOSE DAYS BUT I SURVIVED ON ONE THAT I HAD WRITTEN (LET IT REST IN PEACE!).      ONE I GOT THE JON PACKER, I WAS OFF.  A QUICK BIT OF CODE RIPPING AND THERE YOU HAVE IT, A DATA FILE DEPACKER... THING WAS THAT I DIDN'T KNOW HOW TO INTERCEPT THE LOAD ROUTINE IN THOSE DAYS SO I WAS BUGGERED.    BUT ONE DAY IT CAME TO ME IN A FLASH WHEN I WAS READING THE 'CONCISE 68000 REFERENCE MANUAL' AND THE NEXT DAY -  WHAM!!  IT WAS DONE.     I HAD A FEW PROBLEMS TRYING TO WORK OUT THE STACK VALUES BUT I MADE IT IN THE END.   I USED THAT ROUTINE UNTIL RECENTLY WHEN I RECEIVED A COPY OF THE 2.3R PACKER, SO I RIPPED A DEPACK ROUTINE FROM WAS (NOT WAS) AND BOLTED IT INTO MY LOAD INTERCEPTION ROUTINE AND AFTER 2 REVISIONS HERE IT IS.    IN THE OLD DAYS I USED TO LOAD DEMOS USING A CRAPPY ROUTINE HELD WITHIN THE MENU UNTIL BORIS HAD AN IDEA OF USING A REMOTE LOADER, I QUICKLY RATTLED UP A PIECE OF CODE TO DO THE TRICK AND THE 'AUTO-RUN' METHOD WAS MADE - THIS FIRST APPEARED ON DISC 15.     ONE HEADACHE I USED TO HAVE WAS THAT SOME DEMOS WOULD NOT RUN IN HALF A MEG WHEN THE MENU EXECUTED THEM. THE REASON BEING THAT GEM IS A BASTARD FOR NOT RELEASING MEMORY WHEN YOU TELL IT TO HOWEVER, USING THE AUTO-RUN METHOD I RARELY HAVE ANY PROBLEMS.         OH YES, I THOUGHT I'D JUST TELL YOU THAT THESE DISCS ARE A HOBBY. I HAVE A FULL TIME JOB WORKING AS A DATA COMMUNICATIONS ENGINEER (I INSTALL ETHERNET EQUIPMENT (DECSERVERS, ETC.), TERMINALS, PRINTERS, MODEMS, FIBRE OPTIC REPEATERS/BRIDGES, MULTIPLEXORS AND A WHOLE HOST OF OTHER BITS AND BOBS, I ALSO GET THE COMMS SOFTWARE GOING ON PC'S BECAUSE ALL THE SOFTWARE BOYS WHERE I WORK ARE A BUNCH OF WANKERS AND KNOW NOTHING (AND TO THINK, THEY TURNED ME DOWN WHEN I APPLIED TO BE A PROGRAMMER - WHAT A LOAD OF LOSERS).         ARE THERE ANY BIKERS OUT THERE?     YES?     ARE ANY OF YOU FEMALE?     WOULD YOU LIKE TO MEET A MALE BIKER WHO RUNS ABOUT ON A Z650 (WITH MANY MODIFICATIONS)?      WHAT DO YOU MEAN NO?      LOOK, I MAY NOT BE THE MOST HANDSOME HUNK AROUND BUT MY BIKE GOES LIKE A ROCKET ONCE IT HITS 7000 RPM!      IF YOU LIVE IN THE BLACKPOOL AREA, THEN LOOK OUT FOR A VERY NOISY GREEN Z650 FLYING AROUND ON SATURDAYS 'COS IT'LL BE ME! (DON'T TRY AND STOP ME 'COS I NEARLY KILLED 3 OLD WOMEN WHO DID THAT NEAR THE BUS STATION ONE DAY!) HE-HE.         WHAT DO YOU CALL A VOLVO DRIVER WHO PULLS STRAIGHT OUT IN FRONT OF YOU WHEN YOU'RE ON YOUR BIKE?     YOU CAN CALL HIM ANYTHING 'COS ALL VOLVO DRIVERS ARE IGNORANT BASTARD WHO DON'T GIVE A SHIT WHAT THEY DO.  (QUITE A FEW HAVE GOT LARGE DINTS IN THEIR DRIVERS SIDE DOORS WHERE I KICKED THEM WHENEVER THEY PULL OUT ON ME - GOD I HATE DRIVERS WHO DON'T LOOK.)     THERE ARE OTHER DRIVERS WHO DESERVE TO DIE, THEY'RE THE ONES WHO GET READY TO PULL OUT FROM A GARAGE AND EVEN THOUGH THERE IS A HUGE GAP IN THE TRAFFIC BETWEEN THE CAR IN FRONT AND ME, THEY ALWAYS WAIT UNTIL I'M ABOUT 20 METERS AWAY UNTIL THEY PULL OUT.... AND WHENEVER THAT HAPPENS I PULL UP ALONG SIDE AND GIVE THEM THE TWO FINGER TREATMENT! (AND I DON'T MEAN THE VICTORY SIGN!).         WELL I THINK I'VE WAFFLED ON FOR FAR TOO SERIOUSLY LONG BY HALF, SO I'LL SAY BYE AND SEE YOU ON DISC 24 ..................                                               "
Global scroll2$=scroll$					;make a copy of the string
Global speed=4,letter=1,xmove=640,tlen=Len(scroll$)
#cut=8							;width of each bendy slice 
Global pausetimer,maxpause=4000				;4 second delay when encountering the '@' symbol
Global borderwidth=(800-640)/2				;accuracy for a 800x600 screen
Global border=CreateSprite(#PB_Any,80,600)		;left and right borders for accuracy! ;-)
Global vusprite=CatchSprite(#PB_Any,?vumeter)		;ripped vu bar sprite
Global logo=CatchSprite(#PB_Any,?pov)			;big main logo and menu
Global logoimg=CatchImage(#PB_Any,?pov)			;also as an image for the fade in 
Global offset=40					;vertical offset for top and bottom border accuracy fro a 800x600 screen
Global xfade=0,ystep=3,frame				;fade in variables
;}

Procedure wobblescroller()

For x=0 To 640/#cut								;width of the scroller divided by the width of each vertical slice
	ClipSprite(scrollimg,x*#cut,0,#cut,34)					;clip the sprite into 8 pixel wide slices
	ysine(x)\index+1							;next y index position
	If ysine(x)\index>datlen						;reached maximum?
		ysine(x)\index=0						;reset it
	EndIf
	incindex=ysine(x)\index							;get the index 
	newy=ysine(incindex)\ypos*2						;read the stored value from the array
	ClipSprite(rasterimg,0,newy,#cut,34)					;get a portion of the raster sprite at the correct height
	DisplayTransparentSprite(rasterimg,borderwidth+x*#cut,newy+190+offset)	;and draw it directly on the screen in the correct postion
	DisplayTransparentSprite(scrollimg,borderwidth+x*#cut,newy+190+offset)	;draw the clipped sprite portion in the new y postition (raster will show through from the back)
Next x

EndProcedure

Procedure scroller()
If pausetimer>0										;are we currently paused?
	Goto showsprite									;yes, so just display the scroller sprite that already exists
EndIf
	
	StartDrawing(SpriteOutput(scrollimg))						;draw on our scroller sprite strip
	For l=0 To (640/32)+2								;1 letter either side of the screen
		If Mid(scroll$,letter+l,1)="@"						;is it the pause character?
			pausetimer=ElapsedMilliseconds()				;start the timer
			ReplaceString(scroll$,"@"," ",#PB_String_InPlace,letter+l-1,1)	;replace the character so we dont read it again
		EndIf	
		tval=Asc(Mid(scroll$,letter+l,1))-32					;calc ascii value of next letter
		
		If tval>=0								;only valid characters
			tmpimg=GrabImage(ripfont,#PB_Any,tval*32,0,32,34)		;grab a letter
			If IsImage(tmpimg)						;is it valid?
				DrawImage(ImageID(tmpimg),xmove+(l*32),0)		;draw it on the scroller sprite
				FreeImage(tmpimg)					;free the temp image
			EndIf
		EndIf
	Next l
	StopDrawing()
	
	xmove-speed:If xmove=-64:xmove=-32:letter+1:EndIf				;move the scroller left
	If letter=tlen:letter=1:xmove=640: scroll$=scroll2$:EndIf			;scroll end, copy back the original string with the pause characters in
	
showsprite:	
DisplaySprite(bottomraster,borderwidth,444+offset)					;blue raster
DisplayTransparentSprite(scrollimg,borderwidth,444+offset)				;scroller on top

wobblescroller()									;bendy scroller with raster
	
If ElapsedMilliseconds()-pausetimer>maxpause						;pause timer reached?
	pausetimer=0									;reset the timer
EndIf
	
EndProcedure

Procedure vubars()
	
	vulen.f=238/15			;length of each bar per volume.  Sprite width/maximum volume
	
	;read channel volumes. 0-15
	v0=OSMEGetVU(0)
	v1=OSMEGetVU(1)
	v2=OSMEGetVU(2)
	
	;clip the sprite the correct length for the volume of each channel starting at the top bar.
	
	;left side
	ClipSprite(vusprite,0,0,vulen*v0,8)
	DisplayTransparentSprite(vusprite,borderwidth,444+36+offset,255,RGB(0,224,0))
	
	ClipSprite(vusprite,0,0,vulen*v1,8)
	DisplayTransparentSprite(vusprite,borderwidth,444+36+12+offset,255,RGB(0,128,0))
	
	ClipSprite(vusprite,0,0,vulen*v2,8)
	DisplayTransparentSprite(vusprite,borderwidth,444+36+24+offset,255,RGB(0,64,0))
	 
	
	;right side
	ClipSprite(vusprite,238-(vulen*v0),0,vulen*v0,8)
	DisplayTransparentSprite(vusprite,(800-borderwidth)-(vulen*v0),444+36+offset,255,RGB(0,224,0))
	
	ClipSprite(vusprite,238-(vulen*v1),0,vulen*v1,8)
	DisplayTransparentSprite(vusprite,(800-borderwidth)-(vulen*v1),444+36+12+offset,255,RGB(0,128,0))
	
	ClipSprite(vusprite,238-(vulen*v2),0,vulen*v2,8)
	DisplayTransparentSprite(vusprite,(800-borderwidth)-(vulen*v2),444+36+24+offset,255,RGB(0,64,0))
	
	
EndProcedure

Procedure fadeinlogo()
	;very bad fade in similar to the original, but not quite.  Does the job though!
	If IsSprite(99)=0
		ClearScreen(RGB(0,0,1))	;almost black
		GrabSprite(99,0,0,640,440)
		TransparentSpriteColor(99,RGB(0,0,1))
	EndIf
	
	frame+1
	If frame<5:ProcedureReturn :EndIf
	If xfade=640: DisplayTransparentSprite(logo,borderwidth,offset): ProcedureReturn :EndIf
	
	StartDrawing(SpriteOutput(99))
		tmpimg=GrabImage(logoimg,#PB_Any,xfade,0,32,440)
		yfade=18
		For y=6 To 600 Step 32
			DrawImage(ImageID(tmpimg),xfade,0)		;vertical 32px wide pov strip
			Box(xfade+10,y,32,yfade,0)
			yfade-1
		Next y
		FreeImage(tmpimg)
	StopDrawing()
	frame=0
	xfade+32
EndProcedure

OSMEPLay(?music,?musend-?music,2)		;play the music


Repeat	
	w=WindowEvent()
	ClearScreen(0)
	
	fadeinlogo()
		
	If xfade<640
		DisplayTransparentSprite(99,borderwidth,40)
		Else
	DisplayTransparentSprite(logo,borderwidth,40)
	EndIf
	
	scroller()
	vubars()
	
	DisplaySprite(border,0,0)
	DisplaySprite(border,720,0)
	
	FlipBuffers()
Until GetEsc()
OSMEStop()
End


DataSection
	vumeter: :IncludeBinary"gfx\greenbar.bmp"
	font: : IncludeBinary"gfx\font.bmp"			;ripped font
	blueraster: :IncludeBinary"gfx\blueraster.bmp"		;bottom scroll raster
	raster: :IncludeBinary"gfx\raster.bmp"			;central bendy scroll raster
	pov: :IncludeBinary"gfx\pov.bmp"			;big logo and menu
	music: :IncludeBinary"sfx\dugger.sndh"			;ripped chiptune
	musend:
	dat: : IncludeBinary"sine.dat"				;bendy sine data ripped from the  ST .prg file
	datend:
EndDataSection

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 9
; Folding = A-
; EnableXP
; UseIcon = Atari.ico
; Executable = POV_23.exe
; DisableDebugger
; IncludeVersionInfo
; VersionField0 = 1
; VersionField1 = 1
; VersionField2 = KrazyK
; VersionField3 = POV Menu CD 23 Win32 Remake
; VersionField4 = 1
; VersionField5 = 1
; VersionField6 = POV Menu CD 23 Win32 Remake
; VersionField7 = POV Menu CD 23 Win32 Remake
; VersionField8 = POV_23.exe
; VersionField9 = KrazyK
; VersionField10 = KrazyK