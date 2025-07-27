
#RAD = 0.0175
Global max=500
#PI2 = #PI * 2

;
UseJPEG2000ImageDecoder() : 
UsePNGImageDecoder():
InitMouse() 
Macro EMs()
  ElapsedMilliseconds()
EndMacro

If InitSprite() = 0 Or InitKeyboard() = 0
  MessageRequester("Error", "Can't open DirectX 7 or later", 0)
  End
EndIf

result=MessageRequester("Do you want full screen?","Do you want real full screen?"+#LF$+"In windowed mode press space for psuedofullscreen.",#PB_MessageRequester_YesNoCancel)
Select result
  Case #PB_MessageRequester_Yes
    Global fs=1
  Case #PB_MessageRequester_Cancel
    End
  Default
    Global fs=0
EndSelect


Structure XY
  X.f
  Y.f
EndStructure


Declare DoLogo()

Structure T_PINGPONG
  min.i
  max.i
  counter.i
  direction.i
  delay.i
  inc.i
  val.i
EndStructure

Structure sVector
  c.XY
  angle.f
EndStructure

Structure player
  direction.sVector
  speed.f
  type.l
  state.l
  color.i
EndStructure

Structure UpText
  id.i
  text.s
  x.i
  y.F
  color.l
  intensity.i
EndStructure

IncludeFile"186text.pb"		;-this is our text taken from the Atari ST original 40x17
Global LetterCount        ;-maximum of 40 per line then reset
Global TexLen=Len(T$)     ;-total string length
Global txpos,typos        ;-x and y positions of the text
Global CurrentLetter=1    ;-start of the message

;Delay(60)

Global Dim pl1.player(max)
Global pl2.player,logo,tintensity=255
Global PP1.T_PINGPONG ; the vector from the two points
Global PP2.T_PINGPONG ; the vector from the two points
Global PP3.T_PINGPONG ; the vector from the two points
Global PP4.T_PINGPONG
Global pl2\direction\c\x = 400
Global pl2\direction\c\y = 600
Global muslen=?musend-?music			;-music lengths
Global muslen1=?musend1-?music1   ;-music lengths
Global muslen2=?musend2-?music2   ;-music lengths
Global muslen3=?musend3-?music3   ;-music lengths
Global V1,OLDV1,V2,OLDV2,V3,OLDV3 ;-variables for the VU channels
Global MOSM=PurePROCS_OpenLibrary(?osmlib)    			;-Return the library address
Global *Play=PurePROCS_GetFunction(MOSM,"playOSMEMusicMem") 	;-Return the address of the play function
Global *GetVU=PurePROCS_GetFunction(MOSM,"getOSMEChannelVU")  ;-Return the address of the channel volume function
Global wiggle.f,ending=0,ended=0
Global pause=0,MoveOutFlag=0
Global TM=0,TM2=0,TM3=0,LTM1,LTM=0	;-timer variables
Global Fader=0,LY=0, StarsOn=1,STM
Global top=380,sin.f = 0.0,dir = 0,add.f=0,bpos = 0,sinA.f=0,T=0,g_angleadd.f=0
Global angleStep.f = Radian(0.9), angle.f, radius,inc,down,anglel.f
Global LogoDone
Global Ball_on=1



pp1\min=320
pp1\max=320
pp1\delay=0
pp1\inc=0
pp1\delay=1

pp2\min=10
pp2\max=200
pp2\inc=0

pp3\min=20
pp3\max=20
pp3\inc=1
pp3\delay=250

Procedure Get16Font()			;-Grab out 15x16 font
  
  CatchImage(1000,?font)		
  
  ;-yes I know I could store all these in ar array but the intro is very small and it's just far easier to use the 
  ;-ascii values of the font and have them all pre-captured.  Old 68000 habits do die hard.
  SPR=0
  For y=0 To ImageHeight(1000)-1 Step 16
    For X=0 To ImageWidth(1000)-1 Step 16
      GrabImage(1000,SPR,X,y+2,15,16)
      SPR+1
    Next X
  Next y
  
  ;Image 61 is our white cursor sprite
  
  FreeImage(1000)
  
EndProcedure


Procedure V2_VectorFromPoints (*p1.player, *p2.player, *vout.XY)
  *vout\X = *p2\direction\c\X - *p1\direction\c\x
  *vout\Y = *p2\direction\c\Y - *p1\direction\c\Y
EndProcedure

Procedure addMovement( *V.sVector, speed.f )
  *V\c\x + Cos( *V\angle * #RAD )/2 * speed
  *V\c\y + Sin( *V\angle * #RAD ) * speed
EndProcedure

Procedure.f findangle(x1.f,y1.f,x2.f,y2.f) 
  
  Protected a.f,b.f,c.f,angle.f
  a.f = x1-x2 
  b.f = y2-y1 
  c.f = Sqr(a*a+b*b) 
  angle.f = ACos(a/c)*57.29577 
  If y1 < y2 
    angle=360.0-angle
  EndIf 
  
  ProcedureReturn angle.f
EndProcedure

Procedure.i PingPong (*p.T_PINGPONG)
  
  If *p\val>*p\delay
    If *p\direction = 0
      *p\direction = *p\inc
      *p\counter = *p\min
    Else
      *p\counter + *p\direction   
      If *p\counter =< *p\min 
        *p\direction = 0
      ElseIf *p\counter >= *p\max
        *p\direction = -*p\direction
        ;EndIf
        
      EndIf
      *p\val=0
    EndIf   
  Else
    *p\val + 1
  EndIf
  
  ProcedureReturn *p\counter
EndProcedure


If fs=1
  OpenScreen(640, 480, 16, "Worms")
  Delay(2000)
Else
  OpenWindow(0,140,180,640,480,"Worms",#PB_Window_NoGadgets|#PB_Window_BorderLess|#PB_Window_ScreenCentered)
EndIf

If fs=0
  OpenWindowedScreen(WindowID(0),0,0,640,480,#True,0,0)
EndIf

Global textarea=CreateSprite(#PB_Any,640,(16*17))	;-blank sprite to draw the text on  
Global textback=CreateSprite(#PB_Any,640,(16*17))
Procedure Fade1()
  If Fader=1						;-has the flag been set to start the first part of the fading routine?
    If ElapsedMilliseconds()-TM2>30/2		;-only draw a line afer the given time period
      TM2=ElapsedMilliseconds()         ;-reset the timer for the next line
      StartDrawing(SpriteOutput(textback))	;-draw the line directly on the text sprite
      Box(0,LY,640,2,RGB(0,0,0))            ;-drawing a box is more effective than drawing a line!
      StopDrawing()
      LY+4						;-next line for next time around
      If LY>SpriteHeight(textback)			;-have we reached the bottom of the sprite?
        Fader=2                         ;-set another flag to start the second fade part upwards
        LY=SpriteHeight(textback)-2     ;-re-position the box drawing co-ordinates
      EndIf
    EndIf
  EndIf	
EndProcedure

Procedure Fade2()
  
  If Fader=2				;-same goes here as for the downwards fade routines
    If ElapsedMilliseconds()-TM2>30/2
      
      TM2=ElapsedMilliseconds()
      
      StartDrawing(SpriteOutput(textback))
      Box(0,LY,640,4,RGB(0,0,0))
      StopDrawing()
      LY-4
      If LY<=0			;-reached the top of the sprite?
        Fader=0     ;-no more fadeing to be done thank you!
        pause=0     ;-no longer paused
        txpos=0:typos=0		;-reset the text writer back to the top left of the sprite
      EndIf
    EndIf
  EndIf
  
EndProcedure

Procedure.l KeyboardHit( KeyName.l )
  Static Dim KeyFlag.b(255)
  If KeyboardPushed(KeyName)
    If KeyFlag(KeyName) = 0
      KeyFlag(KeyName) = 1
      ProcedureReturn 1
    Else
      ProcedureReturn 0
    EndIf
  Else
    KeyFlag(KeyName) = 0
    ProcedureReturn 0
  EndIf
EndProcedure

Procedure TextWriter()				
  If ElapsedMilliseconds()-TM>60/4				;-only draw a character every 60*2 ms.  (Change this to speed it up or down)
    TM=ElapsedMilliseconds()              ;-restart the timer
    StartDrawing(SpriteOutput(textback))  ;-draw all the text on on top of a sprite, then when finished use DisplayTransparentSprite to show it
    MVAL=Asc(Mid(T$,CurrentLetter,1))-32  ;-get our ascii value
    DrawImage(ImageID(61),(txpos+1)*16,typos*16,16,16)	;-draw the white cursor in front of the letter first
    DrawImage(ImageID(MVAL),txpos*16,typos*16,16,16)    ;-now draw our letter behind the cursor
    StopDrawing()
    
    CurrentLetter+1						;-counter for the line.  max=40
    LetterCount+1             ;-total number of letters drawn
    If LetterCount>=TexLen:LetterCount=0:CurrentLetter=1:pause=1:txpos=0:Fader=1:typos=0:ProcedureReturn: EndIf	;-pause=4.  this will end the textwriter routine and just display the last page
    
    txpos+1							;-move along the sprite by 1*16 px to the right
    If txpos=40         ;-reached end of the line yet?
      txpos=0           ;-if so then zero x position back to the start of the line
      typos+1:If typos=17:pause=1:Fader=1		;-reached maximum mnumber of rows down yet?  Then start the fading routine
        TM3=ElapsedMilliseconds()           ;-start the timer as there is a slight pause before fading
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure UPscroll()
  
  If pause=1 And ElapsedMilliseconds()-TM3>3000	;-start doing the fade routines if the flag has been set
    TM3=0
    Fade1()
    Fade2()
  EndIf
  
  
  If pause=4:Goto TextIt:EndIf			;-end of text then don't do the text writer, just pause forever
  If pause=0:TextWriter():EndIf     ;-do the text writer effect
  
  TextIt:	
  
  DisplayTransparentSprite(textback,00,00,tintensity)		;-text writer sprite that we have drawn on
                                                        ;-text writer sprite that we have drawn on
  
EndProcedure

Procedure SetUpStars()
  
  For a = 0 To max
    pl1(a)\direction\c\x = Random(749)
    pl1(a)\direction\c\y = Random(599)
    ; pl1(a)\speed = Random(4,1)
    pl1(a)\state = PingPong(@pp3)
    pl1(a)\type=Random(5,1)
    
    pl1(a)\speed=pl1(a)\type
    pl1(a)\state= pl1(a)\speed 
    ;   If  pl1(a)\type>2
    ;     r=100:g=100:b=100
    ;   Else
    ;     r=255:g=255:b=255
    ;   EndIf
    ;   
    If  pl1(a)\type<3
      If pingpong(@pp4)=1
        r=100:g=100:b=100
      Else
        
        r=255:b=100:g=255
      EndIf
      ;       ElseIf pl1(a)\type=3
      ;         
      ;         pl1(a)\type=v1
      ;         r=100:g=100:b=255
    Else
      If pingpong(@pp4)=2
        r=222:g=222:b=255
      Else
        
        r=100:g=100: b=100
      EndIf
      ; r=255:g=255:b=255
    EndIf
    pl1(a)\speed =pl1(a)\type
    pl1(a)\color=RGB(g,0,Random(b,1))
    
  Next
EndProcedure

Procedure GetChannelBoxes()
  ;-Create some coloured boxes to draw the vu lines on
  CreateImage(501,96,32)
  StartDrawing(ImageOutput(501))
  Box(0,0,96,34,RGB(0,64,0))
  StopDrawing()
  
  CreateImage(502,96,34)
  StartDrawing(ImageOutput(502))
  Box(0,0,96,34,RGB(0,64,0))
  StopDrawing()
  
  CreateImage(503,96,34)
  StartDrawing(ImageOutput(503))
  Box(0,0,96,34,RGB(0,64,0))
  StopDrawing()
  
  
  
EndProcedure


Procedure ReplayMusic(Addr,muslen,tune)
  ;-Can't get rid of the slight pause between stopping and starting the routine.  it's how it is!
  PurePROCS_CloseLibrary(MOSM)				;-just close the replay library.  Sometime when the music it stopped it generates an error!
  MOSM=PurePROCS_OpenLibrary(?osmlib) ;-re-open the library
  *Play=PurePROCS_GetFunction(MOSM,"playOSMEMusicMem")	;-get the function address
  *GetVU=PurePROCS_GetFunction(MOSM,"getOSMEChannelVU") ;-get the function address
  CallCFunctionFast(*Play,Addr,muslen,tune)             ;-now play dat toon!
EndProcedure

Procedure GetVuValue()
  Global V1=Mod(CallCFunctionFast(*GetVU,0),20)
  Global V2=Mod(CallCFunctionFast(*GetVU,1),20)
  Global V3=Mod(CallCFunctionFast(*GetVU,2),20)
EndProcedure

Procedure VuMeters()
  Static scrollin1=-600
  Static scrollin2=-650
  Static scrollin3=-700
  
  i.f=550
  k=0
  If scrollin1<0
    scrollin1+2
  EndIf
  If scrollin2<50
    scrollin2+2
  EndIf
  If scrollin3<50
    scrollin3+2
  EndIf
  
  If ending=1
    
    ; If scrollin1<0
    scrollin1+5
    ;  EndIf
    ; If scrollin2<50
    scrollin2+7
    ; EndIf
    ; If scrollin3<50
    scrollin3+9
    ; EndIf
    Debug scrollin3
    If scrollin3>500
      LogoDone=0
      MoveOutFlag=1
    EndIf
    
    
  EndIf
  
  
  Repeat
    ; i+1
    k+1
    ;     If wiggle<=top And dir=0
    ;       wiggle+0.01
    ;       If wiggle>top
    ;         wiggle=0
    ;       EndIf
    ;     Else
    ;       wiggle-0.01
    ;       If wiggle<=0
    ;         dir=0
    ;       EndIf
    ;       
    ;     EndIf;
    ;wiggle=top
    sin.f + 0.05
    ;    ClipSprite( 13, 1, 1, 128, k )
    
    V1=CallCFunctionFast(*GetVU,0)
    V2=CallCFunctionFast(*GetVU,1)
    V3=CallCFunctionFast(*GetVU,2)
    
    x1=Sin(sin.f*(0.5)*v1)*v1;*( 5.3*Mod(V1,10))
    x2=Sin(sin.f*(0.5)*v2)*v2; Sin(sin.f-(wiggle/0.23));*( 5.3*Mod(V2,10))
    x3=Sin(sin.f*(0.5)*v3)*v3; Sin(sin.f-(wiggle/0.23));*( 5.3*Mod(V3,10))
    
    DisplayTransparentSprite(913, b+20+x1,scrollin1-20+k,(v1*20),RGB(55-v1,255-V1,v1*30 )) 
    
    DisplayTransparentSprite(913, b+80+x2,scrollin2-60+k,(v2*20),RGB(255-v2,055-V2,v2*30 ) )      
    DisplayTransparentSprite(913, b+140+x3,scrollin3-80+k,(v3*20),RGB(v3*30,0,155-V3 )  )  
    
    k+4
  Until k=>490
  
  
  
  
EndProcedure

Procedure Balls(on)
  Static.i splice=580,x,y
  Static.f angle,radiusa,c,s,intensity=0
  
  If on=1
    If intensity<155
      intensity+0.505
    EndIf
    
    angleStep.f = Radian(0.9)
    splice+1
    ;     
    ;   If intensity<100
    ;     intensity+0.1
    ;   EndIf
    
    For count= 0 To 19 Step 1
      
      c = Cos(angle+(count/#PI))
      s = Sin(angle+(count/#PI))
      
      For radius = 0 To 650 Step 25
        
        radius+radiusa
        
        x = radius * c + 320 ;+ (c*c ) 
        y = radius * s + 240 ;+ (s*s ))
        
        DisplayTransparentSprite(88, x,y,intensity)
        
      Next
    Next 
    
    ;radiusa+0.101
    ;   If radiusa<-1500827
    ;     radiusa=1
    ;   EndIf
    
    angle + angleStep
    
    If angle > #PI2
      angle - #PI2
      
    EndIf
  EndIf
  
EndProcedure

Procedure Stars()
  
  
  
  StartDrawing(ScreenOutput())
  
  V2_VectorFromPoints (@pl1, @target, @V)
  
  For a = 0 To max
    
    pl1(a)\direction\angle=findangle(pl2\direction\c\x,pl2\direction\c\y,pl1(a)\direction\c\x,pl1(a)\direction\c\y)
    
    addMovement(@pl1(a)\direction,pl1(a)\speed*2)
    
    If pl1(a)\direction\c\y>599 And pl1(a)\direction\c\y<601 Or pl1(a)\direction\c\x>400 And pl1(a)\direction\c\x<401;pl1(a)\type=0
      If StarsOn=1
        num=Random(4,1)
        If num=1
          pl1(a)\direction\c\x = -20 + Random(800)
          pl1(a)\direction\c\y = 0
          
        ElseIf num = 2
          pl1(a)\direction\c\x = -20+Random(800)
          pl1(a)\direction\c\y = -10
          
        ElseIf num = 3     
          pl1(a)\direction\c\x = -20
          pl1(a)\direction\c\y = -20 + Random(600)
          
        Else
          pl1(a)\direction\c\x = 640
          pl1(a)\direction\c\y = -20 + Random(600)
          
        EndIf
        
        pl1(a)\type=Random(5,1)
      EndIf
      
      If  pl1(a)\type<3
        If pingpong(@pp4)=1
          r=100:g=100:b=100
        Else
          
          r=255:b=100:g=255
        EndIf
        ;       ElseIf pl1(a)\type=3
        ;         
        ;         pl1(a)\type=v1
        ;         r=100:g=100:b=255
      Else
        If pingpong(@pp4)=2
          r=222:g=222:b=255
        Else
          
          r=100:g=100: b=100
        EndIf
        ; r=255:g=255:b=255
      EndIf
      pl1(a)\speed =pl1(a)\type
      pl1(a)\color=RGB(g,0,Random(b,1))
      ;EndIf
      
    EndIf
    
    RoundBox(pl1(a)\direction\c\x,pl1(a)\direction\c\y,pl1(a)\type*2,pl1(a)\type*2,pl1(a)\type*v1*2,pl1(a)\type*2*v1,Pl1(a)\color)
    
  Next
  
  StopDrawing()
  
  pl2\direction\c\X=PingPong(@PP1)
  
  
EndProcedure

Procedure CreateImages()
  ;   CreateImage (0,640,480) ; Create Background
  ;   StartDrawing(ImageOutput (0))
  ;   DrawingMode ( #PB_2DDrawing_Gradient )
  ;   BackColor (0)
  ;   ;FrontColor ($FF901E)
  ;   ;LinearGradient (0,-300,0,1500)
  ;   ; Box (0,0,640,480)
  ;   StopDrawing()
  ;   
  ; Creating test scrolly
  CreateSprite( 913, 128, 128)
  ; LoadFont(1, "Arial", 32 )  
  
  
  StartDrawing( SpriteOutput( 913 ) ) 
  DrawingMode(#PB_2DDrawing_Gradient)      
  BackColor($0000FF)
  
  FrontColor($FF0000)
  
  ; DisplayTransparentSprite(1,5,5)
  CircularGradient(8, 8, 8)     
  
  Circle(16,16,14)
  
  StopDrawing()
  
  logoin=CatchImage(#PB_Any,?logo)
  
  CreateSprite(666, 640, 250)
  
  If StartDrawing(SpriteOutput(666))
    DrawImage(ImageID(logoin),20,40)
    ;Box(0, 0, 20, 20, RGB(255, 0, 155))
    ;Box(5, 5, 10, 10, RGB(155, 0, 255))
    StopDrawing()
    Debug "oh"
  EndIf
  
  ;   logoa=CatchImage(#PB_Any,?logo)
  ;   StartDrawing(SpriteOutput(logo))
  ;   DrawImage(logoa,5,50,500,200)
  ;   StopDrawing()
  ;   
  CreateSprite(88, 24, 24)
  
  If StartDrawing(SpriteOutput(88))
    Circle(12, 12, 10, RGB(155, 0, 255))
    Circle(12, 12, 04, RGB(255, 0, 155))
    StopDrawing()
  EndIf
EndProcedure

Procedure AddText(text$,x)
  Static J
  
  StartDrawing(ScreenOutput())
  DrawText(0,x,text$)
  StopDrawing()
  
EndProcedure 

Procedure DoLogo()
  
  
  
  
  Static MoveInFlag
  ; Static MoveOutFlage
  Static ycord
  Static intensity.f
  ;Static STM
  Static SineW
  Static Ndelay=23150
  Static copy
  
  If ElapsedMilliseconds()-STM>Ndelay And MoveInFlag=0
    Ball_on=0
    STM=ElapsedMilliseconds()
    Debug "ping"
    ; If SineW
    SineW+1
    Ndelay=1000
    Select SineW
      Case 1
        g_angleadd=75.5
        copy=#True
        anglel.f=g_angleadd
      Case 2
        g_angleadd=11
        copy=#True
        anglel.f=g_angleadd
      Case 3
        g_angleadd=11.5
        copy=#True
        anglel.f=g_angleadd
      Case 4
        g_angleadd=26
        copy=#False
        anglel.f=g_angleadd
      Case 5
        ;  g_angleadd=32
        g_angleadd=19
        copy=#False
        anglel.f=g_angleadd
      Case 6
        g_angleadd=75.5
        copy=#True
        anglel.f=g_angleadd
      Case 7
        g_angleadd=26.5
        copy=#False
        anglel.f=g_angleadd      
      Case 8
        g_angleadd=37.5
        copy=#False
        anglel.f=g_angleadd
    EndSelect
    
    If SineW=>9
      SineW=0
      Ndelay=1000
      
      STM=ElapsedMilliseconds()
    EndIf
    
    ; EndIf
    
  EndIf
  
  If LogoDone=0
    bb=-200
    If ycord>bb
      If ending=0
        MoveInFlag=1 : 
      EndIf
      
    Else
      MoveInFlag=0
    EndIf
    
    
    
    If MoveInFlag=1 
      ; If ElapsedMilliseconds()-TM<2000
      If EMs()-LTM>30
        LTM=EMs()
        ycord-2
        If intensity<255
          intensity+2
        EndIf  
      EndIf
      ; EndIf
    ElseIf MoveOutFlag=1
      ; If ElapsedMilliseconds()-TM<2000
      StarsOn=0
      If EMs()-LTM>30
        LTM=EMs()
        ycord+4
        
        If intensity<255
          intensity-6
        EndIf  
      EndIf
      If tintensity>0
        tintensity-2
      EndIf
      
      If ycord>0
        
        MoveOutFlage=0
        MoveInFlag=0
        LogoDone=1
        ended=1
        Debug "logo done"
      EndIf
      
    EndIf
    
  Else
    
    
  EndIf
  
  
  For a=0 To 128
    
    s=Sin(anglel*0.5)*12
    
    anglel+g_angleadd
    
    If copy=#True
      
      copys=s : If s<0 : copys=0 : EndIf
    ElseIf copy=#False
      
      
      copys = 27
    EndIf
    
    ClipSprite(666,b,0,copys,178)
    
    DisplayTransparentSprite(666,-27+(a+b),480+ycord+s,intensity)
    
    b+ 8
    
  Next 
  
  
  ;AddText(Str(s),0)
  ;AddText(StrF(g_angleadd),16)
  ; AddText(StrF(Ndelay),32)
  
  If anglel.f>360*360*64
    anglel.f=g_angleadd
  EndIf
  
  
EndProcedure

TM=ElapsedMilliseconds()
;TM=ElapsedMilliseconds()

STM=ElapsedMilliseconds()
CreateImages()
SetUpStars()
GetChannelBoxes()
Get16Font()

;CallCFunctionFast(*Play,?music,muslen,1)                   	;-Play the initial music
ReplayMusic(?music,muslen,1)
;PrepareUpscroll()

LTM1=EMs()
;LTM=EMs()
Repeat
  
  FlipBuffers()    
  ClearScreen(RGB(0,0,0))  
  If Ball_on=0
    Stars()
  EndIf
  
  Balls(Ball_on)
  VuMeters()
  
  UPscroll()
  DoLogo()
  Delay(1)
  ;WindowEvent()
  
  ExamineKeyboard() : ExamineMouse()
  If MouseWheel() = 1
    add+0.1
  ElseIf MouseWheel()=-1
    add-0.1
    ;Debug "mouse"
  EndIf
  
  If KeyboardHit(#PB_Key_Space)      ; if it's [SPACE] then we'll switch between windowed and fullscreen
    If Status=0 : Status = 1 :Else : Status = 0 : EndIf
  EndIf
  If KeyboardPushed(#PB_Key_Escape)
    ending=1
  EndIf
  If KeyboardReleased(#PB_Key_1)
    ReplayMusic(?music,muslen,1)
  EndIf
  If KeyboardReleased(#PB_Key_2)
    ReplayMusic(?music1,muslen1,1)
  EndIf
  If KeyboardReleased(#PB_Key_3)
    ReplayMusic(?music2,muslen2,1)
  EndIf
  If KeyboardReleased(#PB_Key_4)
    ReplayMusic(?music3,muslen3,1)
  EndIf
  ; very crappy windowed / fake fullscreen switch, too lazy for a proper fullscreen version ;) 
  If fs=0
    
    Select Status
      Case 0
        
        ShowWindow_(WindowID(0),#SW_NORMAL)      ;WinAPI calls won't work in the Demo of PureBasic!
        
        
      Case 1 
        
        ShowWindow_(WindowID(0),#SW_MAXIMIZE) 
        
        
    EndSelect
    WindowEvent()
  EndIf
  
Until ENDED=1



DataSection
  music:
  IncludeBinary"audio.sndh"	;-manually ripped Count Zero music. Custom 68000 header and conversion by KrazyK.  Uses tunes $16,$17, & $18 only
  musend:
  music1:
  IncludeBinary"robocop-title.snd"	;-manually ripped Count Zero music. Custom 68000 header and conversion by KrazyK.  Uses tunes $16,$17, & $18 only
  musend1:
  music2:
  IncludeBinary"Kisse_Katten.sndh"	;-manually ripped Count Zero music. Custom 68000 header and conversion by KrazyK.  Uses tunes $16,$17, & $18 only
  musend2:
  music3:
  IncludeBinary"Farewell_Lil_SSD.sndh"	;-manually ripped Count Zero music. Custom 68000 header and conversion by KrazyK.  Uses tunes $16,$17, & $18 only
  musend3:
  
  osmlib:					;-oldskool music replay library by Zippy
  IncludeBinary"osmengine.dll"
  
  font:
  IncludeBinary"font.bmp"
  
  logo:
  IncludeBinary"em_uklogo2.png"
  
EndDataSection
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; CursorPosition = 900
; Folding = ----
; EnableXP
; DPIAware