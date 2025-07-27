; -------------------------------------------------------
;
; Little OLDSCHOOL 2D DEMO
; Miss lot's of FX but for a forst shot, that will be enougth :)
; CODE, GFX, MUSIC : AR-S
; ORIGINAL SCROLLTEXT : SHOWCASE / PADMAN
; ORIGINAL 3D STARFIELD : JMG
; ORIGINAL FIREWORKS : STARGÅTE
; ORIGINAL PLASMA : SPH
; ORIGINAL SNAKE : LSI / GUIMAUVE
; 
; Escape to EXIT
; --------------------------------------------------------

Declare GoSTARFIELD()
Declare GoSCROLLTEXT(text.s)
Declare Load()
Declare FEU()

Enumeration
  ; FENETRE
  #LDVM
  ; ECRAN
  #SCREEN
  ;IMAGES/SPRITES
  #Font
  #ECRAN
  #LED
  #Workbench
  #LOAD
  #LOGO
  #FLECHE
  #GURU1
  #GURU2
  #ARS
  
  ; SON
  #SONLOAD
  ; Timer
  #T
EndEnumeration

; CONSTANTES DES SCENES
#BOOT = 1
#CHARGEMENT = 2
#SCROLL = 3
#GURU = 4
#STARFIELD = 5
#DECRUNCH = 6
#FEU = 7
#SNAKE = 8
#PLASMA = 9


; INITIALISATION

ExamineDesktops()
Global fullW = 678
Global fullH = 600
Global Font, Ecran, Load, Workbench, xLed, yLed
Global message$, ARSx, ARSy
Global FullScreenL, FullScreenH, MonScreenX, MonScreenY,MonScreenL, MonScreenH, LoadX, LoadY, CentreScreenH
Global b.f,c,m
Global JoueSon.b = 0
Global Lettre, TailleLettre, NumLettre, xCharPos, yCharPos, tptr, sco = -100
Global GuruColor = $0020f7
Global SpG ; Id Sprite Guru
#Black = $0


tptr  = 1

; Différentes position et taille screen et fenêtre
FullScreenL = 678
FullScreenH = 600

Xscreen = 0 ;(fullW/2) - (678/2)
Yscreen = 0 ;(fullh/2) - 300

MonScreenX = Xscreen + 92  
MonScreenY = Yscreen + 98 
MonScreenL = 509
MonscreenH = 354


; MESSAGE DU SCROLLTEXT
message$ = "                   "
message$ + "   ARS PROUDLY PRESENTS "
message$ + "SOME OLDSCHOOL EFFECTS !    "
message$ + "REGARDS TO ALL PUREBASIC FORUM "
message$ + "MEMBERS AND "
message$ + " DBF INTERACTIVE MEMBERS   GREETS TO SPH PADMAN STARGATE GUIMAUVE SHOWCASE LSI JMS "
message$ + "                   "


CentreScreenL = MonScreenX +  (MonScreenL/2)
CentreScreenH = MonScreenY +  (MonScreenH/2)

LoadX = 70
LoadY = 78


;// Feu INit
Structure Vector
  X.f
  Y.f
EndStructure

Structure Spark
  Position.Vector
  Velocity.Vector
  Time.i
  Color.i
  Blink.i
  Weight.i
EndStructure

Structure Bullet
  Position.Vector
  Velocity.Vector
  Time.i
  Color.i
  Weight.i
  Type.i
EndStructure

Global NewList Bullet.Bullet()
Global NewList Spark.Spark()

;/////

UseOGGSoundDecoder()
UsePNGImageDecoder() 
InitSprite() : InitMouse()
InitKeyboard()
InitSound()

; Init starfield
Global SSum.w = 8000 ; Amount of Stars
Global Cspeed.f=22
Global CameraZ.f=0


