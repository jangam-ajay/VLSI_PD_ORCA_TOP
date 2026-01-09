place_opt -from initial_drc -to initial_drc
set i drc [violation 1]

place_opt -from initial_opto -to initial_opto
set i_opto [violation 2]

place_opt -from final_place -to final_place
set f_place [violation 3]

place_opt -from final_opto -to final_opto
set f_opto [violation 4]

#save_block -as place_opt_done

proc violation {a} {
report_constraints -max_transition -all_violators -significant_digits 3 -scenarios + -nosplit > ./outputs/placeopt/maxtran$a.txt
report_constraints -max_capacitance -all_violators -significant_digits 3 -scenarios * -nosplit > ./outputs/placeopt/maxcap$a.txt

report_global_timing >./outputs/tv$a.txt
check_legality > ./outputs/legality$a.txt
report_congestion -rerun_global_router > ./outputs/congestion$a.txt
Set mlist (}
set b [sizeof_collection [get_flat_cells -filter "ref_name =- +NBUF*"]]
set bl "Buffer count :$b"
Lappend mlist $b1
set i [sizeof_collection [get_flat_cells -filter "ref_name =~* INV*"]]
set il "Inv count :$i"
Lappend mlist $il

set fh [open "./outputs/placeopt/maxtran$a.txt" r]
while {[gets $fh line]>=0} {
if {[regexp { [A-Za-z_]+\([a-z]\): ([0-9]+)} $line vl]} {
Lappend mlist $v1
}
}
set fh [open "./outputs/placeopt/maxcap$a.txt" r]
while {[gets $fh line]>=0} {
if {[regexp { [A-Za-z_]+\([a-z]\): ([0-9]+)} $line v2]} {
lappend mlist $v2
}
}
return $mlist
}
puts "After initial drc : -
#puts $i drc
foreach var $i drc {
puts $var
}
puts "After initial_opto :
#puts $i opto
foreach var $i_opto {
puts $var
}
puts "After final place :
#puts $i_drc
foreach var $f_place {
puts $var
}
puts "After final_opto :-
#puts $i opto
foreach var $f_opto {
puts $var
}
