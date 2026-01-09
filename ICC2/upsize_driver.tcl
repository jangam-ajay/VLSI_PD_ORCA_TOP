#upsize = NBUFFX4_LVT
puts "driver_name : $dn driver_ref_name : $drn"
regexp -nocase {( .+X) ( [0-9]+) (.+)} $drn temp rn ds vt
#temp = NBUFFX2_LVT
#rn = NBUFFX
#ds = 2
#vt = LVT

if {$ds == 0} {
set ds 1
} else {
set ds [expr $ds*2]

}
#$ds = 4

size_cell $dn $rn$ds$vt
set drn [get_attribute [get_cell $dn] ref_name]
puts "driver_name : $dn new_ref_name : $drn"

############## proc ends ##############

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
set flag [catch {upsize_cell $net_name}]
if {$flag == 0} {
puts "upsize is done successfully"
incr m
} else {
puts "failed to upsize"
incr n
}
}
}
puts "Number of cells upsized $m"
puts "number of cells failed to upsize $n"
