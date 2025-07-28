
;-Replicants Dark Fusion Cracktro
;-Remake:	KrazyK 2018

;-Purebasic 5.62 source
;-set tabs to 8 for readability

;-This is a very simple cracktro remake from the Atari ST by The Replicants.
;-Copy the OSME library into you userlibraries folder (x86 only though).
;-This source is provided as is so feel free to use any of it as you wish.  
;-A credit is always nice though if you use any of it though ;-)

;-screen dimensions
#xres=640
#yres=480

#yoffset=40	;-keep the screen accuurate on 640x480.  Atari ST would be 320x200 doubled to 640x400 so there are 80 pixels extra which are then divided by to to make a 40 pixel border top and bottom
#scroll_len=380	;-pixel width of the scrolltext

InitSprite()

fs=0	;-windowed=0, fullscreen=1

If fs=0
	OpenWindow(0,0,0,#xres,#yres,"",#PB_Window_ScreenCentered|#PB_Window_WindowCentered|#PB_Window_BorderLess)
	OpenWindowedScreen(WindowID(0),0,0,#xres,#yres)
	StickyWindow(0,1)       ;-keep window on top
	ShowCursor_(0)          ;-hide the mouse
ElseIf fs=1
	OpenScreen(#xres,#yres,32,"")
Else
End
EndIf

Procedure InitGraphics()
        
CatchSprite(0,?logo)    			;-moving logo
CatchSprite(2,?main)    			;-main screen
Global angle.f          			;-variable for the logo movement

;- Scroller stuff
Global scroll$="               THE REPLICANTS OF THE UNION PRESENT DARK FUSION CRACKED AND TRAINED BY R.AL WITH A LITTLE INTRO CODED BY FURY (IN ONE NIGHT), GRAPHICS BY COBRA, MUSAK BY GREAT MAX WE CAME BACK FROM PARIS SATURDAY IN THE EVENING AFTER A THREE DAYS REPLICANTS MEETING WHERE WE DIDN'T SLEEP A LOT 'COSE THERE WAS A LOT OF GAMES TO CRACK AND A LOT OF X-MOVIES TO SEE... ONE DAY AFTER COBRA(ME) AND SNAKE DECIDED TO GO IN FURY HQ TO CODE THE INTRO YOU'RE NOW WATCHING.. HE WAS VERY ANGRY 'COSE HE WAS CODING SOME SCREENS FOR OUR FRENCHY DEMO, BUT AFTER SOME DISCUSSIONS HE FINALLY ACCEPT TO CODE AN INTRO. AFTER THIS LITTLE STORY NOW SOME GREETINGS TO OUR BEST FRIENDS AND CONTACTS : FIRST OF ALL GOLDEN REGARDS TO ALL MEMBERS OF THE UNION (ESPECIALLY TCB AND TEX).NORMAL GREETINGS TO : MCA, A-HA, THE MEDWAYS BOYS, BIG FOUR, AUTOMATION, REVOLUTION, FLEXIBLE FRONT, THE BROD, TSB, OMEGA, BLACK FLAME, CST, STM, SEWER SOFTWARE, SYNC, PHALANX, LOSTBOYS, DMA AND ALPHA FLIGHT OH, I FORGOT THERE HAVE BEEN SOME CHANGES IN THE REPLICANTS, HERE'S THE NEW MEMBERS LIST : R.AL, FURY, SNAKE, COBRA, ELWOOD, DOM, EXCALIBUR. AS YOU CAN SEE THERE'S A MISSING ON THE LIST : RATBOY . WE HAVE LOST A GREAT CODER AND CRACKER BUT NOT JUST US, THE ATARI ST HAS LOST HIM... GOOD LUCK ON ARCHIMEDES... I THINK IT'S NOW TIME TO WRAP.....                  "
Global speed=4					;-scroll text speed
Global xmove=512				;-start the scroller in the mouth !
Global xmin=130			        	;-end of scroller here
Global Letter=1			        	;-scroll text start
CreateSprite(3,(#scroll_len),14)		;-draw scrolltext on here in a straight line first
TransparentSpriteColor(3,#White)		;-white is transparent as we need to draw the font on top of the raster for the raster to show though


Global Dim position.b(#scroll_len)		;-create an array for the scroll y positions
CopyMemory(?ypos,@position(0),#scroll_len)	;-copy it into the array, don't bother using restore and read!
CatchImage(1,?font)				;-ripped font 16x14
CatchSprite(4,?raster)				;-ripped raster

EndProcedure

Procedure Scroller()
StartDrawing(SpriteOutput(3))                                   ;-draw the scrolltext on this sprite first in a straight line
For l=0 To 25                                                   ;-draw 26 characters
	ascii_val = Asc(UCase(Mid(scroll$, l+Letter, 1)))-32    ;-get the ascii value
	GrabImage(1,2,ascii_val*16,0,16,14)                     ;-grab a letter
	DrawImage(ImageID(2),xmove+(l*16),0)                    ;-draw it on our sprite
Next l
StopDrawing()

xmove-speed:If xmove=-(16*2):xmove=-16:Letter+1:EndIf	;-scroll left
If Letter=Len(scroll$):Letter=1:xmove=512:EndIf		;-check for text end

;-the raster and scrolltext are then cut up into 1x14 slices
;-the white text being displayed transparently on top of the raster so that the raster shows through.
For c=0 To #scroll_len-1
	ClipSprite(4,0,position(c),1,14)				;-grab a raster slice
	DisplayTransparentSprite(4,xmin+c,position(c)+216+#yoffset)	;-draw it
	ClipSprite(3,c,0,1,14)						;-grab a scroll slice
	DisplayTransparentSprite(3,xmin+c,position(c)+216+#yoffset)	;-draw it
Next c

EndProcedure

Procedure MoveLogo()

DisplayTransparentSprite(2,0,#yoffset)					;-main screen
logo_offset.f = 40 * Sin(angle.f) 					;-use a simple sine calculatio to move the logo
angle.f + 0.0525 							;-this is the movement speed
DisplayTransparentSprite(0,320-(SpriteWidth(0)/2),logo_offset+86)	;-draw the logo

EndProcedure


InitGraphics()

OSMEPlayMusic(?music,?musend-?music,1)

;-main loop start
Repeat
	If fs=0:event=WindowEvent():EndIf       ;only use for windowed screens
	ClearScreen(0)


	Scroller()              		;-draw the scroller first
	MoveLogo()              		;-then draw the main screen and moving logo
 

	FlipBuffers()
Until GetAsyncKeyState_(#VK_ESCAPE)
OSMEStopMusic()
End



DataSection

ypos:	:IncludeBinary"posdat.bin"	;-y position data for the text scroller.  The scroll length is 380 pixels wide between the mouths, so there are 380 bytes to read from the posdat.bin file.
font:	:IncludeBinary"gfx\font16.bmp"
raster:	:IncludeBinary"gfx\raster.bmp"
main:	:IncludeBinary"gfx\main.bmp"
logo:	:IncludeBinary"gfx\replogo.bmp"
music:	:IncludeBinary"sfx\syntax_terror_loader.sndh"
musend:

EndDataSection

; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 72
; FirstLine = 26
; Folding = 5
; EnableXP
; DisableDebugger