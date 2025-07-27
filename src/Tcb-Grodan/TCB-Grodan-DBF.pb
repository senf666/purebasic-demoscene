;THE CAREBEARS  - GRODAN AND KVACK KVACK DEMO

;CODE:		JAS,NICK
;GFX:		TANIS
;MUSIC:		BLAIZER
;REMAKE:	KRAZYK 2019

;This code was adapted for PureBasic from the excellent WAB.com codef remake by NewCore.


UsePNGImageDecoder()
InitSprite()
InitSound()

Global fs=0		;0=windowed ,  =fullscreen

Global xres=640,yres=480
Global offset,imgy=16*12,imgx=16*11

demo$="THE CAREBEARS  - GRODAN AND KVACK KVACK DEMO"


If fs=0
	yres=400
	offset=0
	OpenWindow(1,0,0,xres,yres,demo$,#PB_Window_ScreenCentered|#PB_Window_WindowCentered|#PB_Window_BorderLess)
	OpenWindowedScreen(WindowID(1),0,0,xres,yres,0,0,0)
	StickyWindow(1,1)
ElseIf 	fs=1
	offset=40
	OpenScreen(xres,yres,32,demo$)
Else 
	End
EndIf

SetFrameRate(60)

;decalre our image and sprites
Enumeration
	#bgimage
	#bg2image
	#uprasterimage
	#bsrasterimage
	#spriteimage
	#bsfont
	#upfonts
	#lfont
EndEnumeration

;load all images and sprites
CatchImage(#bgimage,?bgimage)
CatchImage(#bg2image,?bg2image)
CatchImage(#uprasterimage,?uprasterimage)
CatchImage(#bsrasterimage,?bsrasterimage) : ResizeImage(#bsrasterimage,640,128)
CatchSprite(#spriteimage,?spriteimage)
CatchImage(#bsfont,?bsfont)
CatchImage(#upfonts,?upfonts)
CatchImage(#lfont,?lfont)

;{ background movement and sprite variables

Global  moveY = 0;
Global  howmuchY = 1;
Global  moveX = 0;
Global  howmuchX = 1;
Global  bgcount.f = 0;

Global  Y = 0;
Global  hY = 1;
Global  X = 0;
Global  gox = 0;

Global 	ychange.f = 0;
Global  addy.f = 0.1;
Global  sinx.f = 0;
Global  siny.f = 0;
Global  swing.f = 0;
Global  swingy.f = 0;
Global  spx.f = 304;
Global  spy.f = 100;
		   ;}

;{ create some images To draw the backgrounds And scrollers on

Global bgimage=CreateSprite(#PB_Any,640*3,400*2) 
Global bg2image=CreateSprite(#PB_Any,640*3,400*2)
Global scrollimage=CreateImage(#PB_Any,640,imgy)
Global upimage=CreateImage(#PB_Any,32,400)
Global limage=CreateImage(#PB_Any,320,8)
Global l2image=CreateImage(#PB_Any,320,8)
Global border=CreateSprite(#PB_Any,640,40)
;}

;{ Init bg1 & bg2
;draw multiple images to create the large moving backgrounds
StartDrawing(SpriteOutput(bgimage))
        DrawImage(ImageID(#bgimage),0,0)
        DrawImage(ImageID(#bgimage),640,0)
        DrawImage(ImageID(#bgimage),640*2,0)
        DrawImage(ImageID(#bgimage),0,400)
        DrawImage(ImageID(#bgimage),640,400)
        DrawImage(ImageID(#bgimage),640*2,400)
StopDrawing()
;Init bg2
StartDrawing(SpriteOutput(bg2image))
        DrawImage(ImageID(#bg2image),0,0)
        DrawImage(ImageID(#bg2image),640,0)
        DrawImage(ImageID(#bg2image),640*2,0)
        DrawImage(ImageID(#bg2image),0,400)
        DrawImage(ImageID(#bg2image),640,400)
        DrawImage(ImageID(#bg2image),640*2,400)
StopDrawing()
;}

;{ scrollers  setup

;draw on bsimage using #upfont
Global scrolltext1$=Space(80)+"                                 HI AND WELCOME TO THE GRODAN AND KVACK KVACK DEMO (THAT NAME WILL PROBABLY MAKE US FAMOUS IN THE GUINNESS BOOK OF RECORDS - THE MOST STUPID NAME IN DEMO HISTORY.  THE PREVIOUS POSSESSORS OF THAT RECORD WAS OMEGA WITH -OMEGAKUL-.   I'M AFRAID WE WILL SOON BE BEATEN BY SYNC'S 'MJOFFE-DEMO', WITH TWO DOTS ABOVE THE 'O'.  DID YOU KNOW THAT THIS IS A COMMENT IN THE MIDDLE OF A SENTENCE? NO?  WE ALSO FORGOT, BUT LET'S CONTINUE WITH WHAT WE WERE WRITING BEFORE WE STARTED WRITING THIS RECORD-CRAP.), CODED BY NICK AND JAS OF THE CAREBEARS. GRAPHIXXXX BY TANIS, THE GREAT (?) OF THE MEGAMIGHTY CAREBEARS.        WE HAVE TO COVER TWO SUBJECTS IN THIS SCROLLTEXT - THE FANTASTIC WORLD OF HARDWARESCROLLERS  AND  GREETINGS....   LET'S START WITH THE STUFF YOU PROBABLY WANT US TO TALK THE MOST ABOUT - HARDWARESCROLLERS....        TIME: LATE MARCH 1989    PLACE: NICK'S COMPUTER ROOM     IT WORKS!!!!!!!  AFTER HAVING TRIED THE ZANY SCROLLTECHNIQUE ON BOTH NICK'S AND JAS' COMPUTERS, WE CONCLUDED THAT IT ACTUALLY WORKED.    ONE DAY LATER, OMEGA CALLS US AND GOES SOMETHING LIKE THIS: - HAAAA HAAAA  WE KNOW HOW TO SCROLL THE WHOLE SCREEN BOTH HORIZONTALLY AND VERTICALLY IN LESS THAN TEN SCANLINES!!!!!!         WE WERE AMAZED THAT THEY HAD ACTUALLY COME UP WITH THE SAME IDEA ON THE SAME DAY AS US, BUT AT LEAST NOBODY ELSE KNEW HOW TO DO IT.     WE MANAGED TO RELEASE THE FIRST HARDWARESCROLLER THE WORLD HAS SEEN, IN THE CUDDLY DEMOS, AND NOW WE ARE GOING TO USE IT COMERCIALLY (CODING GAMES, DICKHEAD)....     NOW A HINT HOW IT'S DONE:    IT HAS NOTHING TO DO WITH ANY OF THE SOUND-REGISTERS.....         HERE IS ANOTHER ADDRESS TO THE CAREBEARS:     T H E   C A R E B E A R S ,    D R A K E N B E R G S G   2 3    8 T R ,      1 1 7   4  1   S T O  C K H O L M ,     S W E  D E N .                NOW FOR SOME GREETINGS:   MEGADUNDERSUPERDUPERGREETINGS TO  ALL THE OTHER MEMBERS OF THE UNION, ESPECIALLY THE EXCEPTIONS (TANIS WISH TO GIVE A SPECIAL HI TO ES) AND THE REPLICANTS (GOODBYE, RATBOY! YOUR INTROS WERE GREAT).   NORMAL MEGAGREETINGS (IN MERIT-ORDER)(WOW) TO   SYNC (WE'VE CHANGED OUR MINDS, YOU'RE THE SECOND BEST SWEDISH CREW. WE JUST HADN'T SEEN MANY SCREENS BY YOU GUYS (IT'S UNDERSTANDABLE - YOU HAVE ONLY RELEASED THREE NOT VERY GOOD ONES)),  OMEGA (TOO BAD, YOU'RE NOT THE SECOND BEST ANYMORE.  PERHAPS IT HAS SOMETHING TO DO WITH  THE TERA-DISTER, THE 'TCB-E'-JATTEDUMMA'-SIGN OR THE FACT THAT SYNC IS BETTER), THE LOST BOYS (SEE YA' SOON AND WE'RE ANXIOUSLY AWAITING YOUR MEGAMEGADEMO)             SOMETHING BETWEEN MEGAGREETINGS AND NORMAL GREETINGS TO:   FLEXIBLE FRONT (GOODBYE), VECTOR (SO YOU CRACKED OUR DEMO, HUH? NICE SCREEN, BY THE WAY), GHOST (SO YOU TRIED TO CRACK OUR DEMO, HUH? GREAT SCREEN, BY THE WAY), 2 LIFE CREW (YOU ARE IMPROVING), MAGNUM FORCE (YOU SEEM TO BE THE BEST OPTIMIZERS IN FRANCE!), NORDIK CODERS (NICE SCREEN).   NORMAL GREETINGS TO:  FASHION (GOOD LUCK WITH YOUR DEMO), OVERLANDERS (THANKS FOR NOT INCLUDING CUDDLY IN YOUR DEMOBREAKER), NO CREW (ESPECIALLY ROCCO. YOU ARE IMPROVING), AUTOMATION (GREAT COMPACT DISKS), MEDWAY BOYS (NICE CD'S),  ST CONNEXION (HOPE YOUR DEMO WILL BE AS GOOD AS YOUR GRAPHICS), FOXX (COOL SCREEN), FOFT (KEEP ON COMPACTING), ZAE (WE HAD A GREAT TIME IN MARSEILLE), KREATORS (ESPECIALLY CHUD), M.A.R.K.U.S (PLEASE SPREAD THIS DEMO AS MUCH AS YOU SPREAD CUDDLY DEMOS), HACKATARIMAN (THANKS FOR ALL THE STUFF), THE ALLIANCE (ESPECIALLY OVERLANDERS (THANKS FOR TCB-FRIENDLY SCROLLTEXTS AND MANY NICE SCREENS), AND BLACK MONOLITH TEAM (YOUR DEMOSCREEN WAS THE BEST IN THE OLD ALLIANCE DEMO), BIRDY (SEND US YOUR CRACKS), LINKAN 'THE LINK' 'JUDGE LINK' LINKSSON (PING-PONG), NYARLOTHATEPS ADEPTS (STRANGE NAME, STRANGE GUYS), GROWTWIG ( NO COMMENT),  TONY KOLLBERG (TJENA, LYCKA TILL MED ASSEMBLERN)     END OF GREETINGS. IF YOU WERE NOT GREETED, TOO BAD. NORMAL FUCKING GREETINGS TO:  CONSTELLATIONS (NOONE WILL EVER COMPLAIN ABOUT TCB AND GET AWAY WITH IT, BESIDES YOUR DEMO WAS WORTHLESS). MEGA FUCKING GREETINGS TO:     MENACING CRACKING ALLIANCE (SO, YOU DON'T LIKE BEING CALLED LAMERS, HOW YA' LIKE BEING CALLED:       MOTHERFUCKIN'   BLEEDIN' (BRITTISH ENGLISH) ULTIMATE CHICKENBRAINS????!!!! I BET IT'S ALMOST AS FUN AS FUCKING GREET TCB).  END OF SCROLLTEXT. LET'S WRAP."
Global len1=Len(scrolltext1$)
Global letter1=1
Global scrollx=0

;draw on upimage using #upfont with raster
Global scrolltext2$=Space(10)+"                           TANIS, THE FAMOUS GRAFIXX-MAN, IS A NEW MEMBER OF TCB.  HE MADE ALL THE GRAPHICS IN THIS SCREEN PLUS LOTSA LOGOS IN THE MAIN MENU.  WE AGREE THAT THIS 'ONE-BIT-PLANE-MANIA' DOESN'T LOOK VERY GOOD, BUT IT HAD TO BE DONE BY SOMEONE........   BAD LUCK FOR TANIS THAT WE WON'T MAKE MORE DEMOS, THOUGH....       9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9  ..................                 LET'S WRAP (WE SPELLED IT CORRECTLY!!!).......   "
Global len2=Len(scrolltext2$)
Global letter2=1
Global scrolly=0

;top small scrolltext
;draw on limage using lfont
Global scrolltext3$=Space(90)+"ONCE UPON A TIME, WHEN THE JUNK DEMO WAS ALMOST FINISHED - WHEN THE BEST DEMO ON THE ST-MARKET WAS 'LCD' BY TEX, WE VISITED IQ2-CREW (AMIGA-FREAKS). THEY SHOWED US A COUPLE OF DEMOS AND ONE OF THEM WAS THE TECHTECH-DEMO BY SODAN AND MAGICIAN 42. KRILLE AND PUTTE LAUGHED AT US AND SAID THAT IT WAS TOTALLY IMPOSSIBLE TO MAKE ON AN ST. WE STUDIED IT FOR HALF AN HOUR AND SAID: -OF COURSE IT'S POSSIBLE.   WHEN WE WERE BACK HOME (WHEN NO AMIGA-OWNER WAS LISTENING), WE CONCLUDED THAT THERE WAS SIMPLY TOO MUCH MOVEMENT FOR AN ST.        NOW, WE HAVE CONVERTED IT ANYWAY. THE AMIGA VERSION HAD SOME UGLY LINES WHIZZING AROUND, BUT WE HAVE 3 VOICE REAL DIGISOUND AND SOME UGLY SPRITES. BESIDES, WE HAVE SOME TERRIBLE RASTERS.......            WE AGREE THAT THERE ARE BETTER AMIGA-DEMOS NOW, AND PERHAPS WE WILL CONVERT SOME MORE IN THE FUTURE.......     LET'S WRAZZZZZZZ................"
Global len3=Len(scrolltext3$)
Global letter3=1
Global scrollx3=0


;2nd small scrolltext
;draw on l2image using #lfont
Global scrolltext4$=Space(80)+"EVERYBODY THOUGHT IT WAS IMPOSSIBLE.....                                     EVEN WE THOUGHT IT WAS IMPOSSIBLE......                                       IT'S A PITY IT WASN'T.....                                                 THE CAREBEARS PRESENT THE UGLIEST DEMO SO FAR - THE GRODAN AND KVACK KVACK DEMO, A CONVERSION OF THE STUNNING TECHTECH DEMO BY SODAN AND MAGICIAN 42 (ON THE COMPUTER THAT CRASHES WHEN YOU ENTER SUPERVISOR MODE IN SEKA).   IT WAS UGLY ON THE AMIGA TOO, BUT IT SURE KNOCKED YOU OFF THE CHAIR WHEN YOU SAW IT THE FIRST TIME.    "
Global len4=Len(scrolltext4$)
Global letter4=1
Global scrollx4=0

;}

Procedure bg1()
  bgcount+0.1;
  If(moveY<-400)
	  howmuchY=1;
	EndIf
	
  If(moveY>0)
	  howmuchY=-1;
	EndIf
	
  moveY+howmuchY;

	If (bgcount>10)
	        If(moveX<-640*2)
                        howmuchX=16;
        EndIf
			
   If(moveX>0)
           howmuchX=-16;
   EndIf
   

   moveX+howmuchX;
 EndIf   
	
	If (bgcount>20)
	        bgcount=0;
	EndIf
	
DisplayTransparentSprite(bgimage,movex,movey+offset,255,RGB(64,96,32))
	
        
EndProcedure

Procedure bg2()
  If(Y<-400)
	  hY=2;
	  gox=16;
  EndIf
	
			
  If(Y>0)
	  hY=-2;
	  gox=-16;
  EndIf

	X+gox;

  If(X<-710)
          X=-710; 	
  EndIf
  

  If(X>0)
          X=0; 	
  EndIf
  
					
  Y+hY;

  DisplayTransparentSprite(bg2image,x,y+offset,255,RGB(160,96,160))

 EndProcedure
 
 Procedure Sprites()
 ;THE CAREBEARS smoving sprites        
If(ychange>50)
	  addy=-0.1;
EndIf
	
If(ychange<-50)
	  addy=0.1;
EndIf
	
ychange+addy;

swing + 0.02;
swingy + 0.03;
siny=ychange*Sin(swingy);      
spcol=RGB(0,224,224)

ClipSprite(#spriteimage,0,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing),spy+ychange*Sin(swingy)+siny+offset,255,spcol)
ClipSprite(#spriteimage,33,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing-0.2),spy+ychange*Sin(swingy-0.2)+siny+offset,255,spcol)
ClipSprite(#spriteimage,67,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing-0.4),spy+ychange*Sin(swingy-0.8)+siny+offset,255,spcol)
ClipSprite(#spriteimage,101,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing-0.8),spy+ychange*Sin(swingy-0.8)+siny+offset,255,spcol)
ClipSprite(#spriteimage,134,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing-1.0),spy+ychange*Sin(swingy-1.0)+siny+offset,255,spcol)
ClipSprite(#spriteimage,168,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing-1.2),spy+ychange*Sin(swingy-1.2)+siny+offset,255,spcol)
ClipSprite(#spriteimage,202,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing-1.4),spy+ychange*Sin(swingy-1.4)+siny+offset,255,spcol)
ClipSprite(#spriteimage,236,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing-1.6),spy+ychange*Sin(swingy-1.6)+siny+offset,255,spcol)
ClipSprite(#spriteimage,270,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing-1.8),spy+ychange*Sin(swingy-1.8)+siny+offset,255,spcol)
ClipSprite(#spriteimage,305,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing-2.0),spy+ychange*Sin(swingy-2.0)+siny+offset,255,spcol)
ClipSprite(#spriteimage,338,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing-2.2),spy+ychange*Sin(swingy-2.2)+siny+offset,255,spcol)
ClipSprite(#spriteimage,372,0,32,20) : DisplayTransparentSprite(#spriteimage,spx+290*Cos(swing-2.4),spy+ychange*Sin(swingy-2.4)+siny+offset,255,spcol)

         
 EndProcedure
 
 Procedure bigscroll()
 	
hdc=StartDrawing(ImageOutput(scrollimage))
            DrawImage(ImageID(#bsrasterimage),0,0,640,imgy)
                 For l=0 To 6
                         tval=Asc(Mid(scrolltext1$,letter1+l,1))-32
                        tx = (tval % 10)*24
		        ty=(tval-(tval%10))  /10*33
		        GrabImage(#bsfont,10,tx,ty,24,32)
		        ResizeImage(10,imgx,imgy)
		        KK_DrawTransparentImage(hdc,10,scrollx+(l*imgx),0,#White)
	        Next l
StopDrawing()
		
scrollx-16:If scrollx=-(imgx*2):scrollx=-imgx:letter1+1:EndIf
If letter1>len1:letter1=1:scrollx=0:EndIf
		
hdc=StartDrawing(ScreenOutput())
        KK_DrawTransparentImage(hdc,scrollimage,0,200+offset,0)
StopDrawing()
         
         
         
 EndProcedure
 
 Procedure lscroll()
 	
 	hdc=StartDrawing(ImageOutput(limage))
 	DrawImage(ImageID(#uprasterimage),0,-8)	;draw part raster image on the scroll image
 	For l=0 To 42
 		tval=Asc(Mid(scrolltext3$,letter3+l,1))-32
 		tx = (tval % 10)*8
		ty=(tval-(tval%10))  /10*8
		GrabImage(#lfont,10,tx,ty,8,8)
		KK_DrawTransparentImage(hdc,10,scrollx3+(l*8),0,#White)
 	Next l
 	StopDrawing()
 	ResizeImage(limage,640,16)
 	scrollx3-1 : If scrollx3=-16:scrollx3=-8:letter3+1:EndIf
 	If letter3>len3:letter3=1:scrollx3=0:EndIf
 	
 	hdc=StartDrawing(ScreenOutput())
 		KK_DrawTransparentImage(hdc,limage,0,16+offset,0)
 	StopDrawing()
 	ResizeImage(limage,320,8)
 	
 	hdc=StartDrawing(ImageOutput(l2image))
 	DrawImage(ImageID(#uprasterimage),0,-32)	;draw part raster image on the scroll image
 	For l=0 To 42
 		tval=Asc(Mid(scrolltext4$,letter4+l,1))-32
 		tx = (tval % 10)*8
		ty=(tval-(tval%10))  /10*8
		GrabImage(#lfont,10,tx,ty,8,8)
		KK_DrawTransparentImage(hdc,10,scrollx4+(l*8),0,#White)
 	Next l
 	StopDrawing()
 	
 	ResizeImage(l2image,640,16)
 	scrollx4-2 : If scrollx4=-16:scrollx4=-8:letter4+1:EndIf
 	If letter4>len4:letter4=1:scrollx4=0:EndIf
 	
 	hdc=StartDrawing(ScreenOutput())
 		KK_DrawTransparentImage(hdc,l2image,0,64+offset,0)
 	StopDrawing()
 	ResizeImage(l2image,320,8)
 	
 	
 	
 	
 	
 	
 	
 	
 	
 EndProcedure
 
 Procedure upscroll()
 	hdc=StartDrawing(ImageOutput(upimage))
 	DrawImage(ImageID(#uprasterimage),0,0,32,400)		;draw part raster image on the scroll image
 	
 	fh.f=26
 	For l=0 To 17
 		tval=Asc(Mid(scrolltext2$,letter2+l,1))-32
 		tx = (tval % 10)*32
		ty=(tval-(tval%10))  /10*fh
		GrabImage(#upfonts,10,tx,ty,32,fh)
		KK_DrawTransparentImage(hdc,10,0,scrolly+(l*fh),#White)
 	Next l
 	StopDrawing()
 	
 	scrolly-2 : If scrolly=-(fh*2):scrolly=-(fh*1):letter2+1:EndIf
 	If letter2>len2:letter2=1:scrolly=0:EndIf
 	
;draw multiple vertical raster scrollers on the screen 	
 	hdc=StartDrawing(ScreenOutput())
  		KK_DrawTransparentImage(hdc,upimage,0,offset,0)
 		KK_DrawTransparentImage(hdc,upimage,64,offset,0)
 		KK_DrawTransparentImage(hdc,upimage,128,offset,0)
 		KK_DrawTransparentImage(hdc,upimage,480,offset,0)
 		KK_DrawTransparentImage(hdc,upimage,544,offset,0)
 		KK_DrawTransparentImage(hdc,upimage,608,offset,0)
	StopDrawing()
 	
 	
 	
 	
 	
 EndProcedure
 
 
CatchMusic(1,?tune,48230) 
PlayMusic(1)

 
Repeat
	ClearScreen(0)
      
	If fs=0:w=WindowEvent()	:EndIf;process window events in windowed mode only
        
        bg1()        
        bg2()
        
        lscroll()
        upscroll()
                
        bigscroll()
        Sprites()
        
        If fs=1:DisplaySprite(border,0,0):DisplaySprite(border,0,400+offset):EndIf	;display borders in fullscreen mode only

        FlipBuffers()
Until GetEsc()
StopMusic(1)


DataSection
bgimage:   :IncludeBinary"gfx\Grodan_green.bmp"
bg2image:   :IncludeBinary"gfx\Grodan_pink.bmp"
uprasterimage:   :IncludeBinary"gfx\upscrollraster.bmp"
bsrasterimage:   :IncludeBinary"gfx\bigscrollraster.bmp"
spriteimage:   :IncludeBinary"gfx\sprite.bmp"
bsfont: :IncludeBinary "gfx\bsfont.bmp"
upfonts: :IncludeBinary "gfx\upfonts.bmp"
lfont: :IncludeBinary "gfx\lfont.bmp"
tune: : IncludeBinary "sfx\ronken.mod"

EndDataSection







; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; CursorPosition = 34
; FirstLine = 30
; Folding = Aw
; EnableXP
; Executable = tcb-grodan.exe
; DisableDebugger
; IncludeVersionInfo