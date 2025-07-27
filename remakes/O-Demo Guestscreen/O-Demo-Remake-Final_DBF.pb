;O-Demo Guestscreen

;Converted most of this from the CODEF remake by Shiftcode with quite a few adjustments for Purebasic

;Original credits
;Bigfoot -  Code, Graphics
;Eternal -  Music
;Niko -     Graphics
;Wilfried - Graphics

;KrazyK: Purebasic remake

;Set compiler to directx9 for PB6 instead of dx9 for PB5.7+
;Feel free to use and abuse this code. 
;If you use any of this code in any of your prods then a credit is always nice! ;-)

InitSprite()
InitKeyboard()
InitSound()

Enumeration 
        #tmpimg
        #fader
        #BallImage
        #allsprites
        #mjj
        #balls
        #chains
EndEnumeration


;{ Init screen stuff 
;Thanks to Ttemper for this DPI aware code for PB
#xres = 640
#yres = 400
ExamineDesktops()
screenscale.f = DesktopScaledX(100) / 100
screenscalex.i = #xres / screenscale
screenscaley.i = #yres / screenscale
window = OpenWindow(0, 0, 0, #xres, #yres, "", #PB_Window_BorderLess | #PB_Window_ScreenCentered | #PB_Screen_NoSynchronization | #PB_Window_Invisible)
OpenWindowedScreen(WindowID(0), 0, 0, #xres , #yres, #True, 0, 0)
StickyWindow(0,1)
SetFrameRate(60)
SpriteQuality(#PB_Sprite_BilinearFiltering)

rx = #xres * 1.25/ screenscale
ry = #yres * 1.25/ screenscale
wxpos = WindowX(0) - ((rx - #xres) / 2) ; centralize new positions
wypos = WindowY(0) - ((ry - #yres) / 2)
ResizeWindow(0, wxpos, wypos, rx, ry)             ;open on right screen
HideWindow(0, #False)                             ; show the window
ShowCursor_(0)                                    ;hide mouse

;}

;{ Init mainscreen and scroller
; Init main vertical scroller
CatchSprite(#tmpimg,?font_img,#PB_Sprite_AlphaBlending) ;PB6 needs #PB_Sprite_AlphaBlending when using DisplayTransparentSprite.  PB5 didn't need this
Global Dim chars(90)    ;letter array
Global letter=1,vspeed=8,ytext=64*10
Global tval,trigger$
Global scrtxt$  = "HELLO FOLKS!   MJJPROD IS PROUD TO PRESENT YOU THIS SCREEN FOR OXYGENE'S O-DEMO!...       LET THE SHOW BEGIN.../                 HAVE A LOOK AT...  THIS!!!\           BEEEEERGL! I HATE THIS FLAG, IT REMINDS ME SOME BAD FACTS (MILITARY OBLIGATION)...           NOW HERE COMES A NEW VERTICAL-RASTERS EFFECT:     THE ROTATIVE RASTERS   @             YES AXEL, REMEMBER WHEN I TOLD YOU IT COULD BE DONE!          AND NOW HERE ARE SOME VICIOUS RASTERS DRAWNED BY NIKO #             WELL, I THINK IT'S TIME FOR... THAT!    ~        OF COURSE, WE WANT TO SEND SOME GREETINGS...       ~       ...I THINK THIS IS THE END NOW!       I'D LIKE TO THANK ONE MORE TIME LEONARD AND KRIPTON OF OXYGENE FOR BEING SIMPLY SUCH COOL PEOPLE...        WELL, I HAVE TO STOP NOW BECAUSE I HAVE SOME PHILO TO WORK (BEURK!)...     I SEE THE WRAP-TIME COMING...          BYE! SEE YA IN -ANOMALY- THE NEXT MJJPROD DEMO!...                 -MJJPROD- FEBRUARY EIGHTY TWO...                                                  "
DisplaySprite(#tmpimg,0,0)
i=0
For y=0 To 5
        For x=0 To 9
                chars(i)=GrabSprite(#PB_Any,x*64,y*64,64,64,#PB_Sprite_AlphaBlending)   ;read all letters in the array
                i+1
        Next x
Next y
ClearScreen(0)
FreeSprite(#tmpimg)
;Init the rest of the sprites and gfx

CatchSprite(#allsprites,?sprites,#PB_Sprite_AlphaBlending)
DisplaySprite(#allsprites,0,0)
Global BigBall=GrabSprite(#PB_Any,72,0,32,32,#PB_Sprite_AlphaBlending)           ;Bigball sprite to end of DNA balls
GrabSprite(#mjj,0,39,640,118,#PB_Sprite_AlphaBlending)                           ;MJJ logo
GrabSprite(#balls,0,9,72,16,#PB_Sprite_AlphaBlending)                            ;4 balls to clip later on the flagscreen()
Global Marble=GrabSprite(#PB_Any,0,167,64,40,#PB_Sprite_AlphaBlending)           ;Marble pipe
Global Stone=GrabSprite(#PB_Any,0,211,64,40,#PB_Sprite_AlphaBlending)            ;Stone pipe

Global adnRadius.f = 0, adnSpeed.f = 0.075, adnShift.f = #PI/2, adnStep.f = 0.2; DNA helix variables
Global a.f,b.f,x1.f,x2.f,isfront
CreateSprite(#fader,#xres,#yres,#PB_Sprite_AlphaBlending)                        ;use a sprite to fade in and out as PB 2D Drawing RGBA images is too slow!
TransparentSpriteColor(#fader,#White)                                            ;not black!!
Global fading=255,goFadein=0,goFadeout=0,nextscreen=0,newscreen=0,frcounter=0
ClearScreen(0)

;}

;{ Init Chains 

Procedure MakeChains(img,sp)

CreateSprite(sp,ImageWidth(img),470,#PB_Sprite_AlphaBlending)        
StartDrawing(SpriteOutput(sp))
y=-ImageHeight(img)
Repeat
  DrawImage(ImageID(img),0,y+ImageHeight(img))
  y+ ImageHeight(img)
Until y>470
StopDrawing()
FreeImage(img)
TransparentSpriteColor(sp,0)
EndProcedure

Structure chaindata
        ypos.l          ;Current position
        speed.l         ;speed
        height.i        ;height of pixel block
        rdest.l         ;right x dest
        ldest.l         ;left x dest
EndStructure
Global Dim chainData.chaindata(4)
CopyMemory(?cdata,@chaindata(0),(?datend-?cdata))

CatchImage(#chains,?chains)
;left side 
chainindex=0
With chainData(chainindex)
For i=104 To 100 Step -1
        GrabImage(#chains,#tmpimg,0,sy,64,\height)      ;grab part of the chains image
        sy+\height                                      ;grab +height of current
        MakeChains(#tmpimg,i)                           ;create the chain sprite
        chainindex+1
Next i
EndWith

;right side
chainindex=0
With chainData(chainindex)
For i=105 To 109
        GrabImage(#chains,#tmpimg,0,sy,64,\height)
        sy+\height
        MakeChains(#tmpimg,i)        
        chainindex+1
Next i
EndWith
FreeImage(#chains)
                                   
;}

;{ Init Pipes

; Declare and initialize global variables
Global.f ctrPipe      = 0.0
Global.f pipeSpeed    = 0.02
Global.f pipeIncr     = 0.01
Global.i pipeTexture  = 0

Structure Pipe
  x.i
  z.f
EndStructure

; Global variables
Global.f ctrPipe     = 0.0
Global.f pipeSpeed   = 0.02
Global.f pipeIncr    = 0.01
Global.i pipeTexture = 0
Global.i nbPipes     = 5
Global Dim trunk.Pipe(4) ; 5 pipes (0 to 4)
Global currentPipeImage = Marble
Global ctrFrame = 0   ;frame counter for the pipes screen
;}

;{ Init stars
; === Structures ===
Structure Vector3D
  x.f
  y.f
  z.f
EndStructure

Structure Nursery
  x1.f
  x2.f
  y1.f
  y2.f
  z1.f
  z2.f
EndStructure

Structure Star
  x.f
  y.f
  z.f
  v.f
EndStructure

; === Constants and Globals ===
#nbStars = 50
Global ctrField = 0
Global zfactor.f = 100.0

Global speedVector.Vector3D
speedVector\x = -4
speedVector\y = 0
speedVector\z = 0

Global Dim stars.Star(#nbStars - 1)
Global nursery.Nursery

Global Dim starTimingDurations.i(7)
starTimingDurations(0) = 200
starTimingDurations(1) = 100
starTimingDurations(2) = 200
starTimingDurations(3) = 100
starTimingDurations(4) = 300
starTimingDurations(5) = 500
starTimingDurations(6) = 20
starTimingDurations(7) = 100

Global NewList starTimingSteps.i()

; === Procedures ===
Procedure.f RandomRangeFloat(min.f, max.f)
  ProcedureReturn min + (max - min) * Random(10000) / 10000.0
EndProcedure

Procedure CreateStar(index)
  stars(index)\x = RandomRangeFloat(nursery\x1, nursery\x2)
  stars(index)\y = RandomRangeFloat(nursery\y1, nursery\y2)
  stars(index)\z = RandomRangeFloat(nursery\z1, nursery\z2)
  stars(index)\v = 2 + RandomRangeFloat(0, 2)
EndProcedure

; === Initialize Nursery Region and Stars ===
nursery\x1 = -250
nursery\x2 = 250
nursery\y1 = -150
nursery\y2 = 150
nursery\z1 = 20
nursery\z2 = 200

For i = 0 To #nbStars - 1
  CreateStar(i)
Next

; === Calculate Star Timing Steps ===
Define d.i = 0
For i = 0 To ArraySize(starTimingDurations())
  d + starTimingDurations(i)
  AddElement(starTimingSteps())
  starTimingSteps() = d
Next

;}

;{ Init Flag

#Rows = 12
#Cols = 29
#TileWidth = 18
#TileHeight = 16
; --- Structures ---
Structure DpPoint
  x.i
  dy.i
EndStructure

; --- Globals ---
Global Dim draPoints.DpPoint(#Rows - 1, #Cols - 1)
Global Dim flagPatterns.i(1, #Cols - 1)
Global flagtype=0       ;1=french flag

Global ctrFlag1.f = 0.3
Global flagSpeed1.f = 0.15
Global flagInc1.f = 0.2
Global ctrFlag2.f = 0.8
Global flagSpeed2.f = 0.18
Global flagInc2.f = 0.4
; --- Procedure to generate one line of points -
Procedure GenerateDpLine(row)
  Protected i
  Protected a.f = ctrFlag1
  Protected b.f = ctrFlag2
  Protected x.f = 20.0

  For i = 0 To #Cols - 1
    draPoints(row, i)\x = x + Int(20 * Sin(b))
    draPoints(row, i)\dy = Int(15 * Cos(a))
    x + 18
    a + flagInc1
    b + flagInc2
  Next

  ctrFlag1 + flagSpeed1
  ctrFlag2 + flagSpeed2
EndProcedure

; --- Initialize draPoints array ---
For i = 0 To #Rows - 1
  GenerateDpLine(i)
Next

; --- Initialize flagPatterns ---
For i = 0 To #Cols - 1
  flagPatterns(0, i) = 54
  If i < 10
    flagPatterns(1, i) = 0
  ElseIf i < 19
    flagPatterns(1, i) = 18
  Else
    flagPatterns(1, i) = 36
  EndIf
Next
;}

;{ Init credits

;Read all the text into an array to read later
Global credy          ;credit y position
Global credspeed=4    ;scroll speed
Global yrow=0,firstpart=0
Global Dim credits.s(200)
Restore creds
i=0
Repeat
        Read.s creds$
        If creds$="----"
                Break
        EndIf
        credits(i)=creds$
        i+1
ForEver

;}

Procedure FlagScreen()
  Protected i, j, x, y, frameX
  Protected a.f = ctrFlag1
  Protected b.f
    y = 28
    For i = 0 To #Rows - 1
      x = 15
      b = ctrFlag2
      For j = 0 To #Cols - 1
        If flagtype=1   ;french flag
        Select j
                Case 0 To 9
                ClipSprite(#balls,0,0,18,16)    ;blue
        Case 10 To 19
                ClipSprite(#balls,18,0,18,16)   ;white
        Case 20 To 27
                ClipSprite(#balls,18*2,0,18,16) ;red
EndSelect
Else
        
        ClipSprite(#balls,18*3,0,18,16)         ;blue only
EndIf
              
        DisplayTransparentSprite(#balls,32+draPoints(i, j)\x,y + draPoints(i, j)\dy)
        x + 21
        b + flagInc2
      Next j
      y + 30
      a + flagInc1
    Next i

  ; --- Roll draPoints up (simulate shift) ---
  For i = 0 To #Rows - 2
    For j = 0 To #Cols - 1
      draPoints(i, j) = draPoints(i + 1, j)
    Next
  Next

  ; --- Generate new bottom line (simulate push) ---
  GenerateDpLine(#Rows - 1)
   If goFadeout=0
  If frcounter=600 
          
          frcounter=0
          goFadeout=1
          newscreen=0
  Else
          frcounter+1
  EndIf
EndIf
  
  
EndProcedure

Procedure MakeCredits()
  ;9 rows at a time until the top row scrolls off then start the next read from 1 row down

If yrow<=162    ;not at the end yet?
yend=yrow+9     ;9 rows
c=0             ;row 0
For y= yrow To yend                 ;fill the screen + 2 lines
        cred$=credits(y)            ;next text
       
        For i=1 To Len(cred$)                   ;10 letters
                c$=UCase(Mid(cred$,i,1))        ;force upper case
                cval=Asc(c$)-32                 ;ascii value
                DisplayTransparentSprite(chars(cval),(i-1)*64,credy+(c*64))
        Next i                                  ;next letter
c+1                                             ;down 1 row
Next y                                          ;next line
EndIf

If credy=-(64*2)                        ;off the screen?
        credy=-64                       ;reset
        yrow+1                          ;nnew text line start
EndIf      


EndProcedure

Procedure ScrollCredits()
        
  MakeCredits()         ;9 rows at a time every cycle until 1 row scrolls off the top
  
  If firstpart=1 And yrow>=40           ;1=scroll up to greeting
          goFadeout=1
          newscreen=0
          firstpart=2                   ;2=done both
  Else
          credy-credspeed               ;scroll up
  EndIf

  
  If yrow>164         ;maximum reached?
          CallDebugger
          goFadeout=1   ;fade to black
          newscreen=0   ;main screen
          firstpart=0   ;first flag
          yrow=0        ;first row again
          credy=64*40   ;off the sreen
  EndIf
  
  
EndProcedure

Procedure Fadein()
  
  If fading>=0 And goFadein=1
    ;Use the black sprite as PB 2D drawing is too slow
    DisplayTransparentSprite(#fader,0,0,fading)  ;display the black sprite if not full opaque yet
    fading-2.55           ;keep fading down to transparent
    If fading<0
      fading=0
      goFadein=0            ;clear flag so we don't come here at all
      goFadeout=0           ;and this one (not needed?)
    EndIf
  EndIf
  
  
  
  
EndProcedure

Procedure Fadeout()
  
  If fading<=255; And goFadeout=1 ;max yet and flag set?
    ;Use the black sprite as PB 2D drawing is too slow
    DisplayTransparentSprite(#fader,0,0,fading)  ;display the black sprite if not full opaque yet
    fading+2.55             ;add to opacity
    If fading>255           ;max reached?
      fading=255            ;set to fully opaque
      goFadeout=0           ;clear flag so we dont come here at all
      goFadein=1            ;set the fade in flag to start in the main loop as soon as this one ends
      nextscreen=newscreen  ;finally set the new screen to the next one so it runs in the main loop
    EndIf
  EndIf
  
EndProcedure

Procedure.f Scale(StartFrom.f, EndFrom.f, StartTo.f, EndTo.f, Position.f)
  Protected LengthFrom.f = EndFrom - StartFrom
  Protected DistanceFrom.f = Position - StartFrom
  Protected LongueurTo.f = EndTo - StartTo
  
  If LengthFrom = 0 Or LongueurTo = 0
    ProcedureReturn StartTo
  EndIf

  Protected DistanceTo.f = DistanceFrom / LengthFrom * LongueurTo
  ProcedureReturn StartTo + DistanceTo
EndProcedure

Procedure DisplayStarfield()
  Protected i, x.f, y.f

  StartDrawing(ScreenOutput()) ; Or use ImageOutput() if using off-screen buffer
  For i = 0 To #nbStars - 1
    ; 2D projection
    x = 320 + (stars(i)\x / stars(i)\z) * zfactor
    y = 200 + (stars(i)\y / stars(i)\z) * zfactor

    ; Star visibility check
    If x >= 0 And x < 640 And y >= 0 And y < 400 And stars(i)\z > 100 And stars(i)\z < 200
      If stars(i)\z > 150
        Box(x, y, 2, 2, RGB(85, 85, 85))  ; "#555"
      Else
        Box(x, y, 2, 2, RGB(255, 255, 255)) ; "#fff"
      EndIf
    Else
      CreateStar(i)
    EndIf

    ; Move star
    stars(i)\x + stars(i)\v * speedVector\x
    stars(i)\y + stars(i)\v * speedVector\y
    stars(i)\z - stars(i)\v * speedVector\z
  Next i
  StopDrawing()

  ; Animate speed and direction
  ctrField + 1

  SelectElement(starTimingSteps(), 0)
  If ctrField < starTimingSteps()
    ; Do nothing
  ElseIf NextElement(starTimingSteps()) And ctrField < starTimingSteps()
    nursery\x1 = -350 : nursery\x2 = 350
    nursery\y1 = -200 : nursery\y2 = 200
    nursery\z1 = 100  : nursery\z2 = 100
    speedVector\x = Scale(PreviousElement(starTimingSteps()), starTimingSteps(), -4, 0, ctrField)
    speedVector\z = Scale(PreviousElement(starTimingSteps()), starTimingSteps(), 0, -1, ctrField)
  ElseIf NextElement(starTimingSteps()) And ctrField < starTimingSteps()
    ; No action
  ElseIf NextElement(starTimingSteps()) And ctrField < starTimingSteps()
    speedVector\y = Scale(PreviousElement(starTimingSteps()), starTimingSteps(), 0, -4, ctrField)
    speedVector\z = Scale(PreviousElement(starTimingSteps()), starTimingSteps(), -1, 0, ctrField)
  ElseIf NextElement(starTimingSteps()) And ctrField < starTimingSteps()
    nursery\x1 = -380 : nursery\x2 = 380
    nursery\y1 = 230  : nursery\y2 = 250
    nursery\z1 = 100  : nursery\z2 = 200
  ElseIf NextElement(starTimingSteps()) And ctrField < starTimingSteps()
    nursery\x1 = -350 : nursery\x2 = 350
    nursery\y1 = -200 : nursery\y2 = 200
    nursery\z1 = 120  : nursery\z2 = 180
    speedVector\x = 0
    speedVector\y = 1.8 * Sin((ctrField - PreviousElement(starTimingSteps())) / 36)
    speedVector\z = 1.8 * Cos((ctrField - PreviousElement(starTimingSteps())) / 36)
  ElseIf NextElement(starTimingSteps()) And ctrField < starTimingSteps()
    speedVector\x = 0
    speedVector\y = 0
    speedVector\z = 0
  ElseIf NextElement(starTimingSteps()) And ctrField < starTimingSteps()
    speedVector\x = Scale(PreviousElement(starTimingSteps()), starTimingSteps(), 0, -4, ctrField)
  Else
    nursery\x1 = 300 : nursery\x2 = 380
    nursery\y1 = -200 : nursery\y2 = 200
    nursery\z1 = 20  : nursery\z2 = 200
    ctrField = 0
  EndIf
EndProcedure

Procedure DisplayPipes()
  Protected i, j, y, cycle
  Protected.f a, b

  a = ctrPipe
  cycle = pipeTexture

  For y = 0 To 398 Step 2
    If cycle >= 40
      cycle - 40
    EndIf

    b = a
    For i = 0 To nbPipes - 1
      trunk(i)\z = Cos(b)
      trunk(i)\x = 312 + Int(100 * Sin(b))
      b + 2 * #PI / nbPipes
    Next i

    ; Sort trunk() by z descending
    For i = 0 To nbPipes - 2
      For j = i + 1 To nbPipes - 1
        If trunk(j)\z > trunk(i)\z
          Swap trunk(i)\z, trunk(j)\z
        EndIf
      Next j
    Next i

    ; Draw pipe slices
    For i = 0 To nbPipes - 1
            ; Grab and draw 64x2 slice from currentPipeImage at offset 'cycle'
            ClipSprite(currentPipeImage, 0, cycle, 64, 2)
            DisplayTransparentSprite(currentPipeImage,trunk(i)\x, y)
    Next i

    cycle + 2
    a - pipeIncr
  Next y

  pipeTexture - 2
  If pipeTexture < 0
    pipeTexture + 40
  EndIf

  ctrPipe - pipeSpeed
  
  If goFadeout=0
  If frcounter=600 
          
          frcounter=0
          goFadeout=1
          newscreen=0
  Else
          frcounter+1
  EndIf
EndIf
  
EndProcedure

Procedure VertScroll()
        
For i=0 To 9
               
    t$=Mid(scrtxt$,letter+i,1)  ;read 1 letter
      If goFadeout=0            ; if we're not fading
        Select t$               ;check for control characters
          Case "/"              ;flagscreen trigger
          goFadeout=1           ;trigger the fade to black in the main loop
          newscreen=1           ;flagscreen1
          fading=0:frcounter=0  ;no fade, reset frame counter
          flagtype=0            ;blue flag
          
          Case "\"              ;flagscreen trigger
          goFadeout=1           ;trigger the fade to black in the main loop
          newscreen=1           ;flagscreen
          fading=0:frcounter=0  ;no fade, reset frame counter
          flagtype=1            ;french flag
          
        Case "@"                ;pipescreen trigger
          goFadeout=1           ;trigger the fade to black in the main loop
          newscreen=2           ;pipescreen
          fading=0:frcounter=0  
          currentPipeImage = Marble
          
          Case "#"              ;pipescreen triger
          goFadeout=1           ;trigger the fade to black in the main loop
          newscreen=2           ;pipescreen
          fading=0:frcounter=0
          currentPipeImage = Stone
          
        Case "~"                ;credits scroller trigger
          goFadeout=1           ;trigger the fade to black in the main loop
          newscreen=3           ;credits scroller
          If firstpart=0        ;not doe this screen yet?
                firstpart=1     ;go until the greetings part
                credy=64*7      ;start off the bottom
                yrow=0          ;start at beginning of text
        EndIf
        fading=0:frcounter=0    ;no fade,reset framecounter
         
        EndSelect
EndIf
tval=Asc(Mid(scrtxt$,letter+i,1))-32    ;get the ascii value of the bnext vertical scrollertext              
If tval<0 Or tval>60:tval=0:EndIf       ;make it valid       
DisplayTransparentSprite(chars(tval),290,ytext+(64*i))
Next i

ytext-vspeed    ;scroll up
If ytext=-128:ytext=-64:letter+1:EndIf  ;off the screen yet,next letter
If letter=Len(scrtxt$):letter=1:ytext=400:credy=400:firstpart=0:EndIf   ;end of text, reset
        


        
EndProcedure

Procedure DrawDNA(isFront)
ClipSprite(#balls,0,0,18,16)          ;littleball
a=adnRadius
For y=-16 To 400 Step 32
        a+adnStep
        x1 = 312 + ~~100*Sin(a)-8
        x2 = 312 + ~~100*Sin(a + adnShift)-8
 If isFront=#True And x1<x2
    DisplayTransparentSprite(BigBall,x2,y)
    b=a
    For i=0 To 7
            b+adnShift/8
           DisplayTransparentSprite(#balls,312 + ~~100*Sin(b),y+8)
    Next i
    DisplayTransparentSprite(BigBall,x1,y)
 EndIf

 If isFront=#False And x1>=x2
    DisplayTransparentSprite(BigBall,x1,y)
    b=a
    For i=0 To 7
            b+adnShift/8
            DisplayTransparentSprite(#balls,312 + ~~100*Sin(b),y+8)
    Next i
 DisplayTransparentSprite(BigBall,x2,y)
 EndIf
Next y

EndProcedure

Procedure DisplayChains()
;start at the back and draw forward        
i=0
left=105
right=104
With chainData(i)
        For i=0 To 4    
        DisplayTransparentSprite(right,\rdest,\ypos):\ypos+\speed:If \ypos>=0:\ypos=-\height:EndIf
        DisplayTransparentSprite(left,\ldest,\ypos)
        right-1
        left+1
Next i
EndWith
        
EndProcedure

Procedure MainScreen()
        
  displayChains()
  drawDNA(#False); // DNA part in back
  VertScroll()
  drawDNA(#True); // DNA part in front
  adnRadius + adnSpeed;    
        
  
EndProcedure

Procedure Pipescreen()

        displayStarfield()
        displayPipes()
        
EndProcedure

DisplaySprite(#mjj,0,140)
FlipBuffers()

CatchSound(0,?laugh_snd)
PlaySound(0)
Delay(1500)
FreeSprite(#mjj)
FreeSound(0)

OSMEPlay(?music,?musend-?music,2)
OSMESetVolume(100)

;Use a jump table to store the address of the routines to call in the main loop
Dim JumpTable(3)
JumpTable(0)=@MainScreen()
JumpTable(1)=@FlagScreen()
JumpTable(2)=@pipescreen()
JumpTable(3)=@ScrollCredits()

nextscreen=0    ;mainscreen
goFadein=1      ;fade in from black

; ======================  Main loop ================================
Repeat  
        event=WindowEvent()
        ClearScreen(0)
        
        ;jump to the routine address, this is much neater then using If/Endif or Select/Case 
        CallFunctionFast(JumpTable(nextscreen))
        
        Fadein()        ;screen will fade in if it isn't already 
  
        If goFadeout=1  ;fade out if the flag has been set to fade
          Fadeout()
        EndIf       
        
        FlipBuffers()
        
        ExamineKeyboard()
        If KeyboardReleased(#PB_Key_F2)
                SetWindowState(0,#PB_Window_Maximize)
        EndIf
        If KeyboardReleased(#PB_Key_F1)
                SetWindowState(0,#PB_Window_Normal)
        EndIf
        
Until KeyboardReleased(#PB_Key_Escape)


DataSection
 font_img:      :IncludeBinary "gfx\adn-font-64x64.bmp"
 sprites:       :IncludeBinary "gfx\spritesheet.bmp"
 chains:        :IncludeBinary "gfx\allchains.bmp"
 laugh_snd:     :IncludeBinary "sfx\rire.wav"
 laughend:
 
 music:         :IncludeBinary "sfx\No_Buddies_Land.sndh"
 musend:
 
;Chain data 
cdata:;ypos,speed,height,rdest,ldest
Data.l    0, 2, 40, 448, 128
Data.l    0, 3, 48, 480, 96
Data.l    0, 4, 56, 512, 64
Data.l    0, 6, 64, 544, 32
Data.l    0, 8, 72, 576, 0
datend:        


creds:
Data.s  "          "
Data.s  "Coding    "
Data.s  "   Bigfoot"
Data.s  "          "
Data.s  "          "
Data.s  "Grafix    "
Data.s  "          "
Data.s  "          "
Data.s  "      Niko"
Data.s  "   Bigfoot"
Data.s  "          "
Data.s  "          "
Data.s  "Muzak     "
Data.s  "   Eternal"
Data.s  "          "
Data.s  "          "
Data.s  "  Intro:  "
Data.s  "          "
Data.s  "          "
Data.s  "Logo      "
Data.s  "  Wilfried"
Data.s  "          "
Data.s  "          "
Data.s  "Sound     "
Data.s  "  Les nuls"
Data.s  "          "
Data.s  "          "
Data.s  "Members of"
Data.s  " Mjj-prod "
Data.s  "          "
Data.s  "          "
Data.s  "  Blinis  "
Data.s  "   Niko   "
Data.s  " Wilfried "
Data.s  "  Ultra   "
Data.s  " Bigfoot  "
Data.s  "  Fel'X   "
Data.s  "  Joker   "
Data.s  "Godfather "
Data.s  "  Smith   "
Data.s  "   WWP    "
Data.s  "          "
Data.s  " but most "
Data.s  " are only "
Data.s  "sleeping!!"
Data.s  "          "    ;stop first credits screen from scrolling here
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "Greetings:"
Data.s  "          "
Data.s  " OXYGENE  "
Data.s  "          "
Data.s  "especially"
Data.s  " Leonard  "
Data.s  " Kripton  "
Data.s  "  Lester  "
Data.s  "   Nap    "
Data.s  "          "
Data.s  "   KASS'  "
Data.s  " BURNETT! "
Data.s  "          "
Data.s  "Gero - Sly"
Data.s  "          "
Data.s  "   VMAX   "
Data.s  "          "
Data.s  "Mikou  Tst"
Data.s  "Fra Altair"
Data.s  "          "
Data.s  "HEMOROIDS "
Data.s  "          "
Data.s  "   Axel   "
Data.s  " Sink-Ajt "
Data.s  "   Dieu   "
Data.s  " Nucleus  "
Data.s  " Stranger "
Data.s  "(big head)"
Data.s  "          "
Data.s  "   TMS    "
Data.s  "          "
Data.s  " Epsilon  "
Data.s  "   Epic   "
Data.s  "Starfield "
Data.s  "  Vixit   "
Data.s  "          "
Data.s  "  CRAP A  "
Data.s  "  DOODLE  "
Data.s  "          "
Data.s  "Crapsister"
Data.s  "          "
Data.s  "  ANIMAL  "
Data.s  "   MINE   "
Data.s  "          "
Data.s  "I hate the"
Data.s  " compils! "
Data.s  "          "
Data.s  "  GUDUL   "
Data.s  "          "
Data.s  "  SAMOS   "
Data.s  " BOULDOG  "
Data.s  "          "
Data.s  "cool party"
Data.s  "          "
Data.s  " ADSO-OVR "
Data.s  "          "
Data.s  " for the  "
Data.s  "hairstyle!"
Data.s  " is your  "
Data.s  " brother  "
Data.s  "like you? "
Data.s  "          "
Data.s  "  NINJA-  "
Data.s  "  TURTLE  "
Data.s  "          "
Data.s  "don't you "
Data.s  "remember?"
Data.s  "   NEXT   "
Data.s  "          "
Data.s  "For being "
Data.s  "so late!! "
Data.s  "Mit - Lap "
Data.s  "          "
Data.s  "   ZUUL   "
Data.s  "          "
Data.s  "Thanks for"
Data.s  " the NTM! "
Data.s  "          "
Data.s  " EUPHORIA "
Data.s  "          "
Data.s  "  Do you  "
Data.s  " remember "
Data.s  "the triso "
Data.s  "  at the  "
Data.s  " Snork??? "
Data.s  "It was me!"
Data.s  "          "
Data.s  " DATAMAN  "
Data.s  "          "
Data.s  "Hi folk!! "
Data.s  "          "
Data.s  " TURKISH  "
Data.s  "  TOILETS "
Data.s  "          "
Data.s  " Koin and "
Data.s  " Gobitof! "
Data.s  "          "
Data.s  "L         "
Data.s  " E        "
Data.s  "  G       "
Data.s  "   U      "
Data.s  "    M     "
Data.s  "     A    "
Data.S  "      N   "
Data.s  "          "
Data.s  "R         "
Data.s  " U        "
Data.s  "  L       "
Data.s  "   E      "
Data.s  "    S     "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "
Data.s  "          "

Data.s  "----"
credend:
EndDataSection


; IDE Options = PureBasic 6.21 (Windows - x86)
; CursorPosition = 10
; Folding = AAAA-
; Optimizer
; EnableXP
; UseIcon = main.ico
; Executable = MJJ_O_Demo.exe
; SubSystem = directx9
; DisableDebugger
; HideErrorLog
; CompileSourceDirectory
; Compiler = PureBasic 6.21 (Windows - x86)
; IncludeVersionInfo
; VersionField0 = 1
; VersionField1 = 1
; VersionField2 = KrazyK
; VersionField3 = O Demo Guestscreen - Win32 Remake
; VersionField4 = 1
; VersionField5 = 1
; VersionField6 = O Demo Guestscreen - Win32 Remake
; VersionField7 = O Demo Guestscreen - Win32 Remake
; VersionField8 = MJJ_O_Demo.exe
; VersionField9 = KrazyK
; VersionField10 = KrazyK