#coordinates of the blockage
set a [get_attribute [get_selection ] bbox]

#adding 5.016 to all the sides of blockage
set new_llx [expr ([lindex $a 0 0 ] + 5.016) ]
set new_lly [expr ([lindex $a 0 1 ] + 5.016) ]
set new_urx [expr ([lindex $a 1 0 ] + 5.016)]
set new_ury [expr ([lindex $a 1 1 ] + 5.016) ]

#saving the new coordinates in a list
set b [list [list $new_llx $new_lly] [list $new_urx $new_ury]]

remove_voltage_areas -all

#creating the voltage area with new coordinates
create_voltage_area -region $b -power_domains PD_RISC_CORE -guard_band {{5.016 5.016}}

#In terminal - source the script
#source ./scripts/va_bounds.tcl
#save_block
