InitSprite()

If OpenWindow(0, 0, 0, 820, 620, "Old School Decrunch Effect...", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
  If OpenWindowedScreen(WindowID(0), 10, 10, 800, 600, #True, 10, 10, #PB_Screen_NoSynchronization) ; x, y position, width, height, autostretch
    If CreateSprite(0, 800, 600) ; sprite, width, height
      
      Repeat
        MyEvent = WindowEvent()
        
        If StartDrawing(SpriteOutput(0))
          Box(0, Random(600), 800, 10, RGB((Random(255)), (Random(255)), (Random(255)))) ; Entire field x, y radius, width, height, colour
          StopDrawing()
        EndIf
        
        FlipBuffers() 
        DisplaySprite(0, 0, Random(600))
        
      Until MyEvent = #PB_Event_CloseWindow
      
    EndIf
  EndIf
EndIf