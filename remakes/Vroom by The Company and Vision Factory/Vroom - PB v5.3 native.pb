EnableExplicit

#WindowWidth=640 : #WindowHeight = 240 : #TopBorder  = 18 : #BottomBorder  = 18 : #ActualWindowHeight = 240*2

Enumeration ;/ Window
  #Window_Main
EndEnumeration
Enumeration ;/ Gadget
  #Gad_OpenGL
EndEnumeration

;{ Init bits

Structure Scrolltext
  Letter_Texture_Pos.f
  Letter_Texture_Posy.f
  X.l
EndStructure
Structure Balls
  X.f
  Y.f
  Z.f
EndStructure
Structure Copper
  length.l
  r.c[1000]
  g.c[1000]
  b.c[1000]
  RGB.i[1000]
EndStructure

Global Quit.i, DrawnFrames.i, Offset.f, Font_Lookup_Text.S, MyLoop.i,  Copper1.Copper, Max_Balls = 100, BallSpeed.f=0.04
Global ST_Base1.f,ST_Base2.f, ST_Next.i, ST_FontWidth.w = 30, ST_Texture_Width.f = 0.0625, ST_Font_Gap.w = 2, ST_Text.S, ST_Position.i, ST_Delay_Scroller.i, Pages.i = 6
Global Colours.i, Page.i, Current_Page.i = 1, Current_Letter.i, Page_Swap_Duration.i = 280, Page_Swap_Time.i = 200, Current_Line.i, Current_Letter.i, PT_Delay.i=1, PT_Update.i
Global Dim MiniText.s(Pages,3,40), Dim Text_Page.s(3,40), Dim Balls.Balls(max_Balls), NewList Scrolltext.Scrolltext()
Global Font_Lookup_Text.S = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.!:,'?-£$/[]+               "
Global ST_Text = "      THE COMPANY AND VISION FACTORY PRESENTS  VROOM FROM LANKHOR SOFTWARE.     SUPPLIED BY LINK CRACKED BY THE COMPANY  THANX TO FIREBALL DIC AND GONOCOK SPECIAL REGARDS TO MARK  NOTE TO ALL NON BELIEVERS : FOXY IS DEAD AND OUTTA THE SCENE             REGARDS TO :  TRSI / CRYSTAL / SKID ROW / NEMESIS / FAIRLIGHT  / BITSTOPPERS / CONSPIRACY AND MARK AND ALL WE HAVE FORGOTTEN THIS TIME               THATS IT BYE .........           REMADE BY:    $£$£ PJAY274 £$£$ |     FOR:  DBFINTERACTIVE.COM|  AND  RETROREMAKES.NET  |       "
Define.i EveryOther, Event.i, SoundAvailable.i

Procedure ReadTextPages() ;/ reads in the text from the datasection to array
  Protected Page.i, X.i, Y.i, NTex.s
  Restore UpperText
  For Page = 1 To Pages
    For Y = 0 To 3
      Read.s NTex.s
      For X = 1 To 40 : MiniText(page,Y,X) = Mid(NTex,X,1) : Next
    Next
  Next
EndProcedure
ReadTextPages()
;}

