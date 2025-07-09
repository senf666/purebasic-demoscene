

;This Purebaisc code is for the Ah Yeah! screen by Digital Insanity for The Lost Boys MindBomb Demo on the Atari ST
;Credit to STos for ripping the fonts for me.  Cheers mate.
;All the rest of the hacking and ripping and dumping have been done by me including converting the raster palettes and sine waves.
;Uses standard Purebasic sprite and image routines either native or in my own libraries that have been included in this package.
;The Oldskool Music Engine originally coded by Slippy and now made into a PB userlibrary by me a while ago is also included here too. 
;It is x86 only compiler only though as that's how it was originally coded by Slippy.
;The c source for his engine is online if anyone c coders want to try and re-code it for x64.  Good luck with it.
;Feel free to use and abuse my code, make it better, faster, add shit to it etc, etc. etc. 
;But don't forget where it came from as a credit is always nice if you use it in your own prods. :-)

;Notes;
;Use compiler option for directx9 or dx9 depending on what version you're using.
;Tested on Purebasic 5.73 LTS and dx9 subsystem.
;After PB 6.x the image transparency no longer works properly.

;KrazyK 2024

FS=0		;windowed=0, fullscreen=1

Global OFFSET=0
If FS=0
  KK_Window(640,400)
Else
  KK_Screen(640,480,32,60)  
  OFFSET=40				;keep it neat and accurate in fullscreen mode
EndIf

Structure raster                        ;RGB raster colour array for the small scrollines
	r.w
	g.w
	b.w
EndStructure
Global Dim raster.raster(26)
CopyMemory(?rastercols,@raster(0)\r,?rastend-?rastercols)	;copy all the raster colour data into the array
Global newx,scounter

;{ Small scrolline stuff 
DataSection
wave:
IncludeFile "yeahsine.pbi"
IncludeFile "yeahsine.pbi"

font:	:IncludeBinary "gfx\smallfont.bmp"
	
EndDataSection

Global small$=""
small$+"                      SO THIS IS THE THIRD DIGITAL INSANTITY MINDBOMB SCREEN. IT IS GETTING TO BE TRENDY TO HAVE TONSA LITTLE SCROLLINES"
small$+" LIKE THIS IN DEMOS. SCREEN WRITTEN AROUND NOVEMBER 1989. SINCE SCROLLERS LIKE THIS COST A LOT OF MEMORY I THINK THE TIME HAS COME TO WRAP ...     "
small$=UCase(small$)						;force uppercase
Global smxmove=640,smletter=1,xsine.w=0				;start variable for the scroltext
CatchImage(0,?font)						;small font
Global scrollsprite=CreateSprite(#PB_Any,640*2,16)  ;draw the scroltext on here


Procedure Multiscroll()
	
StartDrawing(SpriteOutput(scrollsprite))
For i=1 To 80										;draw enough characters on the scroll sprite.
	tval=Asc(Mid(small$,smletter+i,1))-32			;get the ascii value of the next letter
	If tval<0:tval=0:EndIf							;no minus values here!
	GrabImage(0,1,16*tval,0,16,16)					;grab the letter block from the font image
	DrawImage(ImageID(1),smxmove+(i*16),0,16,16)	;draw it in the correct location on the scroll sprite
Next i
StopDrawing()
;There are a number of different ways to scroll the text.  
;You can have a counter that increases that you then take off the x position etc, but I always use this one as it's the one I can remember to code!!
;However, you must move the text evenly so you get a full minus letter width otherwise you will get a jump when you get the next letter.

smxmove-2						;move 2 pixel left
If smxmove=-32					;moved 2 whole letters offscreen?
	smxmove=-16					;reset back to 1
	smletter+1					;next letter in the text
EndIf
If smletter>Len(small$)			;end of text reached?
	smletter=1					;back to first letter in the text
	smxmove=640+320				;move the scrolline position back
EndIf	

scounter+2
xsine.w=PeekW(?wave+scounter)	;read next value from memory 
If xsine.w=$1234				;the original demoscreen checked for this control end word so I thought I would do the same thing.  Just a little nod to the original coder. ;-)
	scounter=0					;back to the start of the wave
EndIf	

With raster(i)
For i=0 To 24															;lotsa scrollers
  xsine.w=PeekW(?wave+(scounter+(i*2)))						;read the next wave value
  DisplayTransparentSprite(scrollsprite,xsine,i*16,255,RGB(\r,\g,\b))	;show the scroll sprite at the xsine position with the correct RGB colours
Next i																	;next line
EndWith

EndProcedure

;}

