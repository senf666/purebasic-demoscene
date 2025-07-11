;Scum Of The Earth 
;Too Much Month At The End Of The Money
;MegaDemo Preview


;Coder:		Illegal Exception
;Gfx:		Raphael
;Music:		Mad Max
;Remake:	KrazyK 2019

XIncludeFile "include\sound_sndh.pbi"

xres=640
yres=480

Global offset=40			
;Offest to start drawing everything 40 pixels from the top of the screen to keep it accurate for the ST in fullscreen mode
;The standard ST screne is 320x200 so we double this to 640x400 to keep it proportional (in windowed mode) and avoid stretching pixels.
;We can't normally use 640x400 in fullscreen then we have to use 640x480 and add a border to the top and bottom to keep things looking accurate.


fs=0			;windowed/fullscreen flag

If fs=0
	offset=0	;no offset in windowed mode
	yres=400
EndIf		

demo$="SOTE MegaDemo Preview"
InitSprite()

If fs=0
	OpenWindow(0,0,0,xres,yres,demo$,#PB_Window_BorderLess|#PB_Window_ScreenCentered|#PB_Window_WindowCentered)
	OpenWindowedScreen(WindowID(0),0,0,xres,yres)
	StickyWindow(0,1)
	ShowCursor_(0)
ElseIf fs=1
	OpenScreen(xres,yres,32,demo$)
Else
	End
EndIf
SetFrameRate(60)

ClearScreen(0):FlipBuffers()


Global fix			;variable for the music start channel 0 volume
Declare MakeBack(back,image)


;{ VU bar / Music stuff
Global vu_width.f=512/15	;vu bar volume width
CatchSprite(0,?redbar)
CatchSprite(1,?greenbar)
CatchSprite(2,?bluebar)
CatchSprite(3,?barend)
;}

;{ Scroller stuff
Global fx,fy,numchars
Global chars=50			;50 characters in the font
Global Dim font(chars)		;font image array
Global speed=16			;scroll speed
Global xmove=640		;start at edge of the screen
Global letter=1			;start at the beginning!
Global letts$="ABCDEFGHIJKLMNOPQRSTUVWXYZ.,:;()?!+-~/#0123456789* "	;this is the format of the memory font data
Global scroll$="                                                       YO!!! THIS IS ILLEGAL EXCEPTION PRESENTING THE 1ST SCUM OF THE EARTH PRODUCTION... LETS CLEAR OFF THE CREDITS..... ALL CODING BY THE ONE AND ONLY ILLEGAL EXCEPTION...... GRAPHIX BY THE TWO * AND ONLY RAPHAEL... MUSIC BY MAD MAX OF THE EXCEPTIONS AND RIPPED BY ZAPHOD BEEBLEBROX OF THE LIGHT (LAME??! *) TEAM......  AS MY MEGA ST2 IS MALFUNCTIONING I AM WRITING THIS ON A BORROWED COMPUTER!! MEGATHANX GOES TO LOB FOR LETTING ME BORROW HIS SPARE ST!!! I REALLY APPRECIATE IT AS OUR MEGADEMO WOULD HAVE GONE DOWN THE DRAIN WITHOUT SOMETHING TO CODE IT ON.....(H FAN!!!)  SO ONCE AGAIN, THANX A LOT LOB!!! OH, I ALMOST FORGOT TO THANK ZAPHOD BEEBLEBROX OF TLT FOR LETTING ME BORROW HIS STE FOR A WEEK....  O.K. THIS IS THE OLDEST (AND MAYBE THE WORST?! *) SCREEN CODED FOR OUR MEGADEMO SO I FOUND IT IDEAL FOR A PRERELEASE SCREEN.       AS YOU PROBABLY HAVEN T HEARD OF US BEFORE I CAN TELL U THAT S.O.T.E. IS A 2-MEMBER CREW AND THE ONLY MEMBERS ARE..... ILLEGAL EXCEPTION (BITKILLER *) AND RAPHAEL (PIXELPUSHER *)!   AS I MENTIONED BEFORE WE ARE DOING A MEGADEMO WHICH WILL BE RELEASED SOMETIMES IN 1991 (HOPEFULLY....). THE NAME OF THE DEMO IS.......... TOO MUCH MONTH AT THE END OF THE MONEY DEMO OR TO MAKE IT SHORT....(*) T.M.M.A.T.E.O.T.M. DEMO!!!!!  O.K. AND NOW THE GREETINGZZZZZ........  IN NO SPECIAL ORDER THEY GO TO......     TCB (ESPECIALLY AN COOL!)    TLT (ESPECIALLY MR. PP! ALSO THANX TO VIPER FOR TESTING THE BORDER ROUTS ON HIS STE! HELLO THERE CHAOS...)     LYNX     ELECTRONIC IMAGES (HI THERE! HOW IS THE GENETIX DEMO GOING?)     DELTA FORCE (ESPECIALLY NEW MODE AND SLIME! MEGA THANX FOR THE MUSICAL WONDER 1991... BIG ALEC IS REALLY A GREAT MUSICIAN!)     VECTOR (ESPECIALLY THE ONE! I WILL KEEP IN TOUCH WITH U...)     TKT (NICE BLIPP BLOPPER! PLEASE SEND ME A COPY...)     SYNC (ESPECIALLY 7AN AND MR. MAC!)     OMEGA (ESPECIALLY LIESEN AND CUGEL!)     2 LIFE CREW     TLB     JSD (HI THERE!)     VIKING X     UNIT 17     ORION     ULM     OVR     UNC (HI QWERTY! I WILL UPLOAD MY NEWEST SOFTWARE LIST A.S.A.P.!)     ARMALYTE (ESPECIALLY TRAXX! HOPE TO SEE U THIS SUMMER WHEN YOU TRAVEL FROM HOLLAND!)    TEX     ELECTRA      XPC (YOU SEEM TO BE A WEIRD CREW!)     TFS (I AM WAITING FOR YOUR MEGADEMO... WHENEVER IT IS FINISHED!)     THE STARFIRES    VIGILANTE            YAWN!!! I AM TIRED......... MAYBE TIME TO WRAP!? HEJ D???  YEPP.... SCREW THIS TEXT! BTW, TRY KEYS 1-7!!! C.U. L8ER IN OUR MEGADEMO!!!       AND HEY, HEY, HEY.... LETS BE CAREFUL OUT THERE!!!                    LA DA DEE LA DA DA       LA DA DEE LA DA DA     LA DA DEE LA DA DA       LA DA DEE LA DA DA    **************************    THIZ IZ THE END               SCUM OF THE EARTH RULEZZZ 4EVER!!! *       "
Global tlen=Len(scroll$)	;scroll length

;}

;{ Back movement stuff
#squares=10
#pipes=11
#sotelogo=12

Global angle.f,x.f,y.f
Global angle1.f,x1.f,y1.f
Global angle2.f,x2.f,y2.f
;create all moving backs
MakeBack(#squares,?square)
MakeBack(#pipes,?pipe)
MakeBack(#sotelogo,?sote)
;}

Procedure MakeBack(back,image)
	
;catch the back image first
	CatchImage(0,image)
	swidth=ImageWidth(0)	;get the width
	sheight=ImageHeight(0)	;and height
	x=0
	y=0
	CreateSprite(back,1024,1024)	;create a decent sized blank image to draw it onto
	StartDrawing(SpriteOutput(back))
	Repeat
		DrawImage(ImageID(0),x,y)
		x+swidth		;next one across
		If x>1024:x=0
			y+sheight	;next one down
		EndIf
	Until y>1024
	StopDrawing()
	
EndProcedure


Procedure VUBars()
	;read the volume of each channel
	ch0=OSME_GetChannelVU(0)
	ch1=OSME_GetChannelVU(1)
	ch2=OSME_GetChannelVU(2)
	
	;simple fix for the tune start to keep things accurate!
	;channel 0 should be 1 when the tune first starts but the sndh conversion sets it at 15
	;so we have to set it to 1 until the channel receives a different volume.  Gotta keep it accurate.
	If fix=0 And ch0=15	
		ch0=1
	Else 
		fix=1
	EndIf
	
	ch0*vu_width:ch1*vu_width:ch2*vu_width	;set the widths of the bars according to the volume
	
	If ch0=0:ch0=32:EndIf	;check if any of the volumes are zero and set them to 1 
	If ch1=0:ch1=32:EndIf
	If ch2=0:ch2=32:EndIf
	
	;display all the vu bars (with slight corrections in placement!)
	centx=(640/2)-(ch0/2)
	ZoomSprite(0,ch0,24)
	DisplaySprite(0,centx,4+offset)
	
	DisplaySprite(3,centx-32,4+offset)
	DisplaySprite(3,centx+ch0,4+offset)
	
	centx=(640/2)-(ch1/2)
	ZoomSprite(1,ch1,24)
	DisplaySprite(1,centx,29+7+offset)
	
	DisplaySprite(3,centx-32,32+4+offset)
	DisplaySprite(3,centx+ch1,32+4+offset)
	
	centx=(640/2)-(ch2/2)
	ZoomSprite(2,ch2,24)
	DisplaySprite(2,centx,61+7+offset)
	
	DisplaySprite(3,centx-32,64+4+offset)
	DisplaySprite(3,centx+ch2,64+4+offset)
	
	
	
EndProcedure


Procedure MoveBacks()
	;this isn't as accurate as the original but it's close enough to get the idea.
	
	angle.f+0.1
	x.f=38*(Sin(angle))
	y.f=50*Cos(angle)
	DisplayTransparentSprite(#sotelogo,x.f - 120,y -120+offset)
	
	
	angle1.f+0.12
	x1.f=26*(Sin(angle1))
	y1.f=40*Cos(angle1)
	
	DisplayTransparentSprite(#pipes,x1-120,y1-120+offset)
	
	
	angle2.f+0.1
	x2.f=80*(Sin(angle2))
	y2.f=70*Cos(angle2)
	DisplayTransparentSprite(#squares,x2-120,y2-120+offset)
	
	
EndProcedure


Procedure CreateFont()
;The font is a collection of byte points that make each character, denoted by being a values of $ff or -1.
;Each character is 16 bytes wide and 16 bytes high, with each point being 16 pixels, making it 256 x 256 pixels.
;This was ripped using MONST and stepping through the code until I found out where it was being assembled in memory, then simply saving the memory block.
	
	CatchImage(1,?raster)				;font raster
	count=0
	numchars=0
	
	Repeat	
	CreateSprite(100,256,256)			;create a blank box
	StartDrawing(SpriteOutput(100))
		For fy=0 To 15				;16 lines
			For fx=0 To 15			;16 rows
				byte=PeekB(?sotefont+fx+count)			;read a byte from the raw font data
				If byte=-1					;does it need drawing?
					GrabImage(1,3,0,fy*15,15,15)		;grab a small raster block at the correct height
					DrawImage(ImageID(3),fx*15,fy*15)	;draw the raster block on the font
				EndIf
			Next fx
			count+16						;next line down
		Next fy
	StopDrawing()
	font(numchars)=CopySprite(100,#PB_Any)		;store the new character in the array
	numchars+1					;next character
	Until numchars=50				;only 50 characters
	font(50)=CreateSprite(#PB_Any,256,256)		;make the last one a space
	
	
EndProcedure


Procedure Scroller()
	For l=0 To 4
		
		char$=Mid(scroll$,letter+l,1)		;read 1 character
		
		;find the position of the character in our defined font string and return the position of it.
		;this will determine the position in the array of the correct character. Simple!
		;"ABCDEFGHIJKLMNOPQRSTUVWXYZ.,:;()?!+-~/#0123456789* " this is the format of how the font is created in the array
		
		pos=FindString(letts$,char$)-1					
		
		DisplayTransparentSprite(font(pos),xmove+(l*256),126+offset)	;now draw it
	Next l
	
xmove-speed						;scroll left
If xmove=-512:letter+1:xmove=-256:EndIf			;if we have scrolled 1 letter off the screen then add 1 letter
If letter>tlen:letter=1:xmove=640:EndIf			;reached end of scroll text then restart.
	
	
EndProcedure

;create a border to keep things accurate for the ST screen in fullscreen mode
If fs=1
	border=GrabSprite(#PB_Any,0,0,640,40)
EndIf

;create our font with the ripped raw data from the original unpacked .prg
CreateFont()

PlayOSMEMem(?music,?musend-?music,0)

Repeat	
	ClearScreen(0)
	w=WindowEvent()
	
	MoveBacks()
	VUBars()
	Scroller()
	If fs=1
		DisplaySprite(border,0,0)	;draw the ST borders in fullscreen mode
		DisplaySprite(border,0,440)
	EndIf

	FlipBuffers()
Until GetAsyncKeyState_(#VK_ESCAPE)
StopOSME()
End


DataSection
	
square:		:IncludeBinary "gfx\redsquare.bmp"
pipe:		:IncludeBinary "gfx\pipe.bmp"	
sote:		:IncludeBinary "gfx\sote3.bmp"
redbar:		:IncludeBinary "gfx\redbar.bmp"
greenbar:	:IncludeBinary "gfx\greenbar.bmp"
bluebar:	:IncludeBinary "gfx\bluebar.bmp"
barend:		:IncludeBinary "gfx\barend.bmp"
raster:		:IncludeBinary "gfx\raster.bmp"
sotefont:	:IncludeBinary "gfx\rippedfnt.bin"
music:		:IncludeBinary "sfx\sote.sndh"
musend:

EndDataSection






; IDE Options = PureBasic 5.71 LTS (Windows - x86)
; CursorPosition = 32
; Folding = Q0
; EnableXP
; DisableDebugger
; EnablePurifier