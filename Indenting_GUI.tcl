wm title . "TCL Indent Utility"
wm maxsize . 480 160
wm minsize . 480 160
set about "TCL Indent Utility\n\n"
append about "It is an application which add spaces/tabs in front of 'blocks' of code (such as If-End If), thus, making it easier for programmer and other people to see how the code flows (ie: which parts of the code will run under certain situations)."
set usage "Basically coded for linux/Unix based systems.\n Remove spaces in the file name(FOR MICROSOFT WINDOWS USERS ONLY)"
set dev "Created by: Dhruv Utkarsh Paul\nUnder the supervision and with the help of Vishal Mahajan, Synopsys."
set mainMenu [menu .mainmenu]
. configure -menu $mainMenu
set mFile [menu $mainMenu.mFile -tearoff 0]
$mainMenu add cascade -label "File" -menu $mFile
$mFile add command -label "Exit" -command exit
set mHelp [menu $mainMenu.mHelp -tearoff 0]
$mainMenu add cascade -label "Help" -menu $mHelp
$mHelp add command -label "About TCL Indent Utility" -command {tk_messageBox -icon info -type ok -title "About" -message $about}
$mHelp add command -label "Usage" -command {tk_messageBox -icon info -type ok -title "Usage" -message $usage}
$mHelp add separator
$mHelp add command -label "About The Developer" -command {tk_messageBox -icon info -type ok -title "About The Developer" -message $dev}
label .l1 -text "TCL INDENT UTILITY" -bg Blue -fg White -font {Helvetica -20 bold underline} -relief raised -width 40 -height 2
grid .l1 -row 0 -columnspan 3
set selection "default"
set theFile "Enter Here"
set cdir [pwd]/full_indent_tcl.tcl
label .l2 -text "select an option" -fg black -font {Helvetica -12 bold underline} -justify left
grid .l2 -row 1 -column 0
frame .choice
radiobutton .choice.cb1 -text "File" -variable choice -value "-f" -command "set selection -f" -font {Helvetica -12 } -justify left -underline 0 
radiobutton .choice.cb2 -text "Directory" -variable choice -value "-d" -command "set selection -d" -font {Helvetica -12  } -justify left -underline 0
grid .choice.cb1 -row 2 -column 0 -sticky w -pady 1 
grid .choice.cb2 -row 3 -column 0 -sticky w -pady 1
grid .choice -rowspan 2 -column 0
checkbutton .chk1 -text "Overwrite" -variable select -command {if { $select } {
   if { $selection == "-d"} {
   set selection "-di"
	} else {
   set selection "-fi"
   } } }
grid .chk1 -row 4 -column 0 
label .l3 -text "File/Directory Path"
grid .l3 -row 2  -column 1
entry .e1 -foreground Black -relief ridge -borderwidth 3 -font {Helvetica -10 italic bold} -width 35 -textvariable textField -justify left -text theFile
grid .e1 -row 3 -column 1
button .b1  -text "Browse" -width 6  -command {
	if { $selection == "-d" || $selection == "-di" } {
		set theFile [tk_chooseDirectory]
	} else {
		set theFile [tk_getOpenFile]
	}
}	
grid .b1 -row 3 -column 2 -sticky w
button .b2  -text "Run" -font {Helvetica -12 bold underline} -width 4 -command { exec tclsh full_indent_tcl.tcl $selection $theFile }
grid .b2 -row 4 -column 1
