EnableExplicit

#Program_Title = "Pure Note"

Enumeration MenuButtons
  #Menu_Button_Open
  #Menu_Button_Save
  #Menu_Button_SaveAs
  #Menu_Button_About
  #Menu_Button_Quit
EndEnumeration

Declare LoadFile(text_area, file_types.s)
Declare SaveFile(text_area)
Declare SaveFileAs(text_area, file_types.s)
Declare About()

; Used for LoadFile() and SaveFile()
Define.s file_types = "Text (*.txt)|*.txt;*.bat|All files (*.*)|*.*"
Define source_file
Define.s source_file_path

; Characteristics of the main and only window, currently
Define window_flags = #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | 
                      #PB_Window_MaximizeGadget | #PB_Window_SizeGadget

; Creating our one-and-only window
Define window_main = OpenWindow(#PB_Any, 0, 0, 800, 600, #Program_Title, window_flags)

; Create text area so we can output when we LoadFile()
Define text_area = EditorGadget(#PB_Any, 0, 0, WindowWidth(window_main), 
                                WindowHeight(window_main), #PB_Editor_WordWrap)

; The program controls
Define menu_main = CreateMenu(#PB_Any, WindowID(window_main))
MenuTitle("File")

; OS X wants a special menu
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
  MenuItem(#Menu_Button_Open, "&Open" + Chr(9) + "Cmd+O")
  MenuItem(#Menu_Button_Save, "&Save" + Chr(9) + "Cmd+S")
  MenuItem(#Menu_Button_SaveAs, "&Save As" + Chr(9) + "Cmd+Shift+S")
  MenuItem(#PB_Menu_About, "&About" + Chr(9) + "Cmd+F1")
  MenuItem(#PB_Menu_Quit, "&Quit" + Chr(9) + "Cmd-Q")
CompilerElse
  MenuItem(#Menu_Button_Open, "&Open" + Chr(9) + "Ctrl+O")
  MenuItem(#Menu_Button_Save, "&Save" + Chr(9) + "Ctrl+S")
  MenuItem(#Menu_Button_SaveAs, "&Save As" + Chr(9) + "Ctrl+Shift+S")
  MenuItem(#Menu_Button_About, "&About" + Chr(9) + "Ctrl+F1")
  MenuItem(#Menu_Button_Quit, "&Quit" + Chr(9) + "Ctrl+Q")
CompilerEndIf

; Prevent window from becoming too small when resizing
WindowBounds(window_main, 320, 240, #PB_Ignore, #PB_Ignore)

Procedure LoadFile(text_area, file_types.s)
  Shared window_main
  Shared source_file_path.s
  Shared source_file

  source_file_path.s = OpenFileRequester("Load Note", ".", file_types, 0)
  
  ; Prompt for the text file so we can read it into the program  
  source_file = OpenFile(#PB_Any, source_file_path.s)
  
  If IsFile(source_file)
    ; Read in the source_file contents line by line, until end-of-file
    Define.s loaded_text = ReadString(source_file, #PB_File_IgnoreEOL)
    
    ; Load text area up with source file's contents
    SetGadgetText(text_area, loaded_text)
    
    ; Display the current file name in the program title bar
    SetWindowTitle(window_main, GetFilePart(source_file_path.s) + " | " + #Program_Title)
    GetFilePart(source_file_path.s)
  Else
    MessageRequester("Load File", "Failed to load the file.", #PB_MessageRequester_Error)
  EndIf
EndProcedure


Procedure SaveFile(text_area)
  Shared source_file_path.s
  Define file_to_save = CreateFile(#PB_Any, source_file_path.s, #PB_UTF8)
  If IsFile(file_to_save)
    WriteString(file_to_save, GetGadgetText(text_area), #PB_UTF8)
    MessageRequester("Save File", "Save successful.")
  Else
    MessageRequester("Save File", "File failed to save. Permission issue?", #PB_MessageRequester_Error)
  EndIf
EndProcedure


Procedure SaveFileAs(text_area, file_types.s)
  Debug("TO-DO: Save As")
  SaveFileRequester("Save As", ".", file_types.s, 0)
EndProcedure

Procedure About()
  MessageRequester("About " + #Program_Title, 
                   "Coded in PureBasic | Visit github.com/vivid-pixel/Pure_Note", 
                   #PB_MessageRequester_Info)
EndProcedure


; The window's main loop, reacting to events such as menu-clicks and window resizes
Repeat
  Define event = WaitWindowEvent()
  Define quit_program = #False
  
  If event = #PB_Event_Menu
    Select EventMenu()
      Case #Menu_Button_Open
        LoadFile(text_area, file_types.s)
      Case #Menu_Button_Save
        SaveFile(text_area)
      Case #Menu_Button_SaveAs
        SaveFileAs(text_area, file_types.s)
      Case #Menu_Button_About
        About()
      Case #Menu_Button_Quit
        quit_program = #True
    EndSelect
  EndIf
  
  ; Scale program display as window is resized
  ResizeGadget(text_area, #PB_Ignore, #PB_Ignore, WindowWidth(window_main), 
               WindowHeight(window_main))
  
Until event = #PB_Event_CloseWindow Or quit_program
; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; CursorPosition = 20
; FirstLine = 52
; Folding = -
; EnableXP
; DPIAware
; CompileSourceDirectory
; Compiler = PureBasic 6.00 LTS (Linux - x64)