;{ DI logo stuff 
DataSection
  dilogo: 	:IncludeBinary "gfx\dilogo.bmp"
  diraster: :IncludeBinary "gfx\diraster.bmp"
EndDataSection

CatchImage(100,?dilogo)						;ripped masked logo
CreateImage(101,ImageWidth(100),ImageHeight(100)) 		;create an image to draw the logo raster on first
CatchImage(103,?diraster):ResizeImage(103,ImageWidth(100),200)	;resize the raster image

Global logostep.f=#PI/ImageWidth(100)/2				;speed steps For the logo
Global di_y=200,di_x=-200,sincounter=0				;logo starting variables

Procedure SwingLogo()
  di_y-2:If di_y<=0:di_y=200:EndIf				;scroll the raster up
  
  hdc=StartDrawing(ImageOutput(101))			;draw on the back image
    DrawImage(ImageID(103),0,di_y)				;draw raster above and below the back image so there's no gaps
    DrawImage(ImageID(103),0,di_y-200)    ;			
    KK_DrawTransparentImage(hdc,100,0,0,#White)	;draw the masked logo to show the raster behind
  StopDrawing()
		
  sincounter+32								;speed
  xcount=360									;start sine
  di_x=xcount*Sin(logostep*sincounter)			;calc the x sine position of the logo
  
hdc=StartDrawing(ScreenOutput())
  KK_DrawTransparentImage(hdc,101,di_x-320,300+OFFSET,#Black);draw the raster logo to the screen with black as transparent
StopDrawing()
  
EndProcedure

;}

;{ Big scroller stuff
DataSection
  bigfont:  :IncludeBinary "gfx\bigfont.bmp"  
  topraster:  :IncludeBinary "gfx\top_pal.bmp"
EndDataSection

Global big$=""
big$+"               GREETINGS MORTAL AND BEHOLD THE THIRD DIGITAL INSANITY MINDBOMB SCREEN.  AGAIN I HAVE FINISHED  A DEMO AND I MUST"
big$+" SAY THAT I AM QUITE SATISFIED. WHAT STARTED OUT AS AN INNOCENT EXPERIMENT, HAS GROWN INTO A FULL-BLOWN DEMO. I DID 75 PERCENT OF THIS"
big$+" DEMO AROUND SEPTEMBER 1990, INCLUDING THE MOVING BACKGROUND, THE SMALL SCROLLINES AND THE BIG SCROLLER, THE MINDBOMB LOGO PLUS THE DIGITAL"
big$+" INSANITY LETTERS HAVE BEEN ADDED MONTHS AFTER I STOPPED CODING THIS SCREEN.  REASONS WERE ST NEWS 5.1 AND THE FINAL COMPENDIUM HAD TO BE"
big$+" FINISHED. WE WENT TO NORWAY, AND AFTER NOT CODING FOR SUCH A LONG TIME, IT WAS QUITE HARD FOR ME TO GET THE HANG OF IT AGAIN.  BUT HERE IT"
big$+" IS - THE 'AH YEAH' SCREEN.  SO WHAT DO I HAVE TO WRITE NOW?  MAYBE SOME GREETINGS TO SOME BEINGS ARE DUE RIGHT NOW. OK. I WOULD LIKE TO"
big$+" EXPRESS SINCERE FEELINGS OF GREETINGS TO THE FOLLOWING INDIVIDUALS THAT ARE ALSO QUITE KNOWN FOR THEIR KEEN KNOWLEDGE OF ST CODING OR THEIR"
big$+" OTHER ACTIVITIES ON OUR WONDERFUL MACHINE. ANYWAY, THEY GO TO: RICHARD KARSMAKERS (FOR OBVOUOUS REASONS I FIGURE), TIM MOSS (FOR DOING THE"
big$+" IMPOSSIBLE, ACHEIVING THE AMAZING AND MAKING THIS DEMO WHAT IT IS), LORD HACKBEAR (HI THERE!! EMAIL YOU LATER!),GARD THE AMAZING ANTIBEING"
big$+" (FOR BEING  GENERALLY INSANE AND JUST TOTALLY MAD), ALL THE GUYS AT THALLION SOFTWARE (TALK ABOUT TALENT...GEEEZ), CID AND THE OTHER DUDES"
big$+" FROM GALTAN SIX (CAN'T WAIT TO SEE THE FINAL VERSION OF THE MEGADEMO), ENIGMATICA (HEY GUYS??? WHAT'S UP WITH THAT DEMO OF YOURS??  WHEN IS"
big$+" IT GOING TO BE RELEASED??), ALL THE NUTTY NORWEIGANS (FROYSTEIN, OLE J, MORTEN, RONNY - PC??? - AND THE REST OF THEM), ASH AND MEL"
big$+" (THE EXTRAVAGENT ENGLISH NEVER CEASE TO AMAZE ME). OK, SINCE ALL THOSE FREAKS FROM THE SOWATT DEMO STARTED JIBBERING IN SWEDISH AND NORWEIGAN,"
big$+" WHY NOT INCLUDE SOME DUTCH HERE??? OK HERE GOES: JA HOOR, WAT EEN GELUL ALLEMAAL HIER NEDERLANDS IN EEN SCROLLTEXT IS GELOOF IK NOG NOOIT GEDDAAN,"
big$+" ALTHANS NEIT IN EEN NIET-NEDERLANDSE DEMO.  WAT EEN ONTZETTEND GE-EIKEL IS HET TOCH OM ZO'N DEMO TE MAKEN, AL DAT GEKLOOT MET INTERRUPTS EN"
big$+" PLANES EN ZO. IK WORDT ER AF EN TOE WEL EEN BEETJE ZIEL VAN, MAAR JA, HET ZIET ER TOCH WEL AARDIG UIT. VOORDAT MEN DENKT DAT IK HELEMAAL"
big$+" GESTOORD GEWORDEN BEN, ZAL IK MAAR WEER OVERGAAN NAAR HET ENGELS!!!                                   RIGHT. WHAT A LOAD OF CRAP HUH? WELL"
big$+" COME TO HOLLAND ONCE AND HEAR IT BEING PRONOUNCED, YOU'LL PROBABLY DIE LAUGHING. IT IS WYRD (IF YOU THINK 'WEIRD' IS WEIRD, WAIT UNTIL YOU SEE"
big$+" SOMETHING THAT IS 'WYRD' !) I CAN TELL!! HOWEVER, WE HAVE  BEEN TO NORWAY  AND THE LANGUAGE THEY SPEAK THERE IS CERTAINLY QUITE ABSURD!!"
big$+"   SLOWLY I AM RUNNING OUT OF JUICE HERE. WHY NOT FABRICATE AN END TO THIS CRAP AND LET THE OL' WRAPPER DO HIS JOB.  I MEAN THE LTTLE SUCKER"
big$+" HAS BEEN WAITING FOR THAT NULL BYTE A LONG TIME. BETTER GIVE HIM WHAT HE WANTS BEFORE THE DAMN PROGRAM BOMBS OUT ON YOU!"
big$+"       OK, MISTER WILLIAM RAP, DO YOUR THING!!                                   "

Global Alpha$="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!()',.-?:' "	;big font layout
Global topx=-64,topletter=1,topspeed=8				;start variable for the big scroller

CatchImage(200,?bigfont)    ;64x70 ripped font (thanks (STos)
CreateImage(202,640,70)     ;draw scrolltext on here first
CreateImage(208,640,100)    ;draw raster and bent text on here

CatchImage(203,?topraster):ResizeImage(203,64,400)	;resize the raster
CreateImage(210,64,100);draw raster on here		;draw the raster here first		
Global top_y=400					;raster start position
Global t.f=0,stp.f=(#PI*2)/100				;slight ben in the scrolltext



Procedure BigScroller()
  ;Here's the slightly tricky bit of the scroller.
  ;We can't bend the scrolltext with the raster already behind it as the raster needs to be horizontal across the screen.
  ;So we must slice up the scrolltext first then grab the raster separately and place it in the correct y position behind the text.
  ;Gotta keep it accurate ;-)
  

;draw scrolltext first
hdc=StartDrawing(ImageOutput(202))
  For i=1 To 12											;draw 12 letters in the scroller
    t$=Mid(big$,topletter+i,1)							;get the next letter
    pos=FindString(alpha$,t$,1,#PB_String_NoCase)-1		;find where it is in the font layout
    If pos>-1											;no minus values here
      GrabImage(200,201,pos*32,0,32,32)					;grab the font block		
      ResizeImage(201,64,70)							;resize it
      DrawImage(ImageID(201),topx+(i*64),0)				;draw it in the correct x position horizontally first of all.
    EndIf
  Next i
  FreeImage(201)										;PB can sometimes generate a memory error fart if you don't free the images!
  StopDrawing()
  
;scroll left  
topx-topspeed											;move left
If topx=-128:topx=-64:topletter+1:EndIf					;moved off screen?,get next letter
If topletter>Len(big$):topletter=1:topx=640:EndIf		;end of text, reset
;===========================================

;scroll the raster colours up on it's back image
top_y-2:If top_y<0:top_y=400:EndIf						;move the raster up
StartDrawing(ImageOutput(210))							
  DrawImage(ImageID(203),0,top_y-400)					;draw below
  DrawImage(ImageID(203),0,top_y)						;draw on top
StopDrawing()

;================================================================
; Cut the scrolltext up into 32pixels width and calc the bend.	;
;================================================================
t=-32												;start it here
hdc=StartDrawing(ImageOutput(208))
Box(0,0,640,100,#White)								;clear the image white
  For x=0 To 640-32 Step 32  						;screen width of text
    t.f+stp											;step value
    YPos=(32-(Cos(t.f)*100))+70       				;slight bend
    GrabImage(202,204,x,0,32,70)      				;grab font part
    GrabImage(210,209,0,ypos,32,70)   				;grab raster
    DrawImage(ImageID(209),x,ypos)    				;draw raster
    KK_DrawTransparentImage(hdc,204,x,ypos,#Black) 	;draw font part
  Next x
StopDrawing()
 
  
hdc=StartDrawing(ScreenOutput())
  KK_DrawTransparentImage(hdc,208,0,32+OFFSET,#White)	;draw the bent rastered scroller to the screen now. White is transparent
StopDrawing()

EndProcedure

;}

;{ Moving back stuff 

DataSection
  grey: :IncludeBinary "gfx\greysquare.bmp"
EndDataSection

CatchImage(300,?grey)		        ;grey block
CreateSprite(300,640,1200)	        ;make a big sprite with the small grey block with enough height to move up and down the screen.
StartDrawing(SpriteOutput(300))
For y=0 To 1200 Step 38		        ;across
  For x=0 To 640 Step 32	        ;down
      DrawImage(ImageID(300),x,y)       ;draw the square
  Next x
Next y
StopDrawing()

Global back_y,backysin			;some vars

Procedure  Moveback()
  backysin +1									;speed
  back_y=360*Sin(backysin/32)-360				;calc next y position
  DisplayTransparentSprite(300,0,back_y-OFFSET)	;move it!
EndProcedure

;}

;{ Mindbomb Mover

DataSection
  m:  :IncludeBinary "gfx\m.bmp"
  i:  :IncludeBinary "gfx\i.bmp"
  n:  :IncludeBinary "gfx\n.bmp"
  d:  :IncludeBinary "gfx\d.bmp"
  b:  :IncludeBinary "gfx\b.bmp"
  o:  :IncludeBinary "gfx\o.bmp"
EndDataSection

CatchSprite(500,?m)
CatchSprite(501,?i)
CatchSprite(502,?n)
CatchSprite(503,?d)
CatchSprite(504,?b)
CatchSprite(505,?o)
CopySprite(500,506)
CopySprite(504,507)
For i=500 To 507:TransparentSpriteColor(i,#White):Next i

Global Dim Mindstep.f(9)		
For i=0 To 7			;8 sprites
  Mindstep(i)=0.03142*(i+1)*4	;calc some starting positions
Next i

Procedure MindBomb()
  
  For i=0 To 7													;8 sprites
    mindstep.f(i)+0.0314*3										;calc ssine step
    mindy=32*Sin(mindstep(i))									;calc y position for next sprite
    DisplayTransparentSprite(500+i,64+(64*i),mindy+140+OFFSET)	;display them
  Next i
  
    
EndProcedure

;}


If OFFSET=40:border=CreateSprite(#PB_Any,640,40):EndIf	;for fullscreen mode

OSMEPlay(?music,?musend-?music,7)
	
Repeat
  event=WindowEvent()
	
  Moveback()		;grey back
  Multiscroll()		;loadsa scrollers
  SwingLogo()		;big logo
  MindBomb()		;MINDBOMB sprites
  BigScroller()		;Big raster scrolltext
	
If OFFSET=40		;borders top and bottom to make it neat in fullscreen mode
  DisplaySprite(border,0,0)
  DisplaySprite(border,0,440)
EndIf

FlipBuffers()
ClearScreen(0)
          	
Until GetEsc()

OSMEStop()
End

DataSection

music:  :IncludeBinary "sfx\Leavin_Teramis.sndh"
musend:
	
rastercols: ;for the small scrollines
Data.w  0,0,32
Data.w  0,0,64
Data.w  0,0,96
Data.w  0,0,128
Data.w  0,0,160
Data.w  0,0,192
Data.w  0,0,224
Data.w  0,0,192
Data.w  0,0,160
Data.w  0,0,128
Data.w  0,0,96
Data.w  0,0,64
Data.w  0,0,32
Data.w  64,0,0
Data.w  96,0,0
Data.w  128,0,0
Data.w  128,0,0
Data.w  128,0,0
Data.w  160,0,0
Data.w  128,0,0
Data.w  128,0,0
Data.w  128,0,0
Data.w  128,0,0
Data.w  96,0,0
Data.w  96,0,0
Data.w  64,0,0
Data.w  64,0,0
rastend:


EndDataSection


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 132
; Folding = Aw
; Executable = AH_Yeah.exe
; SubSystem = dx9
; DisableDebugger
; CompileSourceDirectory
; IncludeVersionInfo
; VersionField0 = 1
; VersionField1 = 1
; VersionField2 = KrazyK
; VersionField3 = Mindbomb Demo -Ah Yeah! Screen By Digital Insanity
; VersionField4 = 1
; VersionField5 = 1
; VersionField6 = Mindbomb Demo -Ah Yeah! Screen By Digital Insanity
; VersionField7 = Mindbomb Demo -Ah Yeah! Screen By Digital Insanity
; VersionField8 = AH_Yeah.exe
; VersionField9 = KrazyK
; VersionField10 = KrazyK