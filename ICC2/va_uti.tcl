#UTILISATION = (MACRO+STD CELL AREA BELONGING TO I_RISCO/TOTAL VOLTAGE AREA

#uti = 0.75
#total cell area belonging to I_RISC_CORE
set ar [get_attribute [get_flat_cells *I_RISC*] area]
set sum 0
foreach i $ar {
set sum [expr {$sum+$i}]
}
puts "Total cell area:$sum"
set uti 0.75
set vol_area [expr $sum/$uti]
puts "Total voltage area for utilisation $uti is $vol_area"

set h1 172
set wl [expr $vol_area/$h1]
#puts "width=$w, height=$h"
set h [expr {ceil ($h1/1.672)} * 1.672]
puts "height=$h"
set w [expr {ceil ($w1/0.152)} * 0.152]
puts "width=$w"

set llx 10.016
set lly 10.016
set urx [expr $w+5+5.016]
set ury [expr $h+5+1.672+5.016]
set b [list [list $llx $lly] [list $urx $ury]]

remove_voltage_areas -all
create_voltage_area -region $b -power_domains PD_RISC_CORE -guard_band {{5.016 5.016}}
