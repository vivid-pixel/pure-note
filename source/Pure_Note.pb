EnableExplicit

#Program_Title = "Pure Note"

Enumeration MenuButtons
  #Menu_Button_Open
  #Menu_Button_Save
  #Menu_Button_SaveAs
  #Menu_Button_About
  #Menu_Button_Quit
  #Menu_Button_WordWrap
EndEnumeration

Declare UpdateTitleBar(file_name.s)

#File_Types = "Text (*.txt)|*.txt;*.bat|All files (*.*)|*.*"

Define source_file
Define.s source_file_path
Define file_is_new = #True

; Characteristics of the main and only window, currently
Define window_flags = #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | 
                      #PB_Window_MaximizeGadget | #PB_Window_SizeGadget

; Creating our one-and-only window
Global window_main = OpenWindow(#PB_Any, 0, 0, 800, 600, #Program_Title, window_flags)

; Prevent window from becoming too small when resizing
WindowBounds(window_main, 320, 240, #PB_Ignore, #PB_Ignore)

; Create text area so we can output when we LoadFile()
Global text_area = EditorGadget(#PB_Any, 0, 0, 
                                WindowWidth(window_main), WindowHeight(window_main), 
                                #PB_Editor_WordWrap)

If (CreateMenu(#PB_Any, WindowID(window_main)))
  ; Defined when we determine Windows or OS X, to display platform-correct keyboard shortcuts.
  Define.s cmd_or_ctrl
  
  ; The program controls
  MenuTitle("File")
  
  ; OS X wants a special menu
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    ; The ~ allows escape sequences. \t inserts horizontal tab for spacing.
    cmd_or_ctrl = ~"\tCmd+"
    MenuItem(#Menu_Button_Open, "&Open" + cmd_or_ctrl + "O")
    MenuItem(#Menu_Button_Save, "&Save" + cmd_or_ctrl + "S")
    MenuItem(#Menu_Button_SaveAs, "&Save As" + cmd_or_ctrl + "Shift+S")
    MenuItem(#PB_Menu_About, "&About" + cmd_or_ctrl + "F1")
    MenuBar()
    MenuItem(#PB_Menu_Quit, "&Quit" + cmd_or_ctrl + "Q")
  CompilerElse
    cmd_or_ctrl = "Ctrl+"
    MenuItem(#Menu_Button_Open, "&Open" + cmd_or_ctrl + "O")
    MenuItem(#Menu_Button_Save, "&Save" + cmd_or_ctrl + "S")
    MenuItem(#Menu_Button_SaveAs, "&Save As" + cmd_or_ctrl + "Shift+S")
    MenuItem(#Menu_Button_About, "&About" + cmd_or_ctrl + "F1")
    MenuBar()
    MenuItem(#Menu_Button_Quit, "&Quit" + cmd_or_ctrl + "Q")
  CompilerEndIf
  
  MenuTitle("View")
    MenuItem(#Menu_Button_WordWrap, "&Word Wrap" + ~" On/Off")
EndIf


Procedure LoadFile(text_area)
  Shared source_file_path.s
  Shared source_file
  Shared file_is_new
  
  source_file_path.s = OpenFileRequester("Load Note", "", #File_Types, 0)
  
  ; Prompt for the text file so we can read it into the program
  source_file = OpenFile(#PB_Any, source_file_path.s)
  
  If IsFile(source_file)
    ; Read in the source_file contents line by line, until end-of-file
    Define.s loaded_text = ReadString(source_file, #PB_File_IgnoreEOL)
    
    ; Load text area up with source file's contents
    SetGadgetText(text_area, loaded_text)
    
    UpdateTitleBar(GetFilePart(source_file_path.s))
    
    file_is_new = #False
  EndIf
EndProcedure


Procedure SaveFile(text_area, save_as)
  Shared source_file_path.s
  Shared file_is_new
  
  ; We won't open the file picker if user didn't select Save As
  If save_as Or file_is_new
    source_file_path.s = SaveFileRequester("Save As", "untitled.txt", #File_Types, 0)
  EndIf
  
  Define file_to_save = CreateFile(#PB_Any, source_file_path.s, #PB_UTF8)
  
  If IsFile(file_to_save)
    If WriteString(file_to_save, GetGadgetText(text_area), #PB_UTF8)
      MessageRequester("Save File", "Save successful.")
      UpdateTitleBar(GetFilePart(source_file_path.s))
      ; For some reason the file did not save, so let the user know
    Else
      MessageRequester("Save File", 
                       "File failed to save. Permission issue?", 
                       #PB_MessageRequester_Error)
    EndIf
  EndIf
EndProcedure


Procedure About()
  Define.s URL = "https://github.com/vivid-pixel/pure-note"
  MessageRequester("About " + #Program_Title, 
                   ~"Coded in PureBasic! Visit\n" + URL, 
                   #PB_MessageRequester_Info)
EndProcedure


Procedure UpdateTitleBar(file_name.s)
  ; Display the current file name in the program title bar
  SetWindowTitle(window_main, file_name.s + " | " + #Program_Title)
EndProcedure


; The window's main loop, reacting to events such as menu-clicks and window resizes
Procedure Main()
  Repeat
    Protected event = WaitWindowEvent()
    Protected quit_program = #False
    Protected word_wrap = #True
    
    If event = #PB_Event_Menu
      Select EventMenu()
        ; Account for different options on OS X
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          Case #PB_Menu_About
            About()
          Case #PB_Menu_Quit
            quit_program = #True
        CompilerEndIf
          
        Case #Menu_Button_Open
          LoadFile(text_area)
        Case #Menu_Button_Save
          SaveFile(text_area, #False)
        Case #Menu_Button_SaveAs
          SaveFile(text_area, #True)
        Case #Menu_Button_About
          About()
        Case #Menu_Button_Quit
          quit_program = #True
          
        Case #Menu_Button_WordWrap
          If word_wrap
            SetGadgetAttribute(text_area, #PB_Editor_WordWrap, #False)
            word_wrap = #False
          Else
            SetGadgetAttribute(text_area, #PB_Editor_WordWrap, #True)
            word_wrap = #True
          EndIf
      EndSelect
    EndIf
    
    ; Scale program display as window is resized
    ResizeGadget(text_area, #PB_Ignore, #PB_Ignore, 
                 WindowWidth(window_main), WindowHeight(window_main))
    
  Until event = #PB_Event_CloseWindow Or quit_program
EndProcedure


Main()
