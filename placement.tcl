#PLACEMENT

set_app_options -name place.coarse.continue_on_missing_scandef -value true

#Loading the scandef file
read_def ./inputs/ORCA_TOP.scandef

set search_path {./inputs/sdc_constraints/}
source ./inputs/sdc_constraints/mcmm_ORCA_TOP.tcl

save_block -as placement_r1

#scanchain count
get_scan_chain_count

######TIE cells -default true
#To give constant logic 1 or logic 0
#Without tie cells , antenna violations will be occured
set_attribute [get_lib_cells *TIE*] dont_touch false
set_attribute [get_lib_cells *TIE*] dont_use false

set_app_options -name place. legalize.enable_advanced_legalizer -value true
set_app_options -name place. legalize. legalizer_search_and_repair -value true
#To make g cells area utilization is 0.75
#g cell - Collection of 3 tie cells
set_app_options -name place.coarse.max_density -value 0.75

##report_app_options *place*density*
#man place.coarse.max_density

set_ideal_network [all_fanout -clock_tree ]
#report_cloks
report_clocks
#default max_fanout -- 40
#reduced to ---- 25
set_app_options -name opt. common. max_fanout -value 25
set_ignored_layers -max_routing_layer M6 -min_routing_layer M2
set_app_options -name route.common.net_max_layer_mode -value hard
set_app_options -name route.common.net_min_layer_mode -value allow_pin_connection
save_block
create_placement
legalize_placement
report_congestion -rerun_global_router

######

##### Fixes for congestion #####
# ---- app_option - max_density 0.75
#cell padding
# ----- keepout_margin (right and left of std cells)
#Blockages
#Keepout_margin -- macros
#congestion driven placement
--- create_placement -congestion -congestion_effort high
#####Change the macro placement

#### Timing driven placement
-...-- create_placement -timing_driven -effort high

###

create_placement

legalize_placement
save_block -as create_placement

###

reset_placement

create_placement -congestion -congestion_effort high
legalize_placement
save_block -as cogestion_driven_placement

reset_placement

create_placement -timing_driven -effort high
legalize_placement
save_block -as timing_driven_placement

###

reset_placement

create_placement -congestion -congestion_effort high -timing_driven -effort high
legalize_placement

save_block -as both_placement

###

route_global

#MAX TRANS
report_constraints -max_transition -all_violators -significant_digits 3 -scenarios * -nosplit > ./outputs/mtv_bpo.txt
#MAX CAPACITANCE
report_constraints -max_capacitance -all_violators -significant_digits 3 -scenarios + -nosplit > ./outputs/mcv_bpo.txt

##Date
## *****

report_global_timing

check_legality

#Buffer count before intial-drc
sizeof_collection [get_flat_cells -filter "ref_name =-* NBUF*"]
#3017
sizeof_collection [get_flat_cells -filter "ref_name =- +INV*"]
#3342

#########PLACE OPT

place_opt -from initial_drc -to initial_drc
#buff count :
#inv count:
#max trans vio :
#max cap vio :
#timing vio :
#check legality :
place_opt -from initial_opto -to initial_opto
#buff count :
#inv count:
#max trans vio :
#max cap vio :
#timing vio :
#check legality :
place_opt -from final_place -to final_place
#buff count :
#inv count:
#max trans vio :
#max cap vio :
#timing vio :
#check legality :
place_opt -from final_opto -to final_opto
#buff count :
#inv count:
#max trans vio :
#max cap vio :
#timing vio :
#check legality :

save_block -as place_opt_done

create_utilization_configuration pl

report_utilization -config pl
##*
##Report : report_utilization
##Design : ORCA TOP
##Version: V-2023.12-SP5-1
#date : Wed Oct 29 11:13:57 2025

##Utilization Ratio: 0.7907
##Utilization options:
## - Area calculation based on:core area of block create_placement
## - Categories of objects excluded:none
##Total Area: 584468.9347


open_block place_opt_done

route_global
report_constraints -max_transition -all_violators -significant_digits 3 -nosplit -scenarios +
#select any net name from report cionstarints
#to select that net from terminal give this command
#use windows+tab
#give cntrl+t in gui to see selected net
change_selection [get_nets I_BLENDER_1/sl_op2[12]]
#click on schematic view of selected object ----- >(and gate symbol)
#click on one of the load from schmatic view
#Then click on lines beside layout and cntrl+t
sizeof_collection [get_flat_cells -all]
#59518

route_global

#worst case

open_block U_place_opt_done
report_constraints -max_transition -all_violators -significant_digits 3 -nosplit -scenarios +
report_constraints -max_transition -all_violators -significant_digits 3 -nosplit -scenarios func.ss_125c > ./outputs/U_OPT/mtv_apo.txt
source ./scripts/upsize_driver_1.tcl
report_constraints -max_transition -all_violators -significant_digits 3 -nosplit -scenarios func.ss_125c > ./outputs/U_OPT/mtv_apo.txt

source ./scripts/insert_buffer.tcl
legalize_placement -incremental
report_constraints -max_transition -all_violators -significant_digits 3 -nosplit -scenarios func.ss_125c > ./outputs/U_OPT/mcv_apo.txt
source ./scripts/upsize_driver_l.tcl

report_constraints -max_transition -all_violators -significant_digits 3 -nosplit -scenarios func.ss_125c > ./outputs/U_OPT/mcv_apo.txt
source ./scripts/insert_buffer.tcl

legalize_placement -incremental
report_constraints -max_transition -all_violators -significant_digits 3 -nosplit -scenarios func.ss_125c *
#Observe the max_tran and max_cap violations
sve_block

#SPLIT FANOUT

split_fanout -net <net name> -cell name -lib_cell NBUFFX2_LVT -max_fanout 2

#MAGNET PLACEMENT

magnet_placement [get_ports pad_out[27]] -logical_levels 2

#BOUNDS - soft, hard , exclusive
#SOFT - no guarantee of all std cells
#HARD - guarantee of all std cells , it will alow other std cells
#EXCLUSIVE - guarantee of all std cells , it will not allow another std cells

change_selection [get_flat_cells *SDRAM+]
#open Gui + create + Bound + create bound near to the macro
#reset placement
#create_placement
#legalize_placement
#observe for different type of bounds

open_block U_place_opt_done

#Total setup and hold violation info
report_global_timing

#Total setup violation info for each
report_timing

#To observe timing path between start point ot end point
get_timing_paths -from I_PCI_TOP/I_PCI_CORE/d_out_i_bus_reg[0] -to I_PCI_TOP/I_PCI_READ_FIFO/PCI_FIFO_CTL/U1/full_int_reg
#To observe in gui
change_selection [get_timing_paths -from I_PCI_TOP/I_PCI_CORE/d_out_i_bus_reg[0] -to I_PCI_TOP/I_PCI_READ_FIFO/PCI_FIFO_CTL/Ul/full_int_reg]
#To view certain no.of setup violations
report_timing -max_paths 10 > ./outputs/U_OPT/sv.txt

#Bottle neck cells
#The cells which are connected in the most number violating paths
