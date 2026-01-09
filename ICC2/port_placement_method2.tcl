set fh_read [open "/home/attulsharma/VG_B5/PD/scripts/port_placement. tcl" r]
vhile {[gets $fh_read line] >= 0} {
set port_name [lindex $line 0]
#puts $port_name
set port_loc [lrange $line 1 2]
#puts $port_loc

set_individual_pin_constraints -ports $port_name -location $port_loc -allowed_layers {M5 M6}

remove_pin_guide -all

lace_pins -ports [get_ports]
close $fh_read