LoadSound(#SONLOAD,"load.ogg")

;--------- Procs Starfield -------------

; Structure of a star ...
Structure _3DStar
  x.f ; X-Coordinate
  y.f ; Y-Coordinate
  z.f ; Z-Coordinate
EndStructure

; Init Starfield ...
Global Dim Stars._3DStar(SSum)
For dummy = 0 To SSum
  Stars(dummy)\x = Random(10000)-5000
  Stars(dummy)\y = Random(10000)-5000
  Stars(dummy)\z = 100 + Random(1000)
Next dummy




; ////////////// PROCEDURES /////////////////

; // SNAKE

XIncludeFile ("includes/snake_proce.pbi")

; // DECRUNCH
Procedure Decrunch()
  Protected Y,H,Color
  y = 82
  
  Repeat  
    
    Color=RGB(Random(255),Random(255),Random(255))  
    H=Random(15)										            
    StartDrawing(ScreenOutput())
    Box(80, Y, MonScreenL+20,H,Color)									  
    StopDrawing()
    Y+H											                    
    If y > MonScreenY + MonScreenH
      Break
    EndIf	
    
  ForEver
  
  ;Until   Decrunch = #False	
  
EndProcedure



; // STARFIELD (Axe Z)
Procedure GoSTARFIELD()
  
  If CameraZ>2000
    Direction=-1
  ElseIf CameraZ<-2000
    Direction=1
  EndIf
  If Direction=1 And Cspeed<10
    Cspeed+0.1
  ElseIf Direction=-1 And Cspeed>-10
    Cspeed-0.1
  EndIf
  CameraZ+Cspeed
  
  
  ; #### Draw StarField ####
  StartDrawing(ScreenOutput())
  For dummy = 0 To SSum
    If Stars(dummy)\z < CameraZ
      Stars(dummy)\z  = CameraZ+1000
    ElseIf Stars(dummy)\z > (CameraZ+1000)
      Stars(dummy)\z  = CameraZ
    EndIf
    SX = Stars(dummy)\x / (Stars(dummy)\z-CameraZ)*100+347
    SY = Stars(dummy)\y / (Stars(dummy)\z-CameraZ)*100+276
    If (SX<678) And (SY<600) And (SX>1) And (SY>1)
      b.f = 255-(((Stars(dummy)\z)-CameraZ) * (255/1000))
      c = Int(b)
      Plot (SX, SY, RGB(c,c,c))
    EndIf
  Next dummy
  StopDrawing()  
EndProcedure

; // SCROLL TEXT
Procedure GoSCROLLTEXT(text.s)
  Shared NumLettre, lettre, xCharPos, yCharPos, TailleLettre,m,sco
  
  For NumLettre = 0 To 25
    lettre   = Asc(UCase(Mid(text.s, tptr+NumLettre, 1)))-32
    
    yCharPos = lettre / 10
    xCharPos = lettre % 10
    
    ClipSprite(font, xCharPos*32, yCharPos*32, 32, 32)   ;the magic 
    TransparentSpriteColor(font,#Black)                  ;sets the transparacy color of the font png
    DisplayTransparentSprite(font, sco+TailleLettre, 250+50*Sin((NumLettre+TailleLettre+sco+m)/120))  ;
    DisplayTransparentSprite(font, sco+TailleLettre, 255+50*Sin((NumLettre+TailleLettre+sco+m)/119),60)  ;
    TailleLettre + 32
  Next
  m -5
  sco -6
  ;     
  If sco < -32
    tptr + 1
    sco + 32
  EndIf
  ;     
  If tptr > Len(text.s) - 12
    tptr = 0
  EndIf 
  
EndProcedure


; ECRAN DE CHARGEMENT WORKBENCH
Procedure LOAD()
  Protected Mx, My
  
  If JoueSon = 0
    PlaySound (#SONLOAD)
    joueson = 2
  EndIf
  
  ExamineMouse()
  Mx = MouseX()
  My = MouseY()
  
  If Mx < 88 
    Mx = 88 
  ElseIf Mx > 593 
    Mx = 593
  EndIf
  
  If My < 86 
    My = 86 
  ElseIf My > 456 
    My = 456
  EndIf
  
  
  TransparentSpriteColor(#FLECHE,#White) 
  DisplayTransparentSprite(#LOAD, LoadX, LoadY)
  DisplayTransparentSprite(#FLECHE,Mx,My)

EndProcedure

; /////////// FIN PROCEDURE //////////////////////////////////


;///////// CREATION DES FENETRES ET CHARGEMENT DES DONNEES ////////////////:

If OpenWindow(#LDVM,0,0,fullW, fullH, "AR-S Amiga RuleZ", #PB_Window_BorderLess|#PB_Window_ScreenCentered)
  StickyWindow(#LDVM,1)
  SetWindowColor(#ldvm, #Black) ; couleur de fond de la fenetre
  AddWindowTimer(#LDVM,#T,1000) ; Timer 1 sec
  
  If OpenWindowedScreen(WindowID(#LDVM), Xscreen, Yscreen, 678, 600) ; Fenêtre 2D dans la fenêtre classic. 
    
    XIncludeFile ("includes/snake_init.pbi")
    XIncludeFile ("includes/plasma_init.pbi")
    ; FEU
    RandomSeed(4)
    Define Time.i, OldTime.i, TimeFactor.f, Length.f, I.i, Angle.f, Radius.f, Factor.f, *Spark.Spark
    
    ; CHARGEMENT DES sprites
    font  =     LoadSprite (#PB_Any, "img/Charset-Ar_S_Gold.png")
    ecran =     LoadSprite(#ECRAN, "img/ecran_678x600.png")
    led   =     LoadSprite(#LED,"img/led.png")
    LOAD  =     LoadSprite (#LOAD,"img/load.png") 
    WORKBENCH = LoadSprite (#Workbench,"img/workbench.png") 
    FLECHE    = LoadSprite(#FLECHE,"img/fleche.png")
    Guru1     = LoadSprite(#GURU1,"img/guru1.png")
    Guru2     = LoadSprite(#GURU2,"img/guru2.png")
    Guru      = LoadSprite(#ARS,"img/guru.png")
  EndIf
  
  
EndIf

; ////////////////// FIN FENETRES ///////////////////



; ///// BOUCLE EVENEMENTS ET BOUCLE 2D ////////////

Repeat
  ; REPEAT SERVANT A LA 2D
  Repeat
    ; REPEAT servant aux events de la fenêtre
    Event = WindowEvent()
    
    ; Le TIMER qui sert à sectionner les séquences
    If Event = #PB_Event_Timer And EventTimer() = #T
      
      COMPTE +1
      
      Select COMPTE
        Case 1  
          Etape = #BOOT
          yLED = 650
        Case 3
          xLed = 613
          yLED = 538
          
          FreeSprite(#LOGO)
          Etape = #CHARGEMENT  
        Case 10
          FreeSprite(#Workbench)
          FreeSprite(#FLECHE)
          yLED = 650
          Etape = #DECRUNCH
        Case 13  
          Etape = #SCROLL
        Case 31
          Etape = #STARFIELD
        Case 43
          Etape = #FEU
        Case 61
          Etape = #SNAKE
        Case 76 
          Etape = #PLASMA
          
        Case 80
          Etape = #GURU
          StopSound(#SONLOAD)
          JoueSon = 0
          
          SpG = #GURU1
          ARSx = Random(413,90)
          ARSy = Random(326,186)
          
        Case 81
          SpG = #GURU2
          ARSx = Random(413,90)
          ARSy = Random(326,186)
        Case 82
          SpG = #GURU1
          ARSx = Random(413,90)
          ARSy = Random(326,186)
        Case 83
          SpG = #GURU2
          ARSx = Random(413,90)
          ARSy = Random(326,186)
        Case 84  
          SpG = #GURU1
          ARSx = Random(413,90)
          ARSy = Random(326,186)
         COMPTE = 82
       
      EndSelect
    EndIf
    
  Until event = 0
  
  
  ExamineKeyboard()  
  
  TransparentSpriteColor(#ECRAN,#White) 
  
  
  ;scroller
  TailleLettre = 0
  
  Debug "COMPTEUR : " + Compte
  
  If ETAPE = #BOOT
    ; Affichage du logo
    DisplayTransparentSprite(#Workbench, LoadX, LoadY)
  EndIf
  
  
  If ETAPE = #CHARGEMENT
    ; Affichage du chargement ecran bleu
    LOAD()
    
  EndIf
  
  If Etape = #DECRUNCH
    Decrunch()  
  EndIf
  
  If ETAPE = #SCROLL
    
    GoSCROLLTEXT(message$)
    
  EndIf
  
  If ETAPE = #STARFIELD
    
    GoSTARFIELD()
    
  EndIf
  
  
  If Etape = #FEU
    
    Time = ElapsedMilliseconds()
    TimeFactor = (Time-OldTime)*0.001
    OldTime = Time
    
    StartDrawing(ScreenOutput())
    
    ForEach Spark()
      Spark()\Position\X + Spark()\Velocity\X*TimeFactor
      Spark()\Position\Y + Spark()\Velocity\Y*TimeFactor
      Spark()\Velocity\Y + 98.1*TimeFactor
      If Time > Spark()\Time-250
        Factor = (Spark()\Time-Time)/250.
      Else
        Factor = 1.0
      EndIf
      If Spark()\Weight Or Spark()\Blink
        Circle(Spark()\Position\X, Spark()\Position\Y, Spark()\Blink+Sqr(Spark()\Weight/100), RGB(Red(Spark()\Color)*(Factor*0.5+0.5), Green(Spark()\Color)*(Factor*0.5+0.5), Blue(Spark()\Color)*(Factor*0.5+0.5)))
      Else
        Line(Spark()\Position\X, Spark()\Position\Y, 1, 1, RGB(Red(Spark()\Color)*Factor, Green(Spark()\Color)*Factor, Blue(Spark()\Color)*Factor))
      EndIf
      If Spark()\Blink
        *Spark = Spark()
        Angle = Radian(Random(3600)/10.)
        Radius = Sqr(Random(1000)/1000.)*10
        AddElement(Spark())
        Spark()\Position = *Spark\Position
        ;Spark()\Velocity = *Spark\Velocity
        Spark()\Velocity\X + Cos(Angle)*Radius
        Spark()\Velocity\Y + Sin(Angle)*Radius
        Spark()\Color = $40B0F0 + (Random($F)|Random($F)<<8|Random($F)<<16)
        Spark()\Time = Time + 250 + Random(250)
        ChangeCurrentElement(Spark(), *Spark)
      EndIf
      If Time > Spark()\Time
        If Spark()\Weight
          *Spark = Spark()
          For I = 1 To *Spark\Weight
            Angle = Radian(Random(3600)/10.)
            Radius = Sqr(Random(1000)/1000.)*40+10
            AddElement(Spark())
            Spark()\Position = *Spark\Position
            Spark()\Velocity = *Spark\Velocity
            Spark()\Velocity\X + Cos(Angle)*Radius
            Spark()\Velocity\Y + Sin(Angle)*Radius
            Spark()\Color = $40B0F0 + (Random($F)|Random($F)<<8|Random($F)<<16)
            Spark()\Time = Time + 250 + Random(250)
          Next
          ChangeCurrentElement(Spark(), *Spark)
        EndIf
        DeleteElement(Spark())
      EndIf
    Next
    
    ForEach Bullet()
      Bullet()\Position\X + Bullet()\Velocity\X*TimeFactor
      Bullet()\Position\Y + Bullet()\Velocity\Y*TimeFactor
      Bullet()\Velocity\Y + 98.1*TimeFactor
      Length = Sqr(Bullet()\Velocity\X*Bullet()\Velocity\X+Bullet()\Velocity\Y*Bullet()\Velocity\Y)
      Circle(Bullet()\Position\X, Bullet()\Position\Y, 1+Sqr(Bullet()\Weight/100), $C0C0C0)
      LineXY(Bullet()\Position\X, Bullet()\Position\Y, Bullet()\Position\X-Bullet()\Velocity\X*20/Length, Bullet()\Position\Y-Bullet()\Velocity\Y*20/Length, $808080)
      If Bullet()\Time < Time
        Select Bullet()\Type
          Case 0
            For I = 1 To Bullet()\Weight
              Angle = Radian(Random(3600)/10.)
              Radius = Pow(Random(1000)/1000., 0.25)*Sqr(Bullet()\Weight)*5
              AddElement(Spark())
              Spark()\Position = Bullet()\Position
              Spark()\Velocity = Bullet()\Velocity
              Spark()\Velocity\X + Cos(Angle)*Radius
              Spark()\Velocity\Y + Sin(Angle)*Radius
              Spark()\Color = Bullet()\Color + (Random($F)|Random($F)<<8|Random($F)<<16)
              Spark()\Time = Time + 1000 + Random(1000)
            Next
          Case 1
            For I = 1 To Bullet()\Weight/10
              Angle = Radian(Random(3600)/10.)
              Radius = Sqr(Random(1000)/1000.)*Sqr(Bullet()\Weight)*5
              AddElement(Spark())
              Spark()\Position = Bullet()\Position
              Spark()\Velocity = Bullet()\Velocity
              Spark()\Velocity\X + Cos(Angle)*Radius
              Spark()\Velocity\Y + Sin(Angle)*Radius
              Spark()\Color = Bullet()\Color + (Random($F)|Random($F)<<8|Random($F)<<16)
              Spark()\Time = Time + 500 + Random(500)
              Spark()\Weight = 50
            Next
          Case 2
            For I = 1 To Bullet()\Weight/10
              Angle = Radian(Random(3600)/10.)
              Radius = Sqr(Random(1000)/1000.)*Sqr(Bullet()\Weight)*5
              AddElement(Spark())
              Spark()\Position = Bullet()\Position
              Spark()\Velocity = Bullet()\Velocity
              Spark()\Velocity\X + Cos(Angle)*Radius
              Spark()\Velocity\Y + Sin(Angle)*Radius
              Spark()\Color = Bullet()\Color + (Random($F)|Random($F)<<8|Random($F)<<16)
              Spark()\Time = Time + 2500 + Random(500)
              Spark()\Blink = #True
            Next
        EndSelect
        DeleteElement(Bullet())
      ElseIf Random(1) = 0
        Radius = Random(50)+50
        Angle = Radian(Random(100)/10.-5) + ATan2(Bullet()\Velocity\X, Bullet()\Velocity\Y)
        AddElement(Spark())
        Spark()\Position = Bullet()\Position
        Spark()\Velocity = Bullet()\Velocity
        Spark()\Velocity\X - Cos(Angle)*Radius
        Spark()\Velocity\Y - Sin(Angle)*Radius
        Spark()\Color = $40B0F0 + (Random($F)|Random($F)<<8|Random($F)<<16)
        Spark()\Time = Time + 1000 + Random(1000)
      EndIf
    Next
    
    If Random(20) = 0
      Angle = Radian(Random(400)/10.+250)
      AddElement(Bullet())
      Bullet()\Position\X = 200 + Random(200)
      Bullet()\Position\Y = MonScreenH + 360
      Bullet()\Velocity\X = Cos(Angle)*350
      Bullet()\Velocity\Y = Sin(Angle)*350
      Bullet()\Color = PeekI(?Color+Random(5)*SizeOf(Integer))
      Bullet()\Time = Time + 2000 + Random(500)
      Bullet()\Weight = 100+Random(800)
      Bullet()\Type = Random(2)
    EndIf
    
    StopDrawing()
    
  EndIf
  
  If ETAPE = #SNAKE
    
      DisplayStarField(StarField)
      DisplaySnake(Snake00)
      DisplaySnake(Snake01)
      DisplaySnake(Snake02)
      DisplaySnake(Snake03)
      DisplaySnake(Snake04)
      DisplaySnake(Snake05)
      
    EndIf
    
    If ETAPE = #PLASMA
      ;;;;;;;;;;;
      StartDrawing(ScreenOutput())
      
      For i=0 To dh-1
        r1=63+Cos(rr1)*63
        r2=63+Sin(rr2)*63
        v1=63+Cos(vv1)*63
        v2=63+Cos(vv2)*63
        b1=63+Sin(bb1)*63
        b2=63+Sin(bb2)*63
        
        rr=r1+v1+b1
        vv=r2+v2+b2
        
        LineXY(dw2-rr,i,dw2+vv,i,RGB(r1+r2,v1+v2,b1+b2))
        
        rr1+a1
        rr2+a2
        vv1+a3
        vv2+a4
        bb1+a5
        bb2+a6
      Next
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  2
      
      
      
      or1+cr1
      rr1=or1
      or2+cr2
      rr2=or2
      ov1+cv1
      vv1=ov1
      ov2+cv2
      vv2=ob2
      ob1+cb1
      bb1=ob1
      ob2+cb2
      bb2=ob2
      StopDrawing()
    EndIf
    
    
    If ETAPE = #GURU

      DisplaySprite(SpG,92,109)
      DisplayTransparentSprite(#ARS, ARSx, ARSy)
      
    EndIf
    

  ; On affiche l'ecran à la fin pour le mettre au 1er plan
  DisplayTransparentSprite(#ECRAN, 0, 0)
  DisplaySprite(#Led, xLED, yLED)
  

  FlipBuffers()
  ClearScreen(#Black) 
Until KeyboardPushed( #PB_Key_Escape ) Or EXIT = 1

; /////////////// FIN DU PROGRAMME //////////////

End

DataSection
  Color:
  Data.i $4060F0, $00F040, $F08040, $00D0F0, $F040C0, $cbff2f
EndDataSection
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; CursorPosition = 11
; FirstLine = 297
; Folding = -
; EnableXP
; Executable = TINY_OLDSHOOL_FX.exe
; EnableCompileCount = 225
; EnableBuildCount = 1