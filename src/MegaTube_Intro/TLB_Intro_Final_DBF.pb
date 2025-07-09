
fs=1

Global offset=0         
If fs=1
  KK_Window(640,400)
  offset=0
Else
  KK_Screen(640,480,32,60)
  offset=40                 ;when in fullscreen you need to offset the y axis by 40 pixels to centre the gfx on screen.  Gotta keep it accurate!
EndIf

KK_InitFlipMode(1)    ;back face culling mode when flipping sprites


;{ Raster bar stuff


DataSection
  redbar:  : IncludeBinary "gfx\redbar.bmp"
  greenbar:  : IncludeBinary "gfx\greenbar.bmp"
  bluebar:  : IncludeBinary "gfx\bluebar.bmp"
EndDataSection

#redbar=200:CatchSprite(#redbar,?redbar):ZoomSprite(#redbar,640,40)
#greenbar=201:CatchSprite(#greenbar,?greenbar):ZoomSprite(#greenbar,640,40)
#bluebar=202:CatchSprite(#bluebar,?bluebar):ZoomSprite(#bluebar,640,40)

Global red_y=120,blue_y=0,green_y=240
Global barstep.f=#PI/360    ;360 pixels in the barrel 

Procedure movebars()
  
;The raster bars move up and down by 360 pixels either in front or behind the barrel scroller.
;1 to 180 is increasing therefore moving down and behind the barrel.
;180 to 359 is decreasing thefore moving up and in front of the barrel.
  
  ;move the bars
  Blue_y+1
  If blue_y=360:blue_y=1:EndIf
    
  red_y+1
  If red_y=360:red_y=1:EndIf
  
  green_y+1
  If green_y=360:green_y=1:EndIf
    
EndProcedure


;}

