
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Constantes de dimensionnement <<<<<

#STARFIELD_STAR_MAX = 1500
#SNAKE_BALLS_MAX = 100

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Déclaration de la Structure <<<<<

Structure StarField
 
  FullScreenL.w
  FullScreenH.w
  SpeedMin.f
  Speed.f[#STARFIELD_STAR_MAX]
  PosX.f[#STARFIELD_STAR_MAX]
  PosY.f[#STARFIELD_STAR_MAX]
  PosZ.f[#STARFIELD_STAR_MAX]
 
EndStructure

Macro GetStarFieldFullScreenL(StarFieldA)
 
  StarFieldA\FullScreenL
 
EndMacro

Macro GetStarFieldFullScreenH(StarFieldA)
 
  StarFieldA\FullScreenH
 
EndMacro

Macro GetStarFieldSpeedMin(StarFieldA)
 
  StarFieldA\SpeedMin
 
EndMacro

Macro GetStarFieldSpeed(StarFieldA, Index)
 
  StarFieldA\Speed[Index]
 
EndMacro

Macro GetStarFieldPosX(StarFieldA, Index)
 
  StarFieldA\PosX[Index]
 
EndMacro

Macro GetStarFieldPosY(StarFieldA, Index)
 
  StarFieldA\PosY[Index]
 
EndMacro

Macro GetStarFieldPosZ(StarFieldA, Index)
 
  StarFieldA\PosZ[Index]
 
EndMacro

Macro SetStarFieldFullScreenL(StarFieldA, P_FullScreenL)
 
  GetStarFieldFullScreenL(StarFieldA) = P_FullScreenL
 
EndMacro

Macro SetStarFieldFullScreenH(StarFieldA, P_FullScreenH)
 
  GetStarFieldFullScreenH(StarFieldA) = P_FullScreenH
 
EndMacro

Macro SetStarFieldSpeedMin(StarFieldA, P_SpeedMin)
 
  GetStarFieldSpeedMin(StarFieldA) = P_SpeedMin
 
EndMacro

Macro SetStarFieldSpeed(StarFieldA, Index, P_Speed)
 
  GetStarFieldSpeed(StarFieldA, Index) = P_Speed
 
EndMacro

Macro SetStarFieldPosX(StarFieldA, Index, P_PosX)
 
  GetStarFieldPosX(StarFieldA, Index) = P_PosX
 
EndMacro

Macro SetStarFieldPosY(StarFieldA, Index, P_PosY)
 
  GetStarFieldPosY(StarFieldA, Index) = P_PosY
 
EndMacro

Macro SetStarFieldPosZ(StarFieldA, Index, P_PosZ)
 
  GetStarFieldPosZ(StarFieldA, Index) = P_PosZ
 
EndMacro

Macro ResetStarField(StarFieldA)
 
  SetStarFieldFullScreenL(StarFieldA, 0)
  SetStarFieldFullScreenH(StarFieldA, 0)
  SetStarFieldSpeedMin(StarFieldA, 0)
 
  For Index = 0 To #STARFIELD_STAR_MAX - 1
    SetStarFieldSpeed(StarFieldA, Index, 0)
    SetStarFieldPosX(StarFieldA, Index, 0)
    SetStarFieldPosY(StarFieldA, Index, 0)
    SetStarFieldPosZ(StarFieldA, Index, 0)
  Next
 
EndMacro

Macro RefreshStar3D(StarFieldA, Index)
 
  SetStarFieldSpeed(StarFieldA, Index, GetStarFieldSpeedMin(StarFieldA) + Random(Int(GetStarFieldSpeedMin(StarFieldA)))/10)
  SetStarFieldPosX(StarFieldA, Index, Random(3000) - 1500)
  SetStarFieldPosY(StarFieldA, Index, Random(3000) - 1500)
  SetStarFieldPosZ(StarFieldA, Index, 100 + Random(900))
 
EndMacro

Procedure InitializeStarField(*StarFieldA.StarField, P_FullScreenL.w, P_FullScreenH.w, P_SpeedMin.f = 4.75)
 
  SetStarFieldFullScreenL(*StarFieldA, P_FullScreenL)
  SetStarFieldFullScreenH(*StarFieldA, P_FullScreenH)
  SetStarFieldSpeedMin(*StarFieldA, P_SpeedMin)
 
  For Index = 0 To #STARFIELD_STAR_MAX - 1
    RefreshStar3D(*StarFieldA, Index)
  Next
 
EndProcedure

Procedure DisplayStarField(*StarFieldA.StarField)
 
  If StartDrawing(ScreenOutput())
     
      DrawingMode(1)
     
      For Index = 0 To #STARFIELD_STAR_MAX - 1
       
        GetStarFieldPosZ(*StarFieldA, Index) - GetStarFieldSpeed(*StarFieldA, Index)
       
        SX = GetStarFieldPosX(*StarFieldA, Index) / GetStarFieldPosZ(*StarFieldA, Index) * 100 + GetStarFieldFullScreenL(*StarFieldA) / 2
        SY = GetStarFieldPosY(*StarFieldA, Index) / GetStarFieldPosZ(*StarFieldA, Index) * 100 + GetStarFieldFullScreenH(*StarFieldA) / 2
       
        If SX < 39 Or SY < 39 Or SX >= GetStarFieldFullScreenL(*StarFieldA) Or SY >= GetStarFieldFullScreenH(*StarFieldA) Or GetStarFieldPosZ(*StarFieldA, Index) < 1
          RefreshStar3D(*StarFieldA, Index)
        Else
          Couleur = Int(255 - GetStarFieldPosZ(*StarFieldA, Index) * (255/1000))
          Plot(SX, SY, RGB(Couleur, Couleur, Couleur))
        EndIf
       
      Next
     
    StopDrawing()
   
  EndIf
 
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Déclaration de la Structure <<<<<

Structure Ball
 
  SpriteID.l
  PosX.f
  PosY.f
 
EndStructure

Macro GetBallSpriteID(BallA)
 
  BallA\SpriteID
 
EndMacro

Macro GetBallPosX(BallA)
 
  BallA\PosX
 
EndMacro

Macro GetBallPosY(BallA)
 
  BallA\PosY
 
EndMacro

Macro SetBallSpriteID(BallA, P_SpriteID)
 
  GetBallSpriteID(BallA) = P_SpriteID
 
EndMacro

Macro SetBallPosX(BallA, P_PosX)
 
  GetBallPosX(BallA) = P_PosX
 
EndMacro

Macro SetBallPosY(BallA, P_PosY)
 
  GetBallPosY(BallA) = P_PosY
 
EndMacro

Macro UpdateBall(BallA, P_SpriteID, P_PosX, P_PosY)
 
  SetBallSpriteID(BallA, P_SpriteID)
  SetBallPosX(BallA, P_PosX)
  SetBallPosY(BallA, P_PosY)
 
EndMacro

Macro ResetBall(BallA)
 
  If IsSprite(GetBallSpriteID(BallA)) <> 0
    FreeSprite(GetBallSpriteID(BallA))
  EndIf
 
  SetBallSpriteID(BallA, 0)
  SetBallPosX(BallA, 0)
  SetBallPosY(BallA, 0)
 
EndMacro

Macro UpdateBallPosition(BallA, P_PosX, P_PosY)
 
  SetBallPosX(BallA, P_PosX)
  SetBallPosY(BallA, P_PosY)
 
EndMacro

Macro MoveBallPosition(BallA, BallB, P_Speed)
 
  SetBallPosX(BallA, GetBallPosX(BallA) + (GetBallPosX(BallB) - GetBallPosX(BallA)) * P_Speed)
  SetBallPosY(BallA, GetBallPosY(BallA) + (GetBallPosY(BallB) - GetBallPosY(BallA)) * P_Speed)
 
EndMacro

Macro DisplayBall(BallA)
 
  DisplayTransparentSprite(GetBallSpriteID(BallA), GetBallPosX(BallA), GetBallPosY(BallA))
 
EndMacro

Procedure InitializeBall(*BallA.Ball, P_BallColor.l, P_BallDiameter.l)
 
  SetBallSpriteID(*BallA, CreateSprite(#PB_Any, P_BallDiameter, P_BallDiameter))
  BallRadius.l = P_BallDiameter >> 1
 
  If GetBallSpriteID(*BallA)
    If StartDrawing(SpriteOutput(GetBallSpriteID(*BallA)))
        Circle(BallRadius, BallRadius, BallRadius, P_BallColor)
      StopDrawing()
    EndIf
  EndIf
 
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Déclaration de la Structure <<<<<

Structure Snake
 
  FullScreenL.w
  FullScreenH.w
  HeadSpeed.f
  HeadAngle.f
  HeadPosX.f
  HeadPosY.f
  HeadMoveX.f
  HeadMoveY.f
  HeadRotation.f
  Distance.f
  Speed.f
  Angle.f
  ProximityCounter.l
  BallsColor.l
  BallsDiameter.w
  BallsRadius.w
  BallsMax.w
  Balls.Ball[#SNAKE_BALLS_MAX]
 
EndStructure

Macro GetSnakeFullScreenL(SnakeA)
 
  SnakeA\FullScreenL
 
EndMacro

Macro GetSnakeFullScreenH(SnakeA)
 
  SnakeA\FullScreenH
 
EndMacro

Macro GetSnakeHeadSpeed(SnakeA)
 
  SnakeA\HeadSpeed
 
EndMacro

Macro GetSnakeHeadAngle(SnakeA)
 
  SnakeA\HeadAngle
 
EndMacro

Macro GetSnakeHeadPosX(SnakeA)
 
  SnakeA\HeadPosX
 
EndMacro

Macro GetSnakeHeadPosY(SnakeA)
 
  SnakeA\HeadPosY
 
EndMacro

Macro GetSnakeHeadMoveX(SnakeA)
 
  SnakeA\HeadMoveX
 
EndMacro

Macro GetSnakeHeadMoveY(SnakeA)
 
  SnakeA\HeadMoveY
 
EndMacro

Macro GetSnakeHeadRotation(SnakeA)
 
  SnakeA\HeadRotation
 
EndMacro

Macro GetSnakeDistance(SnakeA)
 
  SnakeA\Distance
 
EndMacro

Macro GetSnakeSpeed(SnakeA)
 
  SnakeA\Speed
 
EndMacro

Macro GetSnakeAngle(SnakeA)
 
  SnakeA\Angle
 
EndMacro

Macro GetSnakeProximityCounter(SnakeA)
 
  SnakeA\ProximityCounter
 
EndMacro

Macro GetSnakeBallsColor(SnakeA)
 
  SnakeA\BallsColor
 
EndMacro

Macro GetSnakeBallsDiameter(SnakeA)
 
  SnakeA\BallsDiameter
 
EndMacro

Macro GetSnakeBallsRadius(SnakeA)
 
  SnakeA\BallsRadius
 
EndMacro

Macro GetSnakeBallsMax(SnakeA)
 
  SnakeA\BallsMax
 
EndMacro

Macro GetSnakeBalls(SnakeA, Index)
 
  SnakeA\Balls[Index]
 
EndMacro

Macro SetSnakeFullScreenL(SnakeA, P_FullScreenL)
 
  GetSnakeFullScreenL(SnakeA) = P_FullScreenL
 
EndMacro

Macro SetSnakeFullScreenH(SnakeA, P_FullScreenH)
 
  GetSnakeFullScreenH(SnakeA) = P_FullScreenH
 
EndMacro

Macro SetSnakeHeadSpeed(SnakeA, P_HeadSpeed)
 
  GetSnakeHeadSpeed(SnakeA) = P_HeadSpeed
 
EndMacro

Macro SetSnakeHeadAngle(SnakeA, P_HeadAngle)
 
  GetSnakeHeadAngle(SnakeA) = P_HeadAngle
 
EndMacro

Macro SetSnakeHeadPosX(SnakeA, P_HeadPosX)
 
  GetSnakeHeadPosX(SnakeA) = P_HeadPosX
 
EndMacro

Macro SetSnakeHeadPosY(SnakeA, P_HeadPosY)
 
  GetSnakeHeadPosY(SnakeA) = P_HeadPosY
 
EndMacro

Macro SetSnakeHeadMoveX(SnakeA, P_HeadMoveX)
 
  GetSnakeHeadMoveX(SnakeA) = P_HeadMoveX
 
EndMacro

Macro SetSnakeHeadMoveY(SnakeA, P_HeadMoveY)
 
  GetSnakeHeadMoveY(SnakeA) = P_HeadMoveY
 
EndMacro

Macro SetSnakeHeadRotation(SnakeA, P_HeadRotation)
 
  GetSnakeHeadRotation(SnakeA) = P_HeadRotation
 
EndMacro

Macro SetSnakeDistance(SnakeA, P_Distance)
 
  GetSnakeDistance(SnakeA) = P_Distance
 
EndMacro

Macro SetSnakeSpeed(SnakeA, P_Speed)
 
  GetSnakeSpeed(SnakeA) = P_Speed
 
EndMacro

Macro SetSnakeAngle(SnakeA, P_Angle)
 
  GetSnakeAngle(SnakeA) = P_Angle
 
EndMacro

Macro SetSnakeProximityCounter(SnakeA, P_ProximityCounter)
 
  GetSnakeProximityCounter(SnakeA) = P_ProximityCounter
 
EndMacro

Macro SetSnakeBallsColor(SnakeA, P_BallsColor)
 
  GetSnakeBallsColor(SnakeA) = P_BallsColor
 
EndMacro

Macro SetSnakeBallsDiameter(SnakeA, P_BallsDiameter)
 
  GetSnakeBallsDiameter(SnakeA) = P_BallsDiameter
 
EndMacro

Macro SetSnakeBallsRadius(SnakeA, P_BallsRadius)
 
  GetSnakeBallsRadius(SnakeA) = P_BallsRadius
 
EndMacro

Macro SetSnakeBallsMax(SnakeA, P_BallsMax)
 
  GetSnakeBallsMax(SnakeA) = P_BallsMax
 
EndMacro

Macro SetSnakeBalls(SnakeA, Index, P_Balls)
 
  CopyBall(P_Balls, GetSnakeBalls(SnakeA, Index))
 
EndMacro

Macro ResetSnake(SnakeA)
 
  SetSnakeFullScreenL(SnakeA, 40)
  SetSnakeFullScreenH(SnakeA, 40)
  SetSnakeHeadSpeed(SnakeA, 0)
  SetSnakeHeadAngle(SnakeA, 0)
  SetSnakeHeadPosX(SnakeA, 40)
  SetSnakeHeadPosY(SnakeA, 40)
  SetSnakeHeadMoveX(SnakeA, 0)
  SetSnakeHeadMoveY(SnakeA, 0)
  SetSnakeHeadRotation(SnakeA, 0)
  SetSnakeDistance(SnakeA, 0)
  SetSnakeSpeed(SnakeA, 0)
  SetSnakeAngle(SnakeA, 0)
  SetSnakeProximityCounter(SnakeA, 0)
  SetSnakeBallsColor(SnakeA, 0)
  SetSnakeBallsDiameter(SnakeA, 0)
  SetSnakeBallsRadius(SnakeA, 0)
  SetSnakeBallsMax(SnakeA, 0)
 
  For Index = 0 To #SNAKE_BALLS_MAX - 1
    ResetBall(GetSnakeBalls(SnakeA, Index))
  Next
 
EndMacro

Procedure InitializeSnake(*SnakeA.Snake, P_FullScreenL.w, P_FullScreenH.w, P_BallsColor.l, P_BallsDiameter.l = 32, P_BallsMax.w = #SNAKE_BALLS_MAX)
 
  SetSnakeFullScreenL(*SnakeA, P_FullScreenL)
  SetSnakeFullScreenH(*SnakeA, P_FullScreenH)
  SetSnakeHeadSpeed(*SnakeA, 10)
  SetSnakeHeadAngle(*SnakeA, 0)
  SetSnakeHeadPosX(*SnakeA, 0)
  SetSnakeHeadPosY(*SnakeA, 0)
  SetSnakeHeadMoveX(*SnakeA, 0)
  SetSnakeHeadMoveY(*SnakeA, 0)
  SetSnakeHeadRotation(*SnakeA, 2 * #PI / 120)
  SetSnakeDistance(*SnakeA, 0)
  SetSnakeSpeed(*SnakeA, 0.20)
  SetSnakeProximityCounter(*SnakeA, 0)
  SetSnakeBallsColor(*SnakeA, P_BallsColor)
  SetSnakeBallsDiameter(*SnakeA, P_BallsDiameter)
  SetSnakeBallsRadius(*SnakeA, P_BallsDiameter >> 1)
 
  If P_BallsMax > #SNAKE_BALLS_MAX
    P_BallsMax = #SNAKE_BALLS_MAX
  EndIf
 
  SetSnakeBallsMax(*SnakeA, P_BallsMax)
 
  For Index = 0 To GetSnakeBallsMax(*SnakeA) - 1
    InitializeBall(GetSnakeBalls(*SnakeA, Index), GetSnakeBallsColor(*SnakeA), GetSnakeBallsDiameter(*SnakeA))
  Next
 
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Display <<<<<

Procedure DisplaySnake(*SnakeA.Snake)
 
  ; Position de la première boule que l'on calcule
  ; Il s'agit de la boule 0
 
  If GetSnakeDistance(*SnakeA) < GetSnakeHeadSpeed(*SnakeA) ; Si on est arrivé, on va vers un autre point en aléatoire
    SetSnakeHeadMoveX(*SnakeA, Random(GetSnakeFullScreenL(*SnakeA)))
    SetSnakeHeadMoveY(*SnakeA, Random(GetSnakeFullScreenH(*SnakeA)))
  EndIf
 
  If GetSnakeDistance(*SnakeA) < GetSnakeHeadSpeed(*SnakeA) * 40 ; Si on arrive pas à atteindre le point au bout d'un moment, on dis qu'on l'a eu
   
    SetSnakeProximityCounter(*SnakeA, GetSnakeProximityCounter(*SnakeA) + 1)
   
    If GetSnakeProximityCounter(*SnakeA) > 200
      SetSnakeHeadMoveX(*SnakeA, Random(GetSnakeFullScreenL(*SnakeA)))
      SetSnakeHeadMoveY(*SnakeA, Random(GetSnakeFullScreenH(*SnakeA)))
    EndIf
   
  Else
   
    SetSnakeProximityCounter(*SnakeA, 0)
   
  EndIf
 
  ; Distance entre la boule et le point visé
 
  SetSnakeDistance(*SnakeA, Sqr((GetSnakeHeadMoveX(*SnakeA) - GetSnakeHeadPosX(*SnakeA)) * (GetSnakeHeadMoveX(*SnakeA) - GetSnakeHeadPosX(*SnakeA)) + (GetSnakeHeadMoveY(*SnakeA) - GetSnakeHeadPosY(*SnakeA)) * (GetSnakeHeadMoveY(*SnakeA) - GetSnakeHeadPosY(*SnakeA))))
 
  ; Angle entre la boule et le point visé
 
  If GetSnakeHeadMoveX(*SnakeA) >= GetSnakeHeadPosX(*SnakeA) And GetSnakeHeadMoveY(*SnakeA) >= GetSnakeHeadPosY(*SnakeA) ; entre 0 et Pi/2
    SetSnakeAngle(*SnakeA, ACos((GetSnakeHeadMoveX(*SnakeA) - GetSnakeHeadPosX(*SnakeA)) / GetSnakeDistance(*SnakeA)))
  ElseIf GetSnakeHeadMoveX(*SnakeA) >= GetSnakeHeadPosX(*SnakeA) And GetSnakeHeadMoveY(*SnakeA) <= GetSnakeHeadPosY(*SnakeA) ; entre 0 et -Pi/2
    SetSnakeAngle(*SnakeA, -ACos((GetSnakeHeadMoveX(*SnakeA) - GetSnakeHeadPosX(*SnakeA)) / GetSnakeDistance(*SnakeA)))
  ElseIf GetSnakeHeadMoveX(*SnakeA) <= GetSnakeHeadPosX(*SnakeA) And GetSnakeHeadMoveY(*SnakeA) >= GetSnakeHeadPosY(*SnakeA) ; entre Pi/2 et Pi
    SetSnakeAngle(*SnakeA, #PI - ACos((GetSnakeHeadPosX(*SnakeA) - GetSnakeHeadMoveX(*SnakeA)) / GetSnakeDistance(*SnakeA)))
  Else ; entre -Pi/2 et -Pi
    SetSnakeAngle(*SnakeA, -#PI + ACos((GetSnakeHeadPosX(*SnakeA) - GetSnakeHeadMoveX(*SnakeA)) / GetSnakeDistance(*SnakeA)))
  EndIf
 
  ; Si l'angle est plus grand que #Pi ou plus petit que -#Pi, on le ramene est -#pi et #pi
 
  If GetSnakeHeadAngle(*SnakeA) > #PI
    SetSnakeHeadAngle(*SnakeA, GetSnakeHeadAngle(*SnakeA) - 2 * #PI)
  EndIf
 
  If GetSnakeHeadAngle(*SnakeA) < -#PI
    SetSnakeHeadAngle(*SnakeA, GetSnakeHeadAngle(*SnakeA) + 2 * #PI)
  EndIf
 
  ; on regarde dans quel sens on doit faire évoluer l'angle
 
  If GetSnakeHeadAngle(*SnakeA) >= GetSnakeAngle(*SnakeA)
    If GetSnakeHeadAngle(*SnakeA) - GetSnakeAngle(*SnakeA) > #PI
      SetSnakeHeadAngle(*SnakeA, GetSnakeHeadAngle(*SnakeA) + GetSnakeHeadRotation(*SnakeA))
    Else
      SetSnakeHeadAngle(*SnakeA, GetSnakeHeadAngle(*SnakeA) - GetSnakeHeadRotation(*SnakeA))
    EndIf
  Else
    If GetSnakeAngle(*SnakeA) - GetSnakeHeadAngle(*SnakeA) > #PI
      SetSnakeHeadAngle(*SnakeA, GetSnakeHeadAngle(*SnakeA) - GetSnakeHeadRotation(*SnakeA))
    Else
      SetSnakeHeadAngle(*SnakeA, GetSnakeHeadAngle(*SnakeA) + GetSnakeHeadRotation(*SnakeA))
    EndIf
  EndIf
 
  ; On déplace suivant l'angle
 
  SetSnakeHeadPosX(*SnakeA, (GetSnakeHeadPosX(*SnakeA) + Cos(GetSnakeHeadAngle(*SnakeA)) * GetSnakeHeadSpeed(*SnakeA)))
  SetSnakeHeadPosY(*SnakeA, (GetSnakeHeadPosY(*SnakeA) + Sin(GetSnakeHeadAngle(*SnakeA)) * GetSnakeHeadSpeed(*SnakeA)))
 
  UpdateBallPosition(GetSnakeBalls(*SnakeA, 00), GetSnakeHeadPosX(*SnakeA) - GetSnakeBallsRadius(*SnakeA), GetSnakeHeadPosY(*SnakeA) - GetSnakeBallsRadius(*SnakeA))
 
  For n = (GetSnakeBallsMax(*SnakeA) - 1) To 1 Step -1 ; Pour chaque boule
   
    MoveBallPosition(GetSnakeBalls(*SnakeA, n), GetSnakeBalls(*SnakeA, n - 1), GetSnakeSpeed(*SnakeA))
    DisplayBall(GetSnakeBalls(*SnakeA, n))
   
  Next
 
  DisplayBall(GetSnakeBalls(*SnakeA, 00))
 
EndProcedure
; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 588
; FirstLine = 563
; Folding = ------------
; EnableXP
; EnableCompileCount = 0
; EnableBuildCount = 0