set files [glob *.tcl]
set crd [pwd]
proc indent_file { f d op } {
	puts $f
	puts $d
	set fp [open "$f" r]
	set new_file [open "temp.tcl" w+]
	while {![eof $fp]} {
		gets $fp line
		regsub -all {^\s+} $line "" nline
		set $new_file $nline
		regsub -all {\s+$} $nline "" nline
		puts $new_file $nline
	}
	close $fp
	close $new_file
	set fp [open "temp.tcl" r]
	if { $op == "-di"} {
		set new_file [open "$f" w+]
	} else {
		set new_file [open "$d" w+]
	}
	set start 0
	set result ""
	while {![eof $fp]} {
		gets $fp line
		if {[regexp {^\#} $line]} {
			if {$start > 0} {
				set tabcounter $start
				set result ""
				while {$tabcounter > 0 } {
					append result "\t"
					incr tabcounter -1
				}
				regsub -all {^} $line $result nline
				puts $new_file $nline
			} else {
				puts $new_file $line
			}
		} else {
			if {$start > 0} {
				set tabcounter $start
				set result ""
				while {$tabcounter > 0 } {
					append result "\t"
					incr tabcounter -1
				}
				regsub -all {^} $line $result nline
				if {[regexp {\{$} $line] && [regexp {^\}} $line]} {
					incr start -1
					set tabcounter $start
					set result ""
					while {$tabcounter > 0 } {
						append result "\t"
						incr tabcounter -1
					}
					incr start
					regsub -all {^} $line $result nline
					puts $new_file $nline
				} elseif { [regexp {\{\s*\}$} $line] } {
					set tabcounter $start
					set result ""
					while { $tabcounter > 0 } {
						append result "\t"
						incr tabcounter -1
					}
					regsub -all {^} $line $result nline
					puts $new_file $nline
				} elseif {[regexp {\{$} $line]} {
					puts $new_file $nline
					incr start
				} elseif {[regexp {^\}} $line]} {
					incr start -1
					set tabcounter $start
					set result ""
					while {$tabcounter > 0 } {
						append result "\t"
						incr tabcounter -1
					}
					regsub -all {^} $line $result nline
					puts $new_file $nline
				} else {
					puts $new_file $nline
				}
			} else {
				if {[regexp {\{$} $line]} {
					puts $new_file $line
					incr start
				} elseif { [regexp {\{\s*\}$} $line] } {
					puts $new_file $line
					incr start
				} elseif {[regexp {\}$} $line]} {
					puts $new_file $line
					incr start -1
				} else {
					if {$start==0} {
						puts $new_file $line
					}
				}
			}
		}
	}
	close $fp
	close $new_file
}
set op [lindex $argv 0]
set dir [lindex $argv 1]
if { $op == "-d" } {
	file mkdir output
	foreach file [glob -directory $dir *.tcl] {
		set t [lrange [file split $file] end end]
		set d $crd/output
		set d $d/$t
		indent_file $file $d $op
	}
	cd $crd
	file delete -force temp.tcl
} elseif { $op == "-f" } {
	file mkdir output
	set t [lrange [file split $dir] end end]
	set d $crd/output
	set d $d/$t
	indent_file $dir $d $op
	cd $crd
	file delete -force temp.tcl
} elseif { $op == "-di" } {
	set t [lrange [file split $dir] end end]
	set d $crd/$t
	foreach file [glob -directory $dir *.tcl] {
		indent_file $file $d $op
	}
	cd $crd
	file delete -force temp.tcl
} elseif { $op == "-fi" } {
	set d $dir
	indent_file $dir $d $op
	file delete -force temp.tcl
} else {
	puts "Invalid command type"
}