Procedure Makegrad(img,numcols,addr)
  
  w=ImageWidth(img)
  h=ImageHeight(img)
  pc.f=1/numcols
  
  StartDrawing(ImageOutput(img))
  DrawingMode(#PB_2DDrawing_Gradient)
  col.l=PeekL(addr)
  Debug col.l
  GradientColor(0.0000001,col)
     For i=0 To numcols-1
      col.l=PeekL(addr+(i*4))
      GradientColor(i*pc.f,col)
    Next i
    GradientColor(0.999999,col)
    
    LinearGradient(w/2,0,w/2,h)
    Box(0,0,w,h)
  StopDrawing()
  
  
EndProcedure


;{ Mid scroll stuff
Global midscroll$="               @@@@@@@@@@THE HIP AND GROOVY LOST BOYS (GET DOWN!) IN ASSOCIATION WITH THE DIGITAL INSANITY CORPORATION PRESENT THE MEGATUBE INTRO!!  FOR THE VERY FIRST ISSUE OF THE BRAND NEW LOST BOYS DISK MAGAZINE. ALL CODING AND GRAPHICS ON THIS SCREEN  BY D.I. AND MANIKIN. SOME GRAPHICS BY MANIKIN AND THE REST BY SPAZ. THE LOST BOYS DISK MAGAZINE WILL BE A REGULAR PRODUCTION BY THE LOST BOYS INCLUDING ARTICLES ON MANY AND VARIED TOPICS PLUS REVIEWS OF ALL THE LATEST DEMO'S AND  LOTS OF OTHER STUFF NOT USUALLY COVERED IN THE VARIOUS PAPER MAGAZINES AVAILABLE. THE MAGAZINE IS A CREATION OF SAMMY JOE OF THE LOST BOYS, AND HE WILL BE ASSISTED IN HIS PRODUCTION BY VARIOUS ARTICLE WRITERS AND OF COURSE SPAZ AND MANIKIN THE OTHER TWO LOST BOYS. WELL ENOUGH OF THE SPEAL NOW COMES THE BULLSHIT!!    WELL YOU NOW HAVE IN YOUR POSSESION THE FIRST SCREEN TO BE PRODUCED BY THE LOST BOYS AFTER THE RELEASE OF OUR MIND BOMB DEMO, WHAT YOU DON'T HAVE IT!!!!, THEN WRITE THIS VERY MOMENT TO THE LOST BOYS P.D LIBRARY AT   12 CAMBRIDGE ROAD, TEDDINGTON, MIDDLESEX, ENGLAND  TO ARRANGE FOR A COPY TO BE SENT TO YOU STRAIGHT FROM THE SOURCE!!!  THIS SCREEN IS THE RESULT OF A WAIT AT SCHIPOL AIRPORT FOR A PLANE TO RETURN ME, MANIKIN, HOME FROM HOLLAND AFTER A FUCKING EXCELLENT WEEK IN HOLLAND AND GERMANY WITH STEF THE POST! WE WERE A BIT BORED SO WE STARTED TO DISCUSS FUTURE  IDEAS AND THIS WAS THE RESULT. ALTHOUGH CODED BY MANIKIN OF THE LOST BOYS IT IS DEFINITELY TO BE CONSIDERED A COLLABORATION AS MOST OF THE IDEAS WERE STEFANS AND HE IS MORE THAN CAPABLE OF WRITING IT HIMSELF HE JUST DOESN'T HAVE THE TIME  REACTION TO OUR MINDBOMB DEMO HAS BEEN SWIFT AND MIXED. SOME PEOPLE THINK WE SIMPLY RIPPED THE CUDDLY DEMOS OFF, I CAN SEE WHY THEY MIGHT THINK THAT BUT I CERTAINLY DON'T AGREE,  OTHERS THINK THAT IT IS BRILLIANT SO WHEN YOU SEE IT YOU'LL HAVE TO DRAW YOUR OWN CONCLUSIONS. ONE PROBLEM THAT DOES SEEM TO HAVE CAUSED DIFFICULTY IS COPYING IT.  YOU MUST MAKE A VERY GOOD COPY OF THE DEMO AS THE LOADER IS A LITTLE UNRELIABLE IF THE DISK IS BADLY COPIED, I ADVISE THAT YOU COPY IT WITH A-COPY, ON PROTECTED, OR BLITZ TURBO IF YOU HAPPEN TO POSSESS THIS DEVICE. AND NOW WHAT EVERYONE HAS BEEN WAITING FOR I SHOULD IMAGINE, THE GREETINGS, THESE WILL NOT BE ALL THAT EXTENSIVE SINCE THIS IS NOT A MEGADEMO AND  I DON'T HAVE ALL DAY TO WRITE THIS SCROLLTEXT SO HERE GOES:-        ALL AT THALION SOFTWARE (SEE YA SOON!!), THE CAREBEARS (@), THE EXCEPTIONS, TNT AND TNT CREW, GIGABYTE CREW, REPLICANTS AND ZAE!!! (THIS TIME I GOT IT RIGHT AND YES SORRY DID THINK YOU WERE A REPLICANT!!), INNER CIRCLE (ALL MEMBERS), CONSTELLATIONS, OVERLANDERS (A LITTLE BIRD TELLS ME THAT I SHALL BE SEEING THIS ON ONE OF YOUR DEMO MENUS VERY SOON, PLEASE CARRY ON AND USE IT WE WOULD BE MORE THAN HAPPY!!), BBC (YO GUYS, NICE INTROS IN RECENT TIMES AND ONCE MORE THANKS FOR THE GREAT SCREEN!!!), CHUCK OF FOXX ( GREAT NEW SCREEN MAKE SURE AND SEND ME A COPY WHEN IT IS FINISHED!!), HACK ATARI MAN, EQUINOXE, ST CONNEXION, AUTOMATION, MEDWAY BOYS, HACKBEAR ( YOU CURRENTLY HOLD THE WORLD RECORD TIME FOR MIND BOMB HACKING!!! CONGRATULATIONS!!), OMEGA AND SYNC, DELTA FORCE (THIS WAS GOING TO BE THE SCREEN THAT WE CODED FOR YOUR DEMO COMPETITION BUT SINCE YOU CHANGED  THE DATES AND WE CAN'T COME, IT IS MAKING AN APPEARANCE HERE INSTEAD.), AENIG MATICA (NICE DEMO GUYS!!!), CIA OF GARTAN SIX(HEY GUY HOW'S LIFE?)    WELL THATS ALL THE GREETING I'M AFRAID. IF YOU ARE NOT HERE AND THINK YOU SOULD HAVE BEEN THEN CHECK OUT THE MAIN SCROLLTEXT OF MIND-BOMB AND YOU WILL ALMOST CERTAINLY FIND YOUR NAME SOMEWHERE IN IT!  OK IT'S TIE FOR ME TO LOVE YOU AND LEAVE YOU SO UNTIL THE NEXT LOST BOYS PRODUCT IT'S BYE BYE FROM MANIKIN AND ON WITH THE MAGAZINE!!!! @@@@@@@@@@@           "
midscroll$=UCase(midscroll$)
Global bxmove=-320,bspeed=16,bletter=1,brast_y

#bigback=100
CreateImage(#bigback,640,320)   ;draw the raster and big central scrolltext on here first
#bigrast=101
CreateImage(#bigrast,640,400)
Makegrad(#bigrast,12,?bigfontcols)
#bigfont=102
CatchImage(#bigfont,?big)

Procedure BigScroller()
  
  brast_y-4     ;move the raster background up
  If brast_y<0:brast_y=400:EndIf
  
hdc=StartDrawing(ImageOutput(#bigback))
  DrawImage(ImageID(#bigrast),0,brast_y-400)
  DrawImage(ImageID(#bigrast),0,brast_y)
  
  For i=1 To 4
    t$=Mid(midscroll$,bletter+i,1)
    tval=Asc(Mid(midscroll$,bletter+i,1))-65
    If tval=-1:tval=26:EndIf
    If tval=-2:tval=27:EndIf
    If tval=-32:tval=28:EndIf 
    If tval<0:tval=29:EndIf
    GrabImage(#bigfont,#bigfont+1,0,tval*70,64,70)
    ResizeImage(#bigfont+1,320,320)
    KK_DrawTransparentImage(hdc,#bigfont+1,bxmove+(i*320),0,#White)
  Next i
StopDrawing()
  
  bxmove-bspeed:If bxmove=-640:bxmove=-320:bletter+1:EndIf
  If bletter>Len(midscroll$):bletter=1:bxmove=640:EndIf
  
  hdc=StartDrawing(ScreenOutput())
    KK_DrawTransparentImage(hdc,#bigback,0,64+offset,#Black)
  StopDrawing()
  FreeImage(#bigfont+1) ;keep tidy as pb can sometimes break!!
  
  
EndProcedure

;}

;{ vert scroller stuff

Global vertscroll$="                                    AH YEAH! YET MORE VERTICAL SCROLLINES. THIS IS BEGINNING TO LOOK A BIT LIKE A CROSS BETWEEN OUR SCROLLING MASSACRE DEMO AND  THE KVACK KVACK DEMO FROM SO WATT.  I RECKON IT LOOKS JUST ABOUT AS UGLY ANYWAY!!! THERE IS JUST TO MUCH MOVEMENT ON THIS SCREEN  AND AFTER A WHILE YOU START TO FEEL SICK. BUT MAKE SURE YOU DO NOT VOMIT ON YOUR COMPUTER AS IT DOES NOT DO THEM MUCH GOOD!!!!   BYE FOR THIS SCROLLER!!! ....................................                      "
Global vymove=0,vletter=1,vspeed=4,tube_v=0
Global vstp.f=#PI/9

Structure vgaps
  ysize.f
  gap.f
EndStructure

Global Dim vgaps.vgaps(64)

;calculate some sizes an dgaps for the vertical scrolltext when made in a barrel
For i=0 To 40
  ypos=Abs(68*Sin(vstp*i))
  vgap+ypos
  vgaps(i)\ysize=ypos
  vgaps(i)\gap=vgap
Next i


#vertrast=1
CreateImage(#vertrast,64,800)
Makegrad(#vertrast,3,?vertfontcols) ;create the red/yellow raster
#vrastback=200
CreateImage(#vrastback,64,800)      ;draw the raster ans scrolltext on here first

Procedure VertScroller()
hdc=StartDrawing(ImageOutput(#vrastback))  
  DrawImage(ImageID(#vertrast),0,0)           ;raster background
  For i=1 To 10
    tval=Asc(Mid(vertscroll$,vletter+i,1))-65
    If tval=-1:tval=26:EndIf
    If tval=-2:tval=27:EndIf
    If tval=-32:tval=28:EndIf 
    If tval<0:tval=29:EndIf
    GrabImage(#bigfont,#bigfont+1,0,tval*70,64,70)
    KK_DrawTransparentImage(hdc,#bigfont+1,0,vymove+(i*70),#White)  ;draw the letter with transparency so the raster shows through
  Next i
StopDrawing()
FreeImage(#bigfont+1) ;keep tidy as pb can sometimes break!!
  
  vymove-vspeed:If vymove=<-140:vymove=-70:vletter+1:EndIf
  If vletter>Len(vertscroll$):vletter=1:vxmove=400:EndIf
  
gap=0
hdc=StartDrawing(ScreenOutput())
For i=1 To 8
	  GrabImage(#vrastback,#vrastback+1,0,(i*70),64,70)
	  ResizeImage(#vrastback+1,64,vgaps(i)\ysize)
	  For x=92 To 640-128 Step 128                                ;draw across 4 times
	    KK_DrawTransparentImage(hdc,#vrastback+1,x,gap+offset,#Black)
	  Next x
    gap+vgaps(i)\ysize
  Next i

StopDrawing()
EndProcedure

;}

;{ Small scroller stuff
DataSection
   small:  :IncludeBinary "gfx\smfont.bmp"   ;16x16
EndDataSection

#smallfont=10
CatchImage(#smallfont,?small)

#smallrast=30
CreateImage(#smallrast,640,360)

#smcanvas=16
CreateImage(#smcanvas,640,16)

#barrel=26
CreateSprite(#barrel,640,360*2)

Global smscroll$="  THIS IS WHAT HAPPENS WHEN DEMO CODERS GET BORED AT SCHIPOL AIRPORT! THIS SCREEN WAS DESIGNED BY DIGITAL INSANITY AND MANIKIN OF THE LOST BOYS WHILE WAITING FOR THE HEATHROW FLIGHT AT SCHIPOL AIRPORT 1 FRIDAY AFTERNOON IN APRIL 1990. AFTER A RATHER INTERESTING WEEK DURING WHICH WE MET NICK OF THE CAREBEARS. GOT DRUNK,  AND PROCEEDED TO 'REDECORATE' RICK'S BATHROOM! AND HAD A GENERALLY GOOD LAUGH!  THIS SCREEN WAS CODED BY MANIKIN AND D.I. WITH GRAPHIX BY SPAZ. MUSIC IS FROM TERAMIS AND IT WAS COMPOSED BY MAD MAX!!!                                                                                "
Global smspeed=2,smxmove=640,smletter=1

Global smstp.f=#PI/16     ;16 steps on the barrel scroller
Global colstp.f =#PI/16;  ;16 colours in the faded barrel
Global tube_y=360+4       ;start at the bottom (+ a little bit to avoid a slight jump glitch!!)
Global oldy



Structure gaps
  ysize.f
  gap.f
  cols.i
EndStructure

Global Dim gaps.gaps(16)

;calculate some sizes based on a sine value along with a fade colour based on the same 16 steps
For i=1 To 15
  ypos=Abs(16*Sin(smstp*i))     ;position of the next bit to grab
  col=Abs(Sin(colstp*i)*224)    ;224 is the maximum RGB value per colour
  gap+ypos                      ;gap between each slice
  gaps(i)\ysize=ypos
  gaps(i)\gap=gap
  gaps(i)\cols=col
Next i


;draw the white scrolltext first on a sprite 
Procedure smallscroller()
hdc=StartDrawing(ImageOutput(#smcanvas))
  For i=1 To (640/16)+2
    tval=Asc(Mid(smscroll$,smletter+i,1))-32
    If tval<0:tval=30:EndIf
    GrabImage(#smallfont,#smallfont+1,(tval*16)+1,0,16,16)
    DrawImage(ImageID(#smallfont+1),smxmove+(i*16),0)
  Next i
StopDrawing()

smxmove-smspeed:If smxmove=-32:smxmove=-16:smletter+1:EndIf
If smletter>Len(smscroll$):smletter=1:smxmove=640:EndIf


;now draw 32 scrollers on a barel sprite to then 
StartDrawing(SpriteOutput(#barrel))
gap=0
For i=1 To 31
  DrawImage(ImageID(#smcanvas),0,(i*16)+gap-16)
    gap+10
Next i
StopDrawing()

ProcedureReturn 


EndProcedure

;}
  
Procedure DrawTube1()			;draw the tube text
  
  ;Draw the raster bars if they are moving down behind the barrel
   If red_y>0 And red_y<180
    DisplayTransparentSprite(#redbar,0,360*Sin(red_y*barstep)+offset)
   EndIf
   If blue_y>0 And blue_y<180
    DisplayTransparentSprite(#bluebar,0,360*Sin(blue_y*barstep)+offset)
   EndIf
   If green_y>0 And green_y<180
    DisplayTransparentSprite(#greenbar,0,360*Sin(green_y*barstep)+offset)
   EndIf
  
   
   CopySprite(#barrel,#barrel+1)
   oldy=tube_y
	 tube_y-1				                  ;move up by 1 pixel
	 If tube_y<=0:tube_y=360+4:EndIf	;end of text tube reached? 
	 
	gap=0	 
	 ;draw the back blue text upside down first
	 For i=1 To 15
    ClipSprite(#barrel+1,0,tube_y+(i *26),640,26)
    ZoomSprite(#barrel+1,640,gaps(i)\ysize*2)                                   ;clipping or zooming the sprite resets it's orientation so we have to flip it afterwards!!
    KK_FlipSprite(#barrel+1)                                                    ;flipping the sprite will make it move upwards - nice trick ;-)
    DisplayTransparentSprite(#barrel+1,cnt,gap+60+offset,192,RGB(0,0,gaps(i)\cols))   ;blue colour is faded
    gap+gaps(i)\ysize*2
  Next i
 
EndProcedure

Procedure DrawTube2()  
  
   tube_y=oldy                      ;restore old y position
   tube_y-1				                  ;move up by 1 pixel
   If tube_y=<0:tube_y=360+4:EndIf	;end of text tube reached? 
   
  ;draw the front white faded text moving down
	gap=0
	For i=1 To 16
	  col=gaps(i)\cols
    ClipSprite(#barrel,0,tube_y+(i *26),640,26)
    ZoomSprite(#barrel,640,gaps(i)\ysize*2)
    DisplayTransparentSprite(#barrel,cnt,gap+60+offset,255,RGB(col,col,col))
    gap+gaps(i)\ysize*2
  Next i
  
  ;Draw the raster bars if they are moving down behind the barrel
  
   If red_y>180
    DisplayTransparentSprite(#redbar,0,360*Sin(red_y*barstep)+offset)
   EndIf
   If blue_y>180
    DisplayTransparentSprite(#bluebar,0,360*Sin(blue_y*barstep)+offset)
  EndIf
  If green_y>180
    DisplayTransparentSprite(#greenbar,0,360*Sin(green_y*barstep)+offset)
   EndIf
  
  
ProcedureReturn 
	
EndProcedure


OSMEPlay(?music,?musend-?music,7)


tm=ElapsedMilliseconds()
Repeat  
  event=WindowEvent()
  ClearScreen(0)
  
  Smallscroller()    ;blue back inverted text behind the big scroller
  DrawTube1()
  BigScroller()      ;scroll thru the middle of the barrel
  DrawTube2()        ;front white test in front of the big scroller
  VertScroller()
  movebars()
  
  FlipBuffers()
Until GetEsc()
OSMEStop()
End


DataSection
  
  bigfontcols:
 
  Data.l  $A000,$C000A0,$6040E0,$8020E0,$E000A0,$E0A060,$20E020,$80A0,$8020E0,$6040E0,$C000A0,$A000
  
  vertfontcols:
  Data.l    #Red,#Yellow,#Red
  
  big:    :IncludeBinary "gfx\bigfont2.bmp"  ;64x70  = 320x320 zoomed
  music:  :IncludeBinary "sfx\Leavin_Teramis.sndh"
  musend:
  
EndDataSection








; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 9
; Folding = Ak
; Executable = TLB_Intro.exe
; SubSystem = dx9
; DisableDebugger
; HideErrorLog
; IncludeVersionInfo
; VersionField0 = 1
; VersionField1 = 1
; VersionField2 = KrazyK
; VersionField3 = TLB Intro
; VersionField4 = 1
; VersionField5 = 1
; VersionField6 = TLB Intro
; VersionField7 = TLB Intro
; VersionField8 = TLB_Intro.exe
; VersionField9 = KrazyK
; VersionField10 = KrazyK