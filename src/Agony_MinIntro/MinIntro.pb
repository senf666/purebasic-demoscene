; MinIntro of (The Great) AGONY by Psygnosis on Amiga.
; Détouré et codé par Ar-S / 2018
; Trimming and code by Ar-S / 2018
; Utiliser les flêches pour diriger la chouette
; Use Arrows to move the Owl
; PB 5.62 x64

Enumeration
  #WIN
  #TimerFade
  #M
EndEnumeration

Enumeration Sprites
  #SP
  #Water
  #IMAG
  #sl1
  #sl2
  #sl3
  #sl4  
EndEnumeration


XIncludeFile("datas.pbi")

UsePNGImageDecoder()

; Etapes
#Titre = 1
#I1 = 2
#I2 = 3
#I3 = 4
#I4 = 5
#LOOPSL = 6

; INITIALISATION

Global LWIN = 800, HWIN = 600, Pos, PosX, PosY, Wpos, start, SP,  xSP, ySP, T
Global.b Etape

InitSprite() : InitKeyboard() : InitSound()

Macro SiChrono(DureeTotale,ChoixEtape)
  If ElapsedMilliseconds()-start >= (DureeTotale*1000)
    Etape = ChoixEtape
  EndIf
EndMacro


Procedure LoadDatas()
  
  CatchSprite(#SP, ?ag_s,#PB_Sprite_AlphaBlending )
  CatchSprite(#Water,?water,#PB_Sprite_AlphaBlending)
  CatchMusic(#M,?Mod_s,?Mod_e-?Mod_s)
  
  If LoadSprite(#IMAG,"psygnosis_logo2.png",#PB_Sprite_AlphaBlending)
    If LoadSprite(#sl1,"sl1.png",#PB_Sprite_AlphaBlending)
      If LoadSprite(#sl2,"sl2.png",#PB_Sprite_AlphaBlending)
        If  LoadSprite(#sl3,"sl3.png",#PB_Sprite_AlphaBlending)
          If  LoadSprite(#sl4,"sl4.png",#PB_Sprite_AlphaBlending)
            OK = 1
          Else 
            OK = 0
          EndIf
        EndIf
      EndIf
    EndIf
  EndIf
  ProcedureReturn OK
EndProcedure

Procedure AnimSprite()
  ; Animation
  ClipSprite(#SP,Pos,0,64,174)
  Pos + 64
  
  If pos = 1024
    Pos = 0
  EndIf
  DisplayTransparentSprite(#SP,PosX,PosY)
  ;///////////////////////////////////////
EndProcedure


Procedure AnimWater()
  ClipSprite(#water,0,Wpos,288,32)
  WPos + 32
  
  If Wpos >= 384
    WPos = 0
  EndIf
  ZoomSprite(#Water,288*2, 64)
  DisplayTransparentSprite(#Water,-10,Hwin-64)
  DisplayTransparentSprite(#Water,278,Hwin-64)
  ;///////////////////////////////////////
EndProcedure


Procedure GOWINDOW()
  
  
  OpenWindow(#WIN,0,0,Lwin, Hwin,"Ar-S Agony Intro",#PB_Window_BorderLess|#PB_Window_ScreenCentered)
  OpenWindowedScreen(WindowID(#WIN),0,0,Lwin,Hwin,1,0,0)
  
  SetFrameRate(18)
  LoadDatas()
  VIT = 15
  Etape = #Titre
  SP = #IMAG
  T = 255
  
  AddWindowTimer(#WIN,#TimerFade,500)
  
  If LoadDatas() = 1
    PlayMusic(#M)
    
    Start=ElapsedMilliseconds()
    
    Repeat
      
      Repeat
        WindowEvent()
        
        If EventTimer() = #TimerFade
          T-1
          If T <= 0 : T = 0 : EndIf
        EndIf
        
        
      Until WindowEvent() = 0
      
      ; // 2D
      ExamineKeyboard() 
      
      ClearScreen(0)
      
      
      
      Select Etape
          
        Case #Titre
          If AA = 0 : T = 255 : AA = 1 : EndIf
          SP = #IMAG
          xSP = 40 : ySP = 100
          SiChrono(10,#I1)
        Case #I1
          If BB = 0 : T = 255 : BB = 1 : EndIf
          SP = #SL1
          xSP = 0 : ySP = 0
          SiChrono(20,#I2)
        Case #I2
          If CC = 0 : T = 255 : CC = 1 : EndIf
          SP = #SL2
          xSP = 0 : ySP = 0
          SiChrono(30,#I3)
        Case #I3
          If DD = 0 : T = 255 : DD = 1 : EndIf
          SP = #SL3
          xSP = 0 : ySP = 0
          SiChrono(40,#I4)
        Case #I4
          If EE = 0 : T = 255 : EE = 1 : EndIf
          SP = #SL4
          xSP = 0 : ySP = 0
          SiChrono(49,#LOOPSL)
        Case #LOOPSL

          Start = ElapsedMilliseconds()
          AA = 0 : BB = 0 : CC = 0 : DD = 0 : EE = 0
          Etape = #Titre
          
      EndSelect
     
      DisplayTransparentSprite(SP,xSP,ySP,T)
     
      AnimWater()
      AnimSprite()
      
      
      ; ///////////// OWL MOVE //////////////
      
      If KeyboardPushed(#PB_Key_Right)
        posx +VIT
        If PosX >= Lwin-64
          PosX = Lwin-64
        EndIf
        If PosX <= 0
          PosX = 0
        EndIf
      EndIf
      
      If KeyboardPushed(#PB_Key_Left)
        posX -VIT
        If PosX <= 0
          PosX = 0
        EndIf
      EndIf
      
      If KeyboardPushed(#PB_Key_Up)
        posy -VIT
        If PosY < 0
          Posy = 0
        EndIf
      EndIf
      
      If KeyboardPushed(#PB_Key_Down)
        posy +VIT
        If PosY > Hwin-174
          PosY = Hwin-174
        EndIf
      EndIf
      
      ;// Gestion clavier
      If KeyboardPushed(#PB_Key_Escape)
        End
      EndIf
      
      
      FlipBuffers()
    ForEver
    End  
    
  EndIf
  
  
EndProcedure


GOWINDOW()




; IDE Options = PureBasic 5.62 (Windows - x64)
; Folding = -
; EnableXP
; Executable = Agony_Minitro.exe
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 99
; EnableBuildCount = 2
; EnableExeConstant