;2 = 	4000ms second pause
;3 = 	4000ms before clearing for next text screen

DataSection
typer:
Data.s    "The D.R.S. present...."
Data.s	  ""
Data.s    "    AUTOMATION 384"
Data.s    "    =============="+Chr(3)	;pause before clearing for next text screen

Data.s    "Well here we are again"
Data.s    "with yet another menu"
Data.s    "or your pleasure????"+Chr(2)	;pauses here before continuing on same screen
Data.s    "Or displeasure if you"
Data.s    "prefer!!"+Chr(3)

Data.s    "Mega music from:"
Data.s    "CRISPY NOODLE"+Chr(3)

Data.s    "Torvak The Warrior" 
Data.s    "has been fully" 
Data.s    "unpacked and repacked"
Data.s    "to make it smaller"
Data.s    "than any other groups"+Chr(3)

Data.s    "This is why we are"
Data.s    "able to put this crap"
Data.s    "Gran 'n' Prix on with"
Data.s    "it as well as the docs"+Chr(3)

Data.s    "Mega Mighty thanks go"
Data.s    "to The MEDWAY BOYS for"
Data.s    "the docs (ripped from"
Data.s    "their Menu 95), but" 
Data.s    "full credit is given."
Data.s    "No pretence on our CD"+Chr(3)

Data.s    "Well I suppose it's"
Data.s    "on with the GREETS"+Chr(3)

Data.s    "All AUTOMATION members"+Chr(3)

Data.s    "DEREK M.D and BECKY"
Data.s    "(and ROBBIE)"+Chr(3)

Data.s    "The MEDWAY BOYS"
Data.s    "(100 coming up)"+Chr(3)

Data.s    "The POMPEY PIRATES"+Chr(3)

Data.s    "The EMPIRE"+Chr(3)

Data.s    "The REPLICANTS"+Chr(3)

Data.s    "FLAME OF FINLAND"
Data.s    "(Get in touch eh??)"+Chr(3)

Data.s    "The Mr. MEN !!!!"+Chr(3)

Data.s    "The ST/AMIGOS"+Chr(3)

Data.s    "The T.O.T.E"+Chr(3)

Data.s    "The B.B.C"+Chr(3)

Data.s    "and YOU for reading"+Chr(3)
near:
Data.s    " All coding copyright:"
Data.s    " MONSTER INCORP 1990"
Data.s    "  ==================="+Chr(3)

Data.s    "Let's Wrap - O.K"+Chr(3)
Data.s	  Chr($ff)		;end code
EndDataSection

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 16
; FirstLine = 4
; EnableXP
; DisableDebugger
; CompileSourceDirectory
; EnablePurifier