#check_clock_trees

#

#

################# cts spec file #############################

# already existing cells in clk path
# cells to be added // why ?
# to balance the skew

#derive_clock_cell_reference

# alternate cells for the cells already existing in cts path
# go to scripts folder and do copy
#cp /home//PD/scripts/cts_include_refs.tcl .
# edit the file to have LVT/RVT cells

set_lib_cell_purpose -exclude cts [get_lib_cells]
source ./scripts/cts_include_refs.tcl
set_lib_cell_purpose -include cts [get_lib_cells "*/NBUFF*LVT */NBUFF+RVT */INVX+_LVT */INVX+_RVT */*DFF+"]
## NDR :- double width and double spacing
remove_routing_rules -all
create_routing_rule iccrm_clock_double_spacing -default_reference_rule -multiplier_spacing 2 -taper_distance 0.4 -driver_taper_distance 0.4
set_clock_routing_rules -net_type sink -rules iccrm_clock_double_spacing -min_routing_layer M4 -max_routing_layer M5

#cts constraints

#max transition
current_mode func
set_max_transition 0.15 -clock_path [get_clocks] -corners [all_corners]
# target skew
set_clock_tree_options -target_skew 0.05 -corners [get_corners ss_125c]
set_clock_tree_options -target_skew 0.05 -corners [get_corners ss_m40c]
set_clock_tree_options -target_skew 0.02 -corners [get_corners ff_m40c]
set_clock_tree_options -target_skew 0.02 -corners [get_corners ff_125c]
#target latency

#uncertainity
foreach_in_collection scen [all_scenarios] {
current_scenario $scen
set_clock_uncertainty 0.1 -setup [all_clocks]
set_clock_uncertainty 0.05 -hold [all_clocks]

# enable CRPR
#man time. remove_clock_reconvergence_pessimism #

set_app_options -name time. remove_clock_reconvergence_pessimism -value true

CTS exceptions
# man set_clock balance points
# Set select mux select lines as balancing points
foreach_in_collection mode [all_modes] {
current_mode $mode
set_clock_balance_points \
-consider_for_balancing true \
-balance_points [get_pins "I_SDRAM_TOP/I_SDRAM_IF/sd_mux_+/S0"]

# Set dont constraints
set_dont_touch [get_cells "I_SDRAM_TOP/I_SDRAM_IF/sd_mux _* "]
report_dont_touch I_SDRAM_TOP/I_SDRAM_IF/sd_mux _*

set_dont_touch [get_cells "I_CLOCKING/sys_clk_in_reg"]
report_dont_touch I_CLOCKING/sys_clk_in_reg

# set cells to fix hold
set_lib_cell purpose -exclude hold [get_lib_cells]
set_lib_cell_purpose -include hold [get_lib_cells "*/DELLN *_ HVT +/NBUFFX2_HVT */NBUFFX4_HVT +/NBUFFX8_HVT"]
# Give prefix to cells added in cts path
set_app_option -name cts. common. user_instance_name_prefix -value clock_opt_clock_
# Give prefix to cells added in data path
set_app_option -name opt. common.user_instance_name_prefix -value clock_opt_opt
####Build CTS

# Remove route global
remove_routes -global_route

# run clock opt
clock_opt -to build_clock
#global routing intiation
save_block -as build_clock_u_done

clock_opt -to route_clock
#routing with real metal layers
save_block -as cts_u_done

# open the block
open_block cts_u_done
# report_global_timing
#set_app_options -name clock_opt.hold.effort -value high
set_app_options -name ccd.hold_control_effort -value high
set_app_options -name opt.dft.clock_aware_scan_reorder -value true
#set_multisource_clock_subtree_options -clock [get_clocks SDRAM_CLK] -driver_objects [get_flat_cells -filter "ref_name =~ NBUFFX2_LVT"]
clock_opt -from final_opto
save_block -as clock_opt_u_all
