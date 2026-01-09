#####Inserting the buffer ############

proc insert_buffer_cell {nn} {
set dpin [get_object_name [get_pins [all_connected $nn -leaf ] -filter "direction == out"]]
#driving cell -instance name
#ISDRAM/U123/Y = dpin

set cn [insert_buffer $dpin NBUFFX8_LVT]
set ploc [get_attribute [get_pins $dpin] location]
move_objects -to $ploc $cn

}

####### proc ends ##############

set file_name ./outputs/R/mcv_apo.txt
set fh_read [open $file_name r]
set m 0
set n 0
set i 0
while {[gets $fh_read line]>=0} {
if {[llength $line] == 5} {
incr i
puts "\n iteration : $i"
set net_name [lindex $line 0]
set flag [catch {insert_buffer_cell $net_name}]
if {$flag == 0} {
puts "insert buffer is done successfully"
incr m
} else {
puts "failure to insert the buffer"
incr n

}
}
legalize_placement -incremental
puts "Number of buffers inserted $m"
puts "number of buffers failed insert$n"
