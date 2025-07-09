
#XM_RESOURCE       = 0
#XM_MEMORY         = 1
#XM_FILE           = 2
#XM_NOLOOP         = 8
#XM_SUSPENDED      = 16
#uFMOD_MIN_VOL     = 0
#uFMOD_MAX_VOL     = 25
#uFMOD_DEFAULT_VOL = 25
Global lvol 
Global rvol
Macro LOWORD(Value)
  Value & $FFFF
EndMacro

Macro HIWORD(Value)
  (Value >> 16) & $FFFF

EndMacro
InitSprite()
InitSound()
UsePNGImageDecoder()

#WindowWidth=640 : #WindowHeight = 240 : #TopBorder  = 18 : #BottomBorder  = 18 : #ActualWindowHeight = 240*2


Global xsize:     xsize=0     ; width in Pixel of 1 Char
Global xchar:     xchar=0     ; pointer of n th Char
Global yshift:    yshift=0    ; Sine in Y
Global angle.f:   angle=0.0   ; Angle
Global Tex.s:     Tex=""      ; Scrolltext
Global tcolor.w:  tcolor=0    ; actual color of flashing text
Global tspeed.w:  tspeed=5    ; flashing speed 
Global zoom_h1:   zoom_h1=0   ; help for logo zoomimg       
Global zoom_h2:   zoom_h2=0   ; help for logo zooming
Global time = 0
#ID_Sprite1       =1       ; ID font
#ID_Sprite2       =2       ; ID Logo
#ID_Sprite3       =3       ; ID Logo in 3dSprite
#ID_Sprite4       =4       ; ID for empty Sprite
#ID_Module1       =10      ; ID Sound Module
#ID_Font1         =30      ; ID Font
#ID_Buffer1       =40      ; ID for scroller temporary buffer
#ID_Buffer2       =41      ; ID for logo temporary buffer
#ID_Buffer3       =42      ; ID for another logo temporary buffer
#ID_Buffer4       =43      ; ID for Scroller temporary buffer
#ID_Buffer1_help  =44      ; ID to clear Scroller temporary buffer
#ID_Buffer4_help  =45      ; ID to clear Scroller temporary buffer
#ID_3dSprite1     =50      ; ID for 3dSprite1

hnd_font1.l         ; Handle of the font1

Tex.s="                  just another attempt at improving my demo intro skills  omnikam presents voltage"
Tex=Tex+" A big thanks to     padman     shockwave    vain and the rest of the active "
Tex=Tex+" dbf community    for always sharing and helping newbies to learn "
Tex=Tex+"     a big thanks to    wolfgang   for help with the wavey logo         also a big thanks to inc  for my logo  "
Tex=Tex+" the font is from the amiga scene         thats the end of this demo thanks             "

;**********************************************************************************************************  
Structure Stars                                           ; 'storeplace' for the star coordinates and speed/color
  x.f   ;x pos
  y.f   ;y pos
  v.f   ;speed
  c.l   ;color
EndStructure
Dim Star.Stars(40000)

;**********************************************************************************************************  
Procedure.f GSin(winkel.f)                              ; angle calculation by Danilo -> thanks comrade :)
   ProcedureReturn Sin(winkel*(2*3.14159265/360))
EndProcedure

Procedure Dod(a,b)                                      ; Stolen from PureBasic IDE.pb ;)
  ProcedureReturn a-a/b*b
EndProcedure

;**********************************************************************************************************  
If InitSprite()=0                                        ; Init Sprite
  MessageRequester("","Sprite",0):End:EndIf             ; 
If InitKeyboard()=0                                      ; Init Keyboard 
  MessageRequester("","Keyboard",0):End:EndIf

If InitSound()=0                                          ; Init Sound
  MessageRequester("","Sound",0):End:EndIf
If OpenScreen(640,480,32,"sine scroller")=0               ; Opens the Screen
  MessageRequester("","Screen",0):End:EndIf




