EnableExplicit

#Program_Title = "Pure Note"

Enumeration MenuButtons
  #Menu_Button_Open
  #Menu_Button_Quit
  #Menu_Button_About
EndEnumeration

Declare LoadFile()
Declare About()

; Characteristics of the main and only window, currently
Define window_flags = #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | 
                      #PB_Window_MaximizeGadget | #PB_Window_SizeGadget

; Creating our one-and-only window currently
Define window_main = OpenWindow(#PB_Any, 0, 0, 800, 600, #Program_Title, window_flags)

; Prevent window from becoming too small when resizing
WindowBounds(window_main, 320, 240, #PB_Ignore, #PB_Ignore)

; The program controls
Define menu_main = CreateMenu(#PB_Any, WindowID(window_main))
MenuTitle("File")
MenuItem(#Menu_Button_Open, "&Open" + Chr(9) + "Ctrl+O")
MenuItem(#Menu_Button_Quit, "&Quit" + Chr(9) + "Ctrl+Q")
MenuItem(#Menu_Button_About, "&About" + Chr(9) + "Ctrl+F1")

; Create text area so we can output when we LoadFile()
Define text_area = EditorGadget(#PB_Any, 0, 0, WindowWidth(window_main), 
                                WindowHeight(window_main), #PB_Editor_WordWrap)


Procedure LoadFile()
  Shared text_area
  
  ; Prompt for the text file so we can read it into the program
  Define.s file_types = "Text (*.txt)|*.txt;*.bat|PureBasic (*.pb)|*.pb|All files (*.*)|*.*"
  Define.s source_file_path = OpenFileRequester("Load Note", ".", file_types, 0)
  
  Define source_file = OpenFile(#PB_Any, source_file_path)
  
  ; Read in the source_file contents line by line, until end-of-file
  Define.s loaded_text = ReadString(source_file, #PB_File_IgnoreEOL)
  
  ; Load text area up with source file's contents
  SetGadgetText(text_area, loaded_text)
EndProcedure


Procedure About()
  MessageRequester("About " + #Program_Title, 
                   "Coded in PureBasic | Visit https://github.com/vivid-pixel/Pure_Note", 
                   #PB_MessageRequester_Info)
EndProcedure


; The window's main loop, reacting to events such as menu-clicks and window resizes
Repeat
  Define event = WaitWindowEvent()
  If event = #PB_Event_Menu          ; a menu event appeared
    Select EventMenu()
      Case #Menu_Button_Open
        LoadFile()
      Case #Menu_Button_About
        About()
      Case #Menu_Button_Quit
        Debug "To-do: quit button (use Alt-F4)"
    EndSelect
  EndIf
  
  ; Scale program display as window is resized
  ResizeGadget(text_area, #PB_Ignore, #PB_Ignore, WindowWidth(window_main), 
               WindowHeight(window_main))

Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; CursorPosition = 35
; FirstLine = 29
; Folding = -
; EnableXP
; DPIAware
; CompileSourceDirectory
; Compiler = PureBasic 6.00 LTS (Linux - x64)