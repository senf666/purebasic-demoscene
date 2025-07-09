;Black Cats compil 14
;Code:          Oxygene
;Gfx:           MR40
;Music:         Mad Max (Quizmaster)
;Released:      July 1991
;Remake:        KrazyK 2024


;Copy the userlibraries folder into you Purelibraries folder.
;The OSME library is x86 only
;Tested on 5.73LTS
;Purebasic 6.xx has a problem with the image transparency function.
;I also find v6.xx slower for drawing sprites too, so i'm sticking with 5.73!


KK_Window(640,480)

Enumeration 
        #compil14
        #vubar
        #reddot
        #greydot
        #font
        #raster
        #scrollimage
        #bluerast
        #dotimg
        #creds
        #cats
EndEnumeration


;{ Init gfx etc...
;vubar stuff
CatchSprite(#vubar,?vubar)                            ;vu bar sprite
Global vol=72/15,ch0,ch1,ch2,ypos               ;vu vars

;scroller stuff
Global scroll$="            HELLO GUYS , WELCOME TO THE COMPIL 14 , PHENIX AND BLACK-CATS ARE PROUD TO YOU PRESENTED THIS.........THIS INTRO WAS CODED BY OXYGENE ....AND GRAPHIXS BY MR40 ......USE A KEY F1-F3      . THE MEMBERS OF PHENIX : ON ATARI-ST : OXYGENE ( VIVE LES FEMMES ET IODE ) , IODA (VIVE LES HOMMES ET OXYBULLE ) , MR40 , TMC ( VIVE LE BTS ) , POLARIS ( GOULOU GOULOU DANS LA CASE AVEC OXY. ET IODE ) , AZILKAPOUT (GLOUGLOU AU CAFE ) , RISKY BUSINESS , NOW AMIGA USER : ACE ( GROS GLANDEUR ET QUE DIRE DE PLUS !!!!! AH OUI FUCK FUCK DIDIER SIGNER ACE ) , FREON , SPEEDY , SCORPIO , PSY , JOHNNY.B , BEATTLE , DOC-PSYCHO , GAZIN ( AMSTRAD USER , YOU FUCK TOUJOURS ET ENCORE YOUR DOGS IN THE BOIS DE BOULOGNE ????? ) AND THAT ALL FOR THE MEMBERS OF PHENIX .      PHENIX WANT INTROS OR DEMO FOR THE NEXT COMPIL CONTACT US . ( LOOK THE END OF SCROLL ) , NOW LOOK THE GREETINGS          GREETINGS TO : THE BLACK CATS ( DOC-PROF,SHARPINOU THANK'S FOR THE INTROS ) , TSB ( ALL MEMBERS , EH ! DOC NO POUR MES COMPILS JE NE REPOMPE PAS DANS LES TSB COMPILS ) , THE ST-KNIGHTS ( KELLY X ) , THE BYTECHANGERS ( EXIT ) , ULM ( GUNSTICK ) , EQUINOX ( KRUEGER,STARLION ) , ARAKIS ( FRODON ) , ONYX ( FARAMIR ) , ST-CONNEXION ( VANTAGE ) , SUNY ( THANKS FOR THE TFS DEMO IN THE COMPIL ) THE BUSHWAKERS ( ALL MEMBERS ) , COBRA ( WIL ,THANKS FOR THE INTROS ) , DMA ( CORWIN ) , ZUUL ( BOSS ) , MAD-VISION ( SPY 3 ) , FUZION ( MAC-DOS , THANKS FOR THE INTROS ) , HEMOROID ( GLUEV , STRANGER ) , CPT LAMMARD ( THANKS FOR THE INTROS ) AND MERLIN THE EMPIRE ( SKYRACE ) , THE LIGHTNINGS ( ALL MEMBERS , COOL YOUR COMPILS BUT I HAVE ALL OF DEMO ) , UNDEAD ( MAD CURSOR ) , THE EMPEROR , THE BLACK BYTE , TDA ( SCC ) , LOST BOYS ( HELLO MICHAEL ) , IMPACT ( SUNSET ) , LEGACY ( FURY , VICKERS ) , THE CAREBEARS , POMPEY PIRATE , RIPPED OFF , ACF , THALION , MEDWAY BOYS , THE SYNDICATE , FOF , FOFT , PHALANX , THE ALLIANCE GERMANY , PHIL , MEGALO , FX , WARLOCK ( SORRY FOR YOUR DISK , I HAVE NOT TIME ) , CHUD , BDD XII , DCD , JINX , .......................          (C) PHENIX LE 28.06.91 A 17H09           BYE       BYE       BONNE NUIT ET SURTOUT BONNE VACANCES .......                        IF YOU WANT TO CONTACT US WRITE TO : OLIVIER V.          26,RUE LOUIS SELOSSE             59130        LAMBERSART           FRANCE                 LET'S WRAP .................                    "
Global speed=8,xmove=640,fwidth=64,fheight=70,letter=1
Global alpha$="ABCDEFGHIJKLMNOPQRSTUVWXYZ *;!?().,':-+&          0123456789"            ;ripped font layout
Global Dim chars(100)                                                                   ;font array
CatchImage(#font,?font)                                                                    ;font image
;grab all the letters into an image array
i=0
For fy=0 To 5
        For fx=0 To 9
                chars(i)=GrabImage(#font,#PB_Any,fx*fwidth,fy*fheight,fwidth,fheight) ;grab a letter into the image array
                i+1             
        Next fx
Next fy
CatchImage(#raster,?raster):ResizeImage(#raster,fwidth,fheight)           ;raster image resized to same as letter
CreateImage(#scrollimage,640,70)                                          ;scroller image to draw on

;fading compil stuff
CatchSprite(#compil14,?comp)                                    ;compil 14 image
Global fade.f=0,timer=ElapsedMilliseconds(),fadeinc.f=2.5       ;fade vars

;credits stuff
CatchSprite(#bluerast,?bars)                                           ;blue raster bars for credits
Global credy=-70,credtimer,crednum                              ;movement vars
CreateSprite(#creds,640,70)                       ;draw the credits on this sprite and move them down
CatchImage(#cats,?blackcats)                      ;black cats and phenix image


;}

Procedure Scroller()
        
hdc=    StartDrawing(ImageOutput(#scrollimage))
                For i=1 To 12
                        ;char$=Mid(scroll$,letter+i,1)                                   
                        pos=FindString(alpha$,Mid(scroll$,letter+i,1))-1                        ;find the letter value
                        If pos<0:pos=26:EndIf                                                   ;make valid
                        DrawImage(ImageID(#raster),xmove+(fwidth*i),0)                               ;raster
                        KK_DrawTransparentImage(hdc,chars(pos),xmove+(fwidth*i),0,#White)       ;letter drawn on with white as transparent so only the raster showws below.
                Next i
                StopDrawing()
        
        xmove-speed     ;scroll left
        If xmove=-128:xmove=-64:letter+1:EndIf          ;new letter
        If letter>Len(scroll$):letter=1:xmove=640:EndIf ;restart
        
        
        
EndProcedure

Procedure Credits()
        
        ;crednum 0=PHENIX
        ;crednum 1=BLACK CATS
        If credtimer=0:credy+2:EndIf    ;move if not paused
        
        If crednum=0 And credtimer>0 And ElapsedMilliseconds()-credtimer>5000:credtimer=0:crednum=1: credy=0  :EndIf
        If crednum=1 And credtimer>0 And ElapsedMilliseconds()-credtimer>3000:CallDebugger: credtimer=0:crednum=0: credy=-70:EndIf 
        
        If credtimer=0 And crednum=0 And credy>0
                credy=0
                credtimer=ElapsedMilliseconds() ;start the pause timer
        EndIf
        
        If credtimer=0 And credy>=70 And crednum=1      
                credy=70
                credtimer=ElapsedMilliseconds() ;start the pause timer
        EndIf
        
        StartDrawing(SpriteOutput(#creds))
                DrawImage(ImageID(#cats),0,credy)
                DrawImage(ImageID(#cats),0,credy-140)
        StopDrawing()
        
        DisplayTransparentSprite(#creds,0,12)
        DisplayTransparentSprite(#bluerast,0,0)        ;blue top raster bars
EndProcedure

Procedure MakeObject()
        
        ;The dot object was re-created by me and uses my custom vector bob library for Purebasic.
                
        KK_BobInitObject(?ob,?obend-?ob)                ;read the object data
        KK_BobSetCentre(320,200,300)                    ;centre the object
        CreateImage(#reddot,4,4,32,#Red)                ;red dot
        CreateImage(#greydot,4,4,32,RGB(100,100,100))   ;grey dot
        CreateImage(#dotimg,640,400)                    ;draw the dots object on this imageid
        KK_BobSetImage(#dotimg)                         ;set it
        Global x.f,y.f,z.f,x2.f,z2.f                    ;spin positions etc.
        
EndProcedure

Procedure VUBars()
        ;bar=16x72 
        
        ch0=OSMEGetVu(0)*vol
        ch1=OSMEGetVu(1)*vol
        ch2=OSMEGetVu(2)*vol
        
        ypos=36-(ch0/2)
        ClipSprite(#vubar,0,ypos,16,ch0)
        DisplayTransparentSprite(#vubar,0,228+ypos):DisplayTransparentSprite(#vubar,640-16,228+ypos)
        
        ypos=36-(ch1/2)
        ClipSprite(#vubar,0,ypos,16,ch1)
        DisplayTransparentSprite(#vubar,32,228+ypos):DisplayTransparentSprite(#vubar,640-48,228+ypos)
        
        ypos=36-(ch2/2)
        ClipSprite(#vubar,0,ypos,16,ch2)
        DisplayTransparentSprite(#vubar,64,228+ypos):DisplayTransparentSprite(#vubar,640-80,228+ypos)
        
        
EndProcedure

Procedure FadeCompil()
        If fade>=255
                fadeinc=-2.5
        EndIf
        If fade<=0
                fadeinc=2.5
        EndIf
        
        fade+fadeinc
        DisplayTransparentSprite(#compil14,320-(SpriteWidth(#compil14)/2),180,fade,RGB(224,224,224))    ;centred
        
EndProcedure

Procedure Dots()
                ;spin it!!
                x+0.054
                y+0.054
                z+0.024
                x2-0.0125
                z2+0.015
                KK_BobSetCentre(320+150*Sin(x2),200,1000+400*Sin(z2))   ;re-position the object
                KK_BobDrawBobs(x,y,z,1)                                 ;draw it on the imageid
                
                hdc=StartDrawing(ScreenOutput())                        ;draw images to the screen now
                        KK_DrawTransparentImage(hdc,#dotimg,0,40,#Black)     ;dots object with black as transparent
                        LineXY(0,150,640,150,#Blue)
                        LineXY(0,440-80,640,440-80,#Blue)
                        DrawImage(ImageID(#scrollimage),0,440-70)       ;scroller
                StopDrawing()     
EndProcedure



MakeObject()
 
        
        OSMEPlay(?music,?musend-?music,1)
        
        Repeat
                ClearScreen(0)
                event=WindowEvent()
                
                Credits()
                VUBars()
                Scroller()
                FadeCompil()
                Dots()
                
                FlipBuffers()
              
        Until GetEsc()
        
OSMEStop()


DataSection
        music:          :IncludeBinary "sfx\quizmaster.sndh"
        musend:
        bars:           :IncludeBinary "gfx\bars.bmp"
        vubar:          :IncludeBinary "gfx\vubar.bmp"
        font:           :IncludeBinary "gfx\font.bmp"
        raster:         :IncludeBinary "gfx\raster.bmp"
        blackcats:      :IncludeBinary "gfx\creds.bmp"
        comp:           :IncludeBinary "gfx\compil14.bmp"
        
        ob:
        IncludeFile "gfx\p1.pb"
        IncludeFile "gfx\p2.pb"
        obend:
        
EndDataSection


; DPIAware
; UseIcon = BlueFuji.ICO
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 210
; FirstLine = 31
; Folding = A+
; EnableXP
; DPIAware
; DisableDebugger
; HideErrorLog