If LoadSprite(#ID_Sprite1,"font2.bmp")=0                  ; Storeplace for the Font
  MessageRequester("","Font",0):End:EndIf
If LoadSprite(#ID_Sprite2,"omni.png",#PB_Sprite_AlphaBlending)=0                  ; Storeplace for the Logo
  MessageRequester("","omni",0):End:EndIf

If CreateSprite(#ID_Buffer1,640+144,48)=0                  ; Buffer for the Scroller + y deforming
  MessageRequester("","Buffer1",0):End:EndIf
If CreateSprite(#ID_Buffer1_help,640+144,48)=0             ; Emty Buffer to clear ID_Buffer1
  MessageRequester("","Buffer1_help",0):End:EndIf
If CreateSprite(#ID_Buffer4,640+144,240)=0                 ; Buffer for the Scroller + x deforming
  MessageRequester("","Buffer4",0):End:EndIf
If CreateSprite(#ID_Buffer4_help,640+144,240)=0            ; Emty Buffer To clear ID_Buffer1
  MessageRequester("","Buffer4_help",0):End:EndIf


If CreateSprite(#ID_Buffer2,640,260)=0                    ; Buffer for the Logo + y deforming
  MessageRequester("","Buffer2",0):End:EndIf
If CreateSprite(#ID_Buffer3,640,260)=0 ; Buffer for the Logo + x deforming
  MessageRequester("","Buffer3",0):End:EndIf             ; and preparing to be an 3dSprite


If LoadMusic(#ID_Module1,"Unit_A1.mod")=0                ; Load the Music
  MessageRequester("","MusicFile",0):End:EndIf

hnd_font1=LoadFont(#ID_Font1,"Arial",8)                    ; Opens  Arial Font size 8
If hnd_font1=0
  MessageRequester("","Can't open font Arial !?!?!",0):End:EndIf


;**********************************************************************************************************  
PlayMusic(#ID_Module1)                                   ; Start 'the ultimate' Sound :)))
                                         

;**********************************************************************************************************  
For i=0 To 800                                          ; Gives each star x/y and speed/color
  star(i)\x=Random(640)
  star(i)\y=Random(225)+212
  star(i)\v=i/150
  star(i)\c=RGB(0, 255, 255)
Next

Repeat
;**********************************************************************************************************  
;**********************************************************************************************************  
  xsize+3                                                  ; Calculate the Char and xsize
  If xsize>=48; Then  :)                                   ; xsize=width of 1 char = 48 pixel
    xchar+1
    xsize=0
    If Mid(Tex.s,xchar,1)=Chr(0)
      xchar=1
    EndIf
  EndIf
  
;**********************************************************************************************************  
;**********************************************************************************************************  
  angle+4                                                   ;calculates the 'main' angle overall
  If angle=360
;    angle=0
  EndIf

;**********************************************************************************************************  
;**********************************************************************************************************  
  StartDrawing(ScreenOutput())                              ; Paint the 2 lines
  LineXY(0,209,640,209,$ff4422)
  LineXY(0,265,640,265,$ff4422)
  LineXY(0,438,640,438,$ff4422)
  StopDrawing()

;**********************************************************************************************************  
;**********************************************************************************************************  
  StartDrawing(ScreenOutput())                              ; Calculate & Plot 800 'Stars'
  For i=0 To 800
    star(i)\x+GSin(angle/10)*star(i)\v/2
    If star(i)\x>640                                            
      star(i)\x=star(i)\x-640
    EndIf

    If star(i)\x<0                                            
      star(i)\x=star(i)\x+640
    EndIf

    star(i)\y=star(i)\y+Gsin(angle/10*((star(i)\v)-1)/5)*2
    If star(i)\y<212
      star(i)\y+225
    EndIf
    
    If star(i)\y>225+212
      star(i)\y-225
    EndIf
    

    Plot(Int(star(i)\x),Int(star(i)\y),star(i)\c)
  Next
  StopDrawing()
  
;**********************************************************************************************************  
;**********************************************************************************************************  
                                                             ; Move the Scrolly
  CopySprite(#ID_Buffer1_help,#ID_Buffer1,0)                 ; Clear ID_Buffer 1
      help1.f=0                               ; Display the sine scroller
  For i=0 To 22                                             ; Move scroll chars from ID_Sprite1 to ID_Buffer1  
    a=Asc(Mid(Tex.s,xchar+i,1))-97
    If a=-65:a=36:EndIf ; Spache
  
    ClipSprite(#ID_Sprite1,a*48 ,0,48*Random(1),48*Random(1))
     
    DisplayTransparentSprite(#ID_Sprite1,i*48-xsize-Random(5)  ,Random(i) +210 )  ; scroller
  Next
  
 ; CopySprite(#ID_Sprite1,#ID_Buffer1,0)                 ; Clear ID_Buffer 1
CopySprite(#ID_Buffer4_help,#ID_Buffer4,0) 
                                                          ; From ID_Buffer1 to ID_Buffer 4 with x deforming
   For l=0 To 639+48+48+48                                       ; 640+48 'stripes'
    help1+0.18;+(i/300)
     ClipSprite(#ID_Sprite1,a*48,0,48,48)
    help2.f    =GSin(angle+ help1*4 )*30
    help2=help2+GSin(angle+(help1*2))*60
  ;
  Next
   CopySprite(#ID_Sprite1,#ID_Buffer4)  
  CopySprite(#ID_Sprite2,#ID_Buffer2)           ;#ID_Sprite2 = logo into #ID_Buffer2  change to sprite 1 for text
  Global z
  help6.f=0   ; From ID_buffer2 to Screen with y deforming
  b=5
  If time<110000
  For i=0 To 200                                            ;clip 200 Lines
    help6+0.6
    ClipSprite(#ID_Buffer2,0,i,640+48+48+48,1-Random(1))
   
    help7.f    =GSin(angle+ help6*5 )*40   
    help7=help7+GSin(angle+(help6*2))*60
    DisplayTransparentSprite(#ID_Buffer2,help7+60,i +i-Random(0)+200); intence LOGO side to side
time = time +1
    If b>2000000
       
      b=5
    EndIf
   
  Next
  Else
  ;logo 2
    For i=0 To 200                                            ;clip 200 Lines
    help6+0.6
    ClipSprite(#ID_Buffer2,0,i,640+48+48+48,2)
    help7.f    =GSin(angle+ help6*5 )*30;i/10  
    help7=help7+GSin(angle+(help6*2))*Random(10)
    DisplayTransparentSprite(#ID_Buffer2,help7+60,i +i-Random(0)+200); intence LOGO side to side
    
    If time>190000
    time=0
  EndIf
  If b>600000
      b=5
  EndIf
  
  
Next
EndIf

;end of logo 2
For i=0 To 640                                           ;clip 200 Lines
    help6+0.6
    ClipSprite(#ID_Buffer2,0,i,640+48+48+48,1)
   
    help7.f    =GSin(angle+ help6*5 )*40   
    help7=help7+GSin(angle+(help6*2))*60
    
     
    If b>900000
 
      b=5
    EndIf
   
  Next
   
For i=0 To 620                                             ; from ID_Sprite2 to ID_Buffer2 with y deforming (620 lines y)
    ClipSprite(#ID_Sprite2,i,0,1,160) 
 
  Next
;**********************************************************************************************************  
;**********************************************************************************************************  

  For i=0 To 620                                             ; from ID_Sprite2 to ID_Buffer2 with y deforming (620 lines y)
    ClipSprite(#ID_Sprite2,i,0,1,160) 

Next

 

CopySprite(#ID_Sprite2,#ID_Buffer2)

  For i=0 To 200                                             ; and from ID_Buffer2 with x deforming to Screen (200 lines x)
    help1+1
    If help1>360:help1=0:EndIf                               ; simple! Isn't it ?
    ClipSprite(#ID_Buffer2,0,i,640,1)
 
  Next




 ;create zooming logo
  

 CopySprite(#ID_Buffer2,#ID_3dSprite1) ;#ID_Buffer2 is logo coppy to #ID_3dSprite1
  If zoom_h1<>640:zoom_h1+2:EndIf                             ; calculate x zooming
  If zoom_h2<>260:zoom_h2+1:EndIf                             ; calculate y zooming

                                                   ; if zooming is done
    If angle>1280+360                                             ; show logo in better quality
      ZoomSprite(#ID_3dSprite1,zoom_h1+Int(gsin(angle)*20),Int(zoom_h2+gsin(angle)*20))
 
     DisplayTransparentSprite(#ID_3dSprite1,320-(zoom_h1/2)-gsin(angle)*15,120-(zoom_h2/2)-50-Random(10)) ; print and hold the logo +200 middle screen
    Else
      ZoomSprite(#ID_3dSprite1,zoom_h1,zoom_h2)              ; zoom it
   DisplayTransparentSprite(#ID_3dSprite1,320-(zoom_h1/2),110-(zoom_h2/2)+0-Random(10)) ; print and hold the logo  +200 middle screen
                                                                                    ; in the middle while zooming  
    EndIf
    
                                                                       
  
;**********************************************************************************************************  
;**********************************************************************************************************  
  StartDrawing(ScreenOutput())                                
    DrawingFont(hnd_font1)                                    ; set font

    DrawingMode(3)                                            
    
  

                                              ; And the Press any Key text
    tcolor+tspeed:If tcolor>200:tcolor=-tcolor:EndIf         ; calculating the flashing color
 
    DrawText(270,443,"Press any key to exit",RGB(255,255,255))
  StopDrawing()
   



  FlipBuffers()                                               ; show the wole screen flip back-to frontbuffer
  ClearScreen(0)
  ExamineKeyboard()
Until KeyboardPushed(#PB_Key_All)


; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 22
; FirstLine = 5
; Folding = -
; EnableXP
; EnableAdmin
; Executable = omnikam.exe
; DisableDebugger