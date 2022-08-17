EnableExplicit

#Program_Title = "Pure Note"

Declare MenuOptions()

; Characteristics of the main and only window, currently
Define window_flags = #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | 
                      #PB_Window_MaximizeGadget | #PB_Window_SizeGadget

; Creating our one-and-only window currently
Define window_main = OpenWindow(#PB_Any, 0, 0, 800, 600, #Program_Title, window_flags)

WindowBounds(window_main, 320, 240, #PB_Ignore, #PB_Ignore)

Enumeration MenuButtons
  #Menu_Button_Open
  #Menu_Button_Quit
  #Menu_Button_About
EndEnumeration

Define menu_main = CreateMenu(#PB_Any, WindowID(window_main))
  MenuTitle("File")
    MenuItem(#Menu_Button_Open, "&Open" + Chr(9) + "Ctrl+O")
    MenuItem(#Menu_Button_Quit, "&Quit" + Chr(9) + "Ctrl+Q")
    MenuItem(#Menu_Button_About, "&About" + Chr(9) + "Ctrl+F1")

; BindMenuEvent(menu_main, menu_button_about, @MenuAbout())

; Read the text file so we can soon look at it
Define source_file = OpenFile(#PB_Any, "lorem_ipsum.txt")

; Read in the source_file contents line by line, until end-of-file
Define.s loaded_text = ReadString(source_file, #PB_File_IgnoreEOL)

; Allow scrolling if source_file is longer than the program window
Define scroll_bar = ScrollAreaGadget(#PB_Any, 0, 0, 
                                     WindowWidth(window_main), 
                                     WindowHeight(window_main), 
                                     WindowWidth(window_main), 
                                     WindowHeight(window_main))

; Create text area  and load it up with source_file's contents
Define text_area = EditorGadget(#PB_Any, 0, 0, WindowWidth(window_main), 
                                WindowHeight(window_main), #PB_Editor_WordWrap)
SetGadgetText(text_area, loaded_text)

; The window's main loop, reacting to events such as menu-clicks and window resizes
Repeat
  Define event = WaitWindowEvent()
  If event = #PB_Event_Menu          ; a menu event appeared
    Select EventMenu()
      Case #Menu_Button_About
        MessageRequester("About " + #Program_Title, 
                         "https://github.com/vivid-pixel/Pure_Note", 
                         #PB_MessageRequester_Info)
    EndSelect
  EndIf
  
  ResizeGadget(text_area, #PB_Ignore, #PB_Ignore, WindowWidth(window_main), 
               WindowHeight(window_main))
  ResizeGadget(scroll_bar, #PB_Ignore, #PB_Ignore, GadgetWidth(text_area), 
               GadgetHeight(text_area))
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; CursorPosition = 11
; EnableXP
; DPIAware
; CompileSourceDirectory
; Compiler = PureBasic 6.00 LTS (Linux - x64)