;{ Window, OpenGL + other bits setup
If MessageRequester("Remade by PJAY274","WWW.RETROREMAKES.NET"+Chr(10)+"FULLSCREEN?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_No
  OpenWindow(#Window_Main, 0, 0, #WindowWidth, #ActualWindowHeight,"Vroom remake",#PB_Window_ScreenCentered|#PB_Window_BorderLess)
Else
  ExamineDesktops()
  OpenWindow(#Window_Main, 0, 0, DesktopWidth(0), DesktopHeight(0),"Vroom remake",#PB_Window_ScreenCentered|#PB_Window_BorderLess)
EndIf
OpenGLGadget(#Gad_OpenGL,0,0,WindowWidth(0),WindowHeight(0),#PB_OpenGL_Keyboard|#PB_OpenGL_FlipSynchronization|#PB_OpenGL_8BitStencilBuffer)
SetGadgetAttribute(#Gad_OpenGL,#PB_OpenGL_Cursor,#PB_Cursor_Invisible)



glEnable_(#GL_BLEND) : glBlendFunc_(#GL_SRC_ALPHA, #GL_ONE_MINUS_SRC_ALPHA);
glDepthMask_(#GL_FALSE) : glDisable_(#GL_DEPTH_TEST)
glEnable_(#GL_CULL_FACE) : glCullFace_(#GL_BACK)
glMatrixMode_(#GL_PROJECTION): glLoadIdentity_()
glDisable_(#GL_LIGHTING)
glOrtho_(0, #WindowWidth-1, 0, #WindowHeight-1, 0, 1)
glMatrixMode_(#GL_MODELVIEW) : glLoadIdentity_()

;/ read copperlist
Restore Copperlist: ;copd:
Read.w Copper1\length

For MyLoop=1 To Copper1\length
  Read.B Copper1\r[MyLoop] : Read.B Copper1\g[MyLoop] : Read.B Copper1\b[MyLoop]
  Copper1\r[MyLoop] * 15 : Copper1\r[MyLoop] * 1.133
  Copper1\g[MyLoop] * 15 : Copper1\g[MyLoop] * 1.133
  Copper1\b[MyLoop] * 15 : Copper1\b[MyLoop] * 1.133
Next

For MyLoop = 0 To max_Balls
  Balls(MyLoop)\X=Random(#WindowWidth)-#WindowWidth/2
  Balls(MyLoop)\Y=Random(#WindowHeight)-#WindowHeight/2
  Balls(MyLoop)\Z=Random(2000)/200.0
Next

;}

;/ *** Texture loading / processing
Procedure LoadTexture_(Texture.i) ; Returns the texture for an OpenGL application
  Protected Width.i, Height.i, NWidth.i, NHeight.i, X.i, Y.i, Colour.i, I.i, R.i, G.i, B.i, Tex.i
  
  If Texture = 0 : CatchImage(1, ?Bigtext)  : EndIf
  If Texture = 1 : CatchImage(1, ?RogLogo)  : EndIf
  If Texture = 2 : CatchImage(1, ?Ball)     : EndIf
  If Texture = 3 : CatchImage(1, ?Smallfont): EndIf
  
  Width = ImageWidth(1)
  Height = ImageHeight(1)

  NWidth  = Width : NHeight  = Height
  If NWidth > NHeight : NHeight = NWidth : EndIf ;/ had to force equal width / height due to compatability issues
  If NHeight > NWidth : NWidth = NHeight : EndIf ;/

  Dim ImageData.c(NWidth * NHeight * 4)
  
  StartDrawing(ImageOutput(1))

  For Y=0 To NHeight-1
    For X=0 To NWidth-1
      If Y>Height-1 Or X>Width
        Colour = 0 ;/ speeds up loading
      Else
        Colour = Point(X,Y)
        r=Red(Colour) : g=Green(Colour) : b=Blue(Colour)
        ImageData(i)=b : i+1
        ImageData(i)=g : i+1
        ImageData(i)=r : i+1
        ImageData(i)=255
      EndIf
      If r<15 And g<15 And b<15  : ImageData(i)=0 : EndIf 
      i+1
    Next
  Next
  StopDrawing()
  glGenTextures_(1, @tex.i) 
  glBindTexture_(#GL_TEXTURE_2D, tex)
  glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_NEAREST)
  glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_NEAREST)
  glTexParameteri_(#GL_TEXTURE_2D,#GL_TEXTURE_WRAP_S, #GL_CLAMP)
  glTexParameteri_(#GL_TEXTURE_2D,#GL_TEXTURE_WRAP_T, #GL_CLAMP)
  
  glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, NWidth, NHeight, 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, @ImageData());
  FreeImage(1)
  Dim ImageData(0)
  ProcedureReturn tex
EndProcedure
Procedure CopperTexture_() ; Returns the OpenGL texture 
  Protected Height.i, X.i, Y.i, I.i, Tex.i
  Height = Copper1\length
  Dim ImageData.c(Height*Height*4)
  For Y=1 To Height
    For X=1 To Height
      ImageData(i)=Copper1\b[Y] : i+1
      ImageData(i)=Copper1\g[Y] : i+1
      ImageData(i)=Copper1\r[Y] : i+1
      ImageData(i)=255 : i+1
    Next
  Next

  glGenTextures_(1, @tex)
  glBindTexture_(#GL_TEXTURE_2D, tex)
  glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_NEAREST)
  glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_NEAREST)
  glTexParameteri_(#GL_TEXTURE_2D,#GL_TEXTURE_WRAP_S, #GL_CLAMP)
  glTexParameteri_(#GL_TEXTURE_2D,#GL_TEXTURE_WRAP_T, #GL_CLAMP)
  
  glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, Height, Height, 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, @ImageData());
  Dim ImageData(0)
  ProcedureReturn tex
EndProcedure
Global MyTexture.i = LoadTexture_(0),  RogLogo.i = LoadTexture_(1), Ball_Texture.i = LoadTexture_(2), Smallfont.i = LoadTexture_(3), CopperTexture.i = CopperTexture_()
;/ ***

Procedure MiddleText() ;/ draws the static central text
  ;/ Would've been easier to have a single textured quad, but thus way it's modifiable...
  Protected Midtext.s = "VROOM!", YSize.i = 15, C.i, Letter_Texture_Pos.i, Yof.i, Yoff.f, XPos.i, YPos.i
  
  glEnable_(#GL_TEXTURE_2D)
  glBindTexture_(#GL_TEXTURE_2D,MyTexture)
  glBegin_(#GL_QUADS)
  For c = 0 To Len(Midtext)-1
    Letter_Texture_Pos = FindString(Font_Lookup_Text,Mid(Midtext,c+1,1),0)-1
    Yof = Int(((Letter_Texture_Pos-1) / 16))
    Yoff.f = Yof * 0.0625
    Letter_Texture_Pos = Letter_Texture_Pos - (Yof * 16)

    Xpos = (#WindowWidth/2)-((Len(Midtext)*ST_FontWidth)/2) : YPos = (#WindowHeight / 2)-(YSize/2.0)+1
    
    glColor4f_(0.66,0.66,0.66,1.0)
    glTexCoord2f_((ST_Texture_Width*Letter_Texture_Pos),Yoff+0.0585) : glVertex2i_(Xpos+(c*ST_FontWidth),YPos)
    glTexCoord2f_((ST_Texture_Width*Letter_Texture_Pos)+0.0624,Yoff+0.0585) : glVertex2i_(Xpos+(c*ST_FontWidth)+ST_FontWidth,YPos)
    glTexCoord2f_((ST_Texture_Width*Letter_Texture_Pos)+0.0624,Yoff+0) : glVertex2i_(Xpos+(c*ST_FontWidth)+ST_FontWidth,YPos+YSize)
    glTexCoord2f_((ST_Texture_Width*Letter_Texture_Pos),Yoff+0) : glVertex2i_(Xpos+(c*ST_FontWidth),YPos+YSize)
    YPos+1
    glColor4f_(0.4,0.427,0.533,1.0)
    glTexCoord2f_((ST_Texture_Width*Letter_Texture_Pos),Yoff+0.0585) : glVertex2i_(Xpos+(c*ST_FontWidth),YPos)
    glTexCoord2f_((ST_Texture_Width*Letter_Texture_Pos)+0.0624,Yoff+0.0585) : glVertex2i_(Xpos+(c*ST_FontWidth)+ST_FontWidth,YPos)
    glTexCoord2f_((ST_Texture_Width*Letter_Texture_Pos)+0.0624,Yoff+0) : glVertex2i_(Xpos+(c*ST_FontWidth)+ST_FontWidth,YPos+YSize)
    glTexCoord2f_((ST_Texture_Width*Letter_Texture_Pos),Yoff+0) : glVertex2i_(Xpos+(c*ST_FontWidth),YPos+YSize)
  Next
  glEnd_()
  glDisable_(#GL_TEXTURE_2D)
EndProcedure
Procedure Draw3dBalls() ;/ updates and draws the pseudo 3d balls
  Protected C.i, s_x.i, s_y.i, Size.f, SizeY.f
  ;/update
  glEnable_(#GL_TEXTURE_2D) : glBindTexture_(#GL_TEXTURE_2D,Ball_Texture)
  glBegin_(#GL_QUADS)
  glColor4f_(1.0,1.0,1.0,1.0)
  
  For C = 0 To Max_Balls
    Balls(c)\Z - BallSpeed
    
    If Balls(c)\Z <= BallSpeed : Balls(c)\Z+10 : EndIf
    
    If balls(c)\Z < 5
      s_x=(Balls(c)\X/Balls(c)\Z)+(#WindowWidth/2)
      s_y=(Balls(c)\Y/Balls(c)\Z)+(#WindowHeight/2)
      Size.f= 3.0 + (16 - (Balls(c)\Z)*2.0) : Sizey = Size / 2.0
      
      glTexCoord2f_(0,0) :glVertex2i_(s_x-Size,s_y+Sizey)
      glTexCoord2f_(0,1) :glVertex2i_(s_x-Size,s_y-Sizey)
      glTexCoord2f_(1,1) :glVertex2i_(s_x+Size,s_y-Sizey)
      glTexCoord2f_(1,0) :glVertex2i_(s_x+Size,s_y+Sizey)
    EndIf
  Next
  glEnd_()
  glDisable_(#GL_TEXTURE_2D)
EndProcedure
Procedure SmallFontText() ;/ updates the draws the top ticker-text
  Protected X.i, Y.i, SmT_YSize.i = 9, Smt_Ypos.i, Letter.s, Lup.l, txPos.f, txPosY.f, ST_Xpos.f, ST_Width.i
  
  If DrawnFrames > Page_Swap_Time
    
    ;/ swap between the two pages
    PT_Update-1
    If PT_Update < 1
      Current_Letter+1
      If Current_Letter = 41 : Current_Letter = 0 : : Current_Line + 1 : EndIf
      If Current_Line < 4
        Text_Page.S(Current_Line,Current_Letter) = MiniText(Current_Page,Current_Line,Current_Letter)
      EndIf
      
      If Current_Line = 4 : Current_Line = 0 : Page_Swap_Time = DrawnFrames + Page_Swap_Duration : Current_Page + 1 : EndIf
      If Current_Page > Pages : Current_Page = 1 : EndIf
      PT_Update = PT_Delay
      PT_Delay + 1
      If PT_Delay = 3 : PT_Delay = 1 : EndIf
    EndIf
  EndIf
  
  ;/ render
  glEnable_(#GL_TEXTURE_2D) :  glBindTexture_(#GL_TEXTURE_2D,Smallfont)
  glBegin_(#GL_QUADS)
  
  glColor4f_(1.0,1.0,1.0,1.0)
  For Y=0 To 3
    For X=1 To 40
      Smt_Ypos = 201-(Y*(SmT_YSize))
      Letter.s = Text_Page(Y,X)
      If Letter <> "" And Letter <> " "
        Lup.l = FindString("ABCDEFGHIJKLMNOPQRSTUVWXYZ!0123456789'()@,.-:;<>?ccccccccccccccccccc ",Letter.s,0)-1
        txPos.f = (Lup*8)/256.0
        ST_Xpos = ((X-1)*16)+0 : ST_Width = 15
        txPosY.f = 0
        If txPos.f > 1-0.03125
          txPosY.f = 0.03124
          txPos - 1
        EndIf
        
        glTexCoord2f_(txPos,txPosY+0) :glVertex2i_(ST_Xpos,Smt_Ypos+SmT_YSize-1)
        glTexCoord2f_(txPos,txPosY+0.027343) :glVertex2i_(ST_Xpos,Smt_Ypos)
        glTexCoord2f_(txPos+0.027343,txPosY+0.027343) :glVertex2i_(ST_Xpos+ST_Width,Smt_Ypos)
        glTexCoord2f_(txPos+0.027343,txPosY+0) :glVertex2i_(ST_Xpos+ST_Width,Smt_Ypos+SmT_YSize-1)
      EndIf
    Next
  Next

  glEnd_()
EndProcedure
Procedure Mirror_Surface() ;/ draws the lower 'mirrored' surface
  glBegin_(#GL_QUADS)
    glColor4f_(0,0.0,0.5,0.4)
    glVertex2f_(#WindowWidth,#TopBorder) : glVertex2f_(#WindowWidth,#TopBorder+23) : glVertex2f_(0,#TopBorder+23) : glVertex2f_(0,#TopBorder)
  glEnd_()
EndProcedure
Procedure After_Borders() ;/ draws the top and bottom black borders to mask overdrawn area
  glBegin_(#GL_QUADS)
    glColor4f_(0,0.0,0.0,1.0)
    glVertex2f_(#WindowWidth,0) : glVertex2f_(#WindowWidth,#TopBorder) : glVertex2f_(0,#TopBorder) : glVertex2f_(0,0)
    glVertex2f_(#WindowWidth,#WindowHeight-#TopBorder) : glVertex2f_(#WindowWidth,#WindowHeight) : glVertex2f_(0,#WindowHeight) : glVertex2f_(0,#WindowHeight-#TopBorder)
  glEnd_()
EndProcedure
Procedure Rainbow_Copper() ;/ draws the rainbow texture over the stencil mask
  glEnable_(#GL_TEXTURE_2D) :  glBindTexture_(#GL_TEXTURE_2D,CopperTexture)
  glBegin_(#GL_QUADS)
  glColor4f_(1.0,1.0,1.0,1.0)
    glTexCoord2f_(0,0)  :glVertex2i_(0,171)
    glTexCoord2f_(0,0.45) :glVertex2i_(0,41)
    glTexCoord2f_(1,0.45) :glVertex2i_(#WindowWidth,41)
    glTexCoord2f_(1,0)  :glVertex2i_(#WindowWidth,171)
  glEnd_()
  glDisable_(#GL_STENCIL_TEST)
EndProcedure
Procedure Draw_ScrollText() ;/ updates and draws the scrolltext on to the stencil buffer
  Protected letter$, Mult.i, YPos.i, YSize.i, Timmy.f, X.i, tY.f, TopM.f, BotM.f, HySize.f
  
  glEnable_(#GL_BLEND) : glBlendFunc_(#GL_SRC_ALPHA, #GL_ONE_MINUS_SRC_ALPHA);
  glColorMask_(#GL_FALSE, #GL_FALSE, #GL_FALSE, #GL_FALSE);
  glDepthMask_(#GL_TRUE);
  
  glEnable_(#GL_STENCIL_TEST);
  glStencilFunc_(#GL_ALWAYS, 1, $FFFFFFFF);
  glStencilOp_(#GL_REPLACE, #GL_REPLACE, #GL_REPLACE);
  glEnable_(#GL_ALPHA_TEST)
  glAlphaFunc_(#GL_GREATER  ,0.0)
  
  ;/ update
  If ST_Delay_Scroller = 0
    ForEach ScrollText()
      scrolltext()\X - 2
      If scrolltext()\X < -ST_FontWidth : DeleteElement(scrolltext()) : EndIf
    Next
    If DrawnFrames >= ST_Next; And ST_Delay_Scroller = 0
      ST_Position + 1 : If ST_Position > Len(ST_Text) : ST_Position = 0 : EndIf
      letter$ = Mid(ST_Text,ST_Position,1)
      If letter$ = "|" : ST_Delay_Scroller = 100 : ST_Next + 100: letter$ = " " : EndIf 
      If letter$<>" "
        AddElement(scrolltext())
        scrolltext()\X = #WindowWidth
        scrolltext()\Letter_Texture_Pos = FindString(Font_Lookup_Text,letter$,0)-1
        Mult = Int(scrolltext()\Letter_Texture_Pos / 16)
        scrolltext()\Letter_Texture_Pos = scrolltext()\Letter_Texture_Pos - (Mult*16)
        scrolltext()\Letter_Texture_Posy = Mult;*16
      EndIf
      ST_Next + (ST_FontWidth/2) + ST_Font_Gap
    EndIf
  Else
    ST_Delay_Scroller - 1
  EndIf
  
  ;/ render
  glEnable_(#GL_TEXTURE_2D) :  glBindTexture_(#GL_TEXTURE_2D,MyTexture)
  glBegin_(#GL_QUADS)
  
  YPos = #WindowHeight/2.4 : YSize = 32 : ST_Base1.f + 0.08 : ST_Base2.f + 0.14
  
  glColor4f_(1.0,1.0,1.0,1.0)
  timmy.f = Sin(offset/30.0)*0.5
  
  ForEach Scrolltext()
    X = scrolltext()\X
    tY.f=(Sin(ST_Base1+(X/120))*(#WindowHeight/(5.5+timmy))) ; ;Y.f=(Sin(base2+((X+20)/50))-Sin(base1+(X/40)))*80 ;/ double base
    YSize = 14  + (Sin(ST_Base2+X/360.0)*7.0)
    HySize.f = YSize/2.0
    TopM.f = 0.0580 : BotM.f = 0.005
    
    ;/ top
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos),(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+0.0585) : glVertex2i_(X,(tY+YPos-HySize)-1)
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos)+0.0585,(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+0.0585) : glVertex2i_(X+ST_FontWidth+2,(tY+YPos-HySize)-1)
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos)+0.0585,(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+TopM) : glVertex2i_(X+ST_FontWidth+2,(tY+YPos-HySize))
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos),(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+TopM) : glVertex2i_(X,(tY+YPos-HySize))
    ;/ middle
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos),(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+TopM) : glVertex2i_(X,tY+YPos-HySize)
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos)+0.0585,(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+TopM) : glVertex2i_(X+ST_FontWidth+2,tY+YPos-HySize)
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos)+0.0585,(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+BotM) : glVertex2i_(X+ST_FontWidth+2,tY+YPos+YSize)
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos),(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+BotM) : glVertex2i_(X,tY+YPos+YSize)
    ;/ bottom
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos),(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+BotM) : glVertex2i_(X,tY+YPos+YSize)
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos)+0.0585,(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+BotM) : glVertex2i_(X+ST_FontWidth+2,tY+YPos+YSize)
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos)+0.0585,(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+0.000) : glVertex2i_(X+ST_FontWidth+2,tY+YPos+YSize+2)
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos),(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+0.000) : glVertex2i_(X,tY+YPos+YSize+2)
  Next
  glEnd_()
  glDisable_(#GL_TEXTURE_2D) : glColorMask_(#GL_TRUE, #GL_TRUE, #GL_TRUE, #GL_TRUE);
  glStencilFunc_(#GL_EQUAL, 1, $FFFFFFFF) : glStencilOp_(#GL_KEEP, #GL_KEEP, #GL_KEEP);
EndProcedure
Procedure Draw_MirrorScrollText() ;/ inverts the main scroller and draw it on the  'mirrored' surface
  Protected YPos.i, Timmy.f, YSize.i, Ty.f, X.i, ShadPos.i, HySize.f
  glEnable_(#GL_TEXTURE_2D) :  glBindTexture_(#GL_TEXTURE_2D,MyTexture)
  glBegin_(#GL_QUADS)
  
  YPos = #WindowHeight/2.4 : YSize = 32 
  glColor4f_(0,0.0,0.53,1.0)
  timmy.f = Sin(offset/30.0)*0.5
  ForEach Scrolltext()
    X=scrolltext()\X

    tY.f=(Sin(ST_Base1+(X/120))*#WindowHeight/(5.5+timmy))
    YSize = 14.0  + (Sin(ST_Base2+X/360.0)*7.0)
    HySize.f = YSize/2.0 : ShadPos = 82
    
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos),(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+0.0) : glVertex2i_(X,ShadPos-(tY+YPos+YSize))
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos)+0.0585,(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+0.0) : glVertex2i_(X+ST_FontWidth,ShadPos-(tY+YPos+YSize))
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos)+0.0585,(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+0.0585) : glVertex2i_(X+ST_FontWidth,ShadPos-(tY+YPos-HySize))
    glTexCoord2f_((ST_Texture_Width*scrolltext()\Letter_Texture_Pos),(ST_Texture_Width*scrolltext()\Letter_Texture_Posy)+0.0585) : glVertex2i_(X,ShadPos-(tY+YPos-HySize))

  Next
  glEnd_()
  glDisable_(#GL_TEXTURE_2D)
EndProcedure
Procedure Draw_Rog_Logo() ;/ draw the tiny ROG logo
  glEnable_(#GL_TEXTURE_2D) :  glBindTexture_(#GL_TEXTURE_2D,RogLogo)
  glBegin_(#GL_QUADS)
  glColor4f_(0.867,0.867,0.867,1.0)
  glTexCoord2f_(0,0.3125) : glVertex2i_(609,20)
  glTexCoord2f_(1,0.3125) : glVertex2i_(609+32,20)
  glTexCoord2f_(1,0) : glVertex2i_(609+32,25)
  glTexCoord2f_(0,0) : glVertex2i_(609,25)
  glEnd_()
  glDisable_(#GL_TEXTURE_2D)
EndProcedure
Procedure BorderLines() ;/ draws the colourful border edges
  Protected X.i, ofs2.i, YPos1.i, YPos2.i
  glBegin_(#GL_QUADS)
  #CL_Step=16 : YPos1 = #TopBorder : YPos2 = #WindowHeight-#TopBorder
  For X=0 To #WindowWidth Step #CL_Step
    ofs2 = (X/#CL_Step) + offset : ofs2 % (180-16) : ofs2+1
    ;/set colour
    glColor4ub_(Copper1\r[ofs2],Copper1\g[ofs2],Copper1\b[ofs2],255)
    glVertex2i_(X,YPos2-1) : glVertex2i_(X+#CL_Step,YPos2-1): glVertex2i_(X+#CL_Step,YPos2): glVertex2i_(X,YPos2)
    glVertex2i_(#WindowWidth-X,YPos1+1) : glVertex2i_(#WindowWidth-(X+#CL_Step),YPos1+1): glVertex2i_(#WindowWidth-(X+#CL_Step),YPos1) : glVertex2i_(#WindowWidth-X,YPos1)
  Next
  glEnd_()
EndProcedure

Procedure Boot() ;/ rough simulation of the amiga boot sequence and decompression bars
  Protected Stage.i, Inctime.i, MyLoop.i, Y.i, Size.i
  IncTime = ElapsedMilliseconds() + 1000
  Stage = 0
  Repeat
    Delay(15)
    Select Stage
      Case 0 ;/ dark grey
        glBegin_(#GL_QUADS)
        glColor4f_(0.26,0.26,0.26,1.0)
        glVertex2f_(#WindowWidth,0) : glVertex2f_(#WindowWidth,#WindowHeight) : glVertex2f_(0,#WindowHeight) : glVertex2f_(0,0)
        glEnd_()
      Case 1 ;/ light grey
        glBegin_(#GL_QUADS)
        glColor4f_(0.52,0.52,0.52,1.0)
        glVertex2f_(#WindowWidth,0) : glVertex2f_(#WindowWidth,#WindowHeight) : glVertex2f_(0,#WindowHeight) : glVertex2f_(0,0)
        glEnd_()
        
      Case 2,3 ;/ white
        glBegin_(#GL_QUADS)
        glColor4f_(1.0,1.0,1.0,1.0)
        glVertex2f_(#WindowWidth,0) : glVertex2f_(#WindowWidth,#WindowHeight) : glVertex2f_(0,#WindowHeight) : glVertex2f_(0,0)
        glEnd_()
        
      Case 4
        Y = 0
        glBegin_(#GL_QUADS)
        Repeat
          Size = Random(5)+1
          glColor4f_(Random(100)/100,Random(100)/100,Random(100)/100,1.0)
          glVertex2f_(#WindowWidth,Y) : glVertex2f_(#WindowWidth,Y+Size) : glVertex2f_(0,Y+Size) : glVertex2f_(0,Y)
          Y + Size
        Until Y >= #WindowHeight
        glEnd_()
    EndSelect
    
    If ElapsedMilliseconds() > IncTime 
      IncTime = ElapsedMilliseconds() + 1000
      Stage + 1
    EndIf
    
    Repeat ;/ clear events
    Until Not WindowEvent()
    
    
    SetGadgetAttribute(#Gad_OpenGL,#PB_OpenGL_FlipBuffers,#True)
    
    glClear_(#GL_COLOR_BUFFER_BIT)

  Until Stage = 5
  Delay(75)
EndProcedure

SetActiveGadget(#Gad_OpenGL)
Boot()

If InitSound()
  SoundAvailable = 1
  CatchMusic(1,?Mod,?ModEnd - ?Mod)
  PlayMusic(1)
EndIf

;{/ Main Loop
Repeat
  Draw3dBalls()             ;/ 3d balls
  MiddleText()              ;/ Vroom logo
  Mirror_Surface()          ;/ Blue Mirror Border
  Draw_ScrollText()         ;/ Main Scroller
  Rainbow_Copper()          ;/ Colour the scroller
  Draw_Rog_Logo()           ;/ small ROG logo at bottom right
  Draw_MirrorScrollText()   ;/ Draw mirrored text
  BorderLines()             ;/ Colour scrolling line
  After_Borders()           ;/ top & bottom 'blackening' borders
  SmallFontText()           ;/ updates and draws the text window
  
  ;/ Update the BorderLines colour position
  everyother = 1 - everyother : If everyother : offset.f + 1 : EndIf

  ;/ Flip buffers
  DrawnFrames + 1
  SetGadgetAttribute(#Gad_OpenGL,#PB_OpenGL_FlipBuffers,#True)
  
  Repeat ;/ check for escape key & clear other events
    Event = WindowEvent()
    Select Event
      Case #PB_Event_Gadget ;/ must be our opengl gadget

    EndSelect
  Until Not Event
  
  glClear_(#GL_COLOR_BUFFER_BIT | #GL_STENCIL_BUFFER_BIT)
  
  ;/ ensure the music loops
  If SoundAvailable
   If GetMusicPosition(1) = 255
     If GetMusicRow(1) = 0 : SetMusicPosition(1, 0) : EndIf
   EndIf
 EndIf

Until Quit = #True
;}

DataSection
  mod:
  IncludeBinary "Monday.mod"
  modend:
  
  Bigtext:
  IncludeBinary "VroomFont.bmp"
  Bigtextend:
  
  Smallfont:
  IncludeBinary "VroomSmallFont.bmp"
  Smalltextend:
  
  RogLogo:
  IncludeBinary "RogLogo.bmp"
  RogLogoEnd:
  
  Ball:
  IncludeBinary "VroomBall.bmp"
  Ballend:
  
  UpperText:
  Data.S	"    VISION FACTORY AND THE COMPANY      "
	Data.S	"           PROVIDE YOU WITH             "
  Data.S	"                                        "
	Data.S	"      VROOM FROM LANKHOR SOFTWARE       "

	Data.S	"----------------------------------------"
	Data.S	"--  CALL OUR BULLETIN BOARDS SYSTEMS  --"
	Data.S	"--    UNDER THE FOLLOWING NUMBERS:    --"
	Data.S	"----------------------------------------"
	
	Data.S	"DANCE MACABRE     ---  713-324-2139     "
	Data.S	"UNDERWORLD        ---  916-429-2232     "
	Data.S	"THE HOLE          ---  313-363-4475     "
	Data.S	"CHILDS PLAY       ---  414-258-0337     "
  
	Data.S	"GURU HEAVEN       ---  708-752-9958     "
	Data.S	"BAD DREAMS        ---  (44)-816-759-693 "
	Data.S	"CIMMERIA          ---  (90)-138-408-63  "
	Data.S	"SOMEWHERE IN TIME ---  (46)-040-423-029 "
  
  Data.S  "PHANTOM ZONE      ---  (39)-805-574-376 "
	Data.S	"SECOND WORLD      ---  (49)-618-ELI-TE  "
	Data.S	"MAIDEN HOOD       ---  (49)-220-ELI-TE  "
	Data.S	"BLACK SKYLINE     ---  (49)-615-ELI-TE  "
  
  Data.S	"MIND BOMB         ---  (49)-220-ELI-TE  "
	Data.S	"                                        "
	Data.S	"                                        "
	Data.S	"                                        "

  CopperList:
  Data.w 256
  
  Data.B $F,$3,$0  ,$F,$4,$0  ,$F,$5,$0  ,$F,$6,$0  ,$F,$7,$0  ,$F,$8,$0  ,$F,$9,$0  ,$F,$A,$0  ,$F,$B,$0  ,$F,$C,$0
	Data.B $F,$D,$0  ,$F,$E,$0  ,$F,$F,$0  ,$E,$F,$0  ,$D,$F,$0  ,$C,$F,$0  ,$B,$F,$0  ,$A,$F,$0  ,$9,$F,$0  ,$8,$F,$0
	Data.B $7,$F,$0  ,$6,$F,$0  ,$5,$F,$0  ,$4,$F,$0  ,$3,$F,$0  ,$2,$F,$0  ,$1,$F,$0  ,$0,$F,$0  ,$0,$F,$1  ,$0,$F,$2
	Data.B $0,$F,$3  ,$0,$F,$4  ,$0,$F,$5  ,$0,$F,$6  ,$0,$F,$7  ,$0,$F,$8  ,$0,$F,$9  ,$0,$F,$A  ,$0,$F,$B  ,$0,$F,$C
	Data.B $0,$F,$D  ,$0,$F,$E  ,$0,$F,$F  ,$0,$E,$F  ,$0,$D,$F  ,$0,$C,$F  ,$0,$B,$F  ,$0,$A,$F  ,$0,$9,$F  ,$0,$8,$F
	Data.B $0,$7,$F  ,$0,$6,$F  ,$0,$5,$F  ,$0,$4,$F  ,$0,$3,$F  ,$0,$2,$F  ,$0,$1,$F  ,$0,$0,$F  ,$1,$0,$F  ,$2,$0,$F
	Data.B $3,$0,$F  ,$4,$0,$F  ,$5,$0,$F  ,$6,$0,$F  ,$7,$0,$F  ,$8,$0,$F  ,$9,$0,$F  ,$A,$0,$F  ,$B,$0,$F  ,$C,$0,$F
	Data.B $D,$0,$F  ,$E,$0,$F  ,$F,$0,$F  ,$F,$0,$E  ,$F,$0,$D  ,$F,$0,$C  ,$F,$0,$B  ,$F,$0,$A  ,$F,$0,$9  ,$F,$0,$8
	Data.B $F,$0,$7  ,$F,$0,$6  ,$F,$0,$5  ,$F,$0,$4  ,$F,$0,$3 ;  ,$F,$0,$2  ,$F,$0,$1  ,$F,$0,$0  ,$F,$1,$0  ,$F,$2,$0
	Data.B $F,$3,$0  ,$F,$4,$0  ,$F,$5,$0  ,$F,$6,$0  ,$F,$7,$0  ,$F,$8,$0  ,$F,$9,$0  ,$F,$A,$0  ,$F,$B,$0  ,$F,$C,$0
	Data.B $F,$D,$0  ,$F,$E,$0  ,$F,$F,$0  ,$E,$F,$0  ,$D,$F,$0  ,$C,$F,$0  ,$B,$F,$0  ,$A,$F,$0  ,$9,$F,$0  ,$8,$F,$0
	Data.B $7,$F,$0  ,$6,$F,$0  ,$5,$F,$0  ,$4,$F,$0  ,$3,$F,$0  ,$2,$F,$0  ,$1,$F,$0  ,$0,$F,$0  ,$0,$F,$1  ,$0,$F,$2
	Data.B $0,$F,$3  ,$0,$F,$4  ,$0,$F,$5  ,$0,$F,$6  ,$0,$F,$7  ,$0,$F,$8  ,$0,$F,$9  ,$0,$F,$A  ,$0,$F,$B  ,$0,$F,$C
	Data.B $0,$F,$D  ,$0,$F,$E  ,$0,$F,$F  ,$0,$E,$F  ,$0,$D,$F  ,$0,$C,$F  ,$0,$B,$F  ,$0,$A,$F  ,$0,$9,$F  ,$0,$8,$F
	Data.B $0,$7,$F  ,$0,$6,$F  ,$0,$5,$F  ,$0,$4,$F  ,$0,$3,$F  ,$0,$2,$F  ,$0,$1,$F  ,$0,$0,$F  ,$1,$0,$F  ,$2,$0,$F
	Data.B $3,$0,$F  ,$4,$0,$F  ,$5,$0,$F  ,$6,$0,$F  ,$7,$0,$F  ,$8,$0,$F  ,$9,$0,$F  ,$A,$0,$F  ,$B,$0,$F  ,$C,$0,$F
	Data.B $D,$0,$F  ,$E,$0,$F  ,$F,$0,$F  ,$F,$0,$E  ,$F,$0,$D  ,$F,$0,$C  ,$F,$0,$B  ,$F,$0,$A  ,$F,$0,$9  ,$F,$0,$8
  Data.B $F,$0,$7,  $F,$0,$6,  $F,$0,$5,  $F,$0,$4,  $F,$0,$3,  $F,$0,$2,  $F,$0,$1,  $F,$0,$0,  $F,$1,$0,  $F,$2,$0 ;- padded so the colours flow a bit bitter between lists.
  
  Data.B $F,$3,$0  ,$F,$4,$0  ,$F,$5,$0  ,$F,$6,$0  ,$F,$7,$0  ,$F,$8,$0  ,$F,$9,$0  ,$F,$A,$0  ,$F,$B,$0  ,$F,$C,$0
	Data.B $F,$D,$0  ,$F,$E,$0  ,$F,$F,$0  ,$E,$F,$0  ,$D,$F,$0  ,$C,$F,$0  ,$B,$F,$0  ,$A,$F,$0  ,$9,$F,$0  ,$8,$F,$0
	Data.B $7,$F,$0  ,$6,$F,$0  ,$5,$F,$0  ,$4,$F,$0  ,$3,$F,$0  ,$2,$F,$0  ,$1,$F,$0  ,$0,$F,$0  ,$0,$F,$1  ,$0,$F,$2
	Data.B $0,$F,$3  ,$0,$F,$4  ,$0,$F,$5  ,$0,$F,$6  ,$0,$F,$7  ,$0,$F,$8  ,$0,$F,$9  ,$0,$F,$A  ,$0,$F,$B  ,$0,$F,$C
	Data.B $0,$F,$D  ,$0,$F,$E  ,$0,$F,$F  ,$0,$E,$F  ,$0,$D,$F  ,$0,$C,$F  ,$0,$B,$F  ,$0,$A,$F  ,$0,$9,$F  ,$0,$8,$F
	Data.B $0,$7,$F  ,$0,$6,$F  ,$0,$5,$F  ,$0,$4,$F  ,$0,$3,$F  ,$0,$2,$F  ,$0,$1,$F  ,$0,$0,$F  ,$1,$0,$F  ,$2,$0,$F
	Data.B $3,$0,$F  ,$4,$0,$F  ,$5,$0,$F  ,$6,$0,$F  ,$7,$0,$F  ,$8,$0,$F  ,$9,$0,$F  ,$A,$0,$F  ,$B,$0,$F  ,$C,$0,$F
	Data.B $D,$0,$F  ,$E,$0,$F  ,$F,$0,$F  ,$F,$0,$E  ,$F,$0,$D  ,$F,$0,$C  ,$F,$0,$B  ,$F,$0,$A  ,$F,$0,$9  ,$F,$0,$8
	Data.B $F,$0,$7  ,$F,$0,$6  ,$F,$0,$5  ,$F,$0,$4  ,$F,$0,$3 ;  ,$F,$0,$2  ,$F,$0,$1  ,$F,$0,$0  ,$F,$1,$0  ,$F,$2,$0
	Data.B $F,$3,$0  ,$F,$4,$0  ,$F,$5,$0  ,$F,$6,$0  ,$F,$7,$0  ,$F,$8,$0  ,$F,$9,$0  ,$F,$A,$0  ,$F,$B,$0  ,$F,$C,$0
	Data.B $F,$D,$0  ,$F,$E,$0  ,$F,$F,$0  ,$E,$F,$0  ,$D,$F,$0  ,$C,$F,$0  ,$B,$F,$0  ,$A,$F,$0  ,$9,$F,$0  ,$8,$F,$0
	Data.B $7,$F,$0  ,$6,$F,$0  ,$5,$F,$0  ,$4,$F,$0  ,$3,$F,$0  ,$2,$F,$0  ,$1,$F,$0  ,$0,$F,$0  ,$0,$F,$1  ,$0,$F,$2
	Data.B $0,$F,$3  ,$0,$F,$4  ,$0,$F,$5  ,$0,$F,$6  ,$0,$F,$7  ,$0,$F,$8  ,$0,$F,$9  ,$0,$F,$A  ,$0,$F,$B  ,$0,$F,$C
	Data.B $0,$F,$D  ,$0,$F,$E  ,$0,$F,$F  ,$0,$E,$F  ,$0,$D,$F  ,$0,$C,$F  ,$0,$B,$F  ,$0,$A,$F  ,$0,$9,$F  ,$0,$8,$F
	Data.B $0,$7,$F  ,$0,$6,$F  ,$0,$5,$F  ,$0,$4,$F  ,$0,$3,$F  ,$0,$2,$F  ,$0,$1,$F  ,$0,$0,$F  ,$1,$0,$F  ,$2,$0,$F
  
  
  ;Data.B $F,$0,$7,
EndDataSection
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; CursorPosition = 506
; FirstLine = 110
; Folding = ACw
; Executable = Binary/Vroom v5.3.exe
; DisableDebugger