#INITIALIZING THE FLOORPLAN
WSIDE RATIO METHOD

#R SHAPE
initialize_floorplan -shape R -side_ratio {2 1} -core_offset 5 -use_site_row -site_def unit -core_utilization D.75

#L SHAPE
initialize_floorplan -shape L -side_ratio {2 1 1 2} -core_offset 5 -use_site_row -site_def unit -core_utilization 0.75

#ASSIGNMENT :
#CREATE A T SHAPE CORE AREA WITH SIDE RATIO METHOD.

#USING COORINATES

#R-SHAPE
initialize_floorplan -boundary {{5 5} {700 5} {700 700} {5 700}} -use_site_row -site_def unit -core_offset 5
#L-SHAPE
initialize_floorplan -boundary {{5 5} {1000 5} {1000 500} {500 500} {500 1000} {5 1000}} -core_offset 5

#ASSIGNMENT
initialize_floorplan -boundary {{100 200} {250 200} {250 100} {750 100} {750 500} {1000 500} {1000 600} {750 600} {750 1000} {250 1000} {250 800} {100 800} {100 700} {250 700} {250 400} {1000 5}
#L-SHAPE with ORIENTATION
initialize_floorplan -boundary {{5 5} {5 500} {500 500} {500 880} {880 880} {880 5}} -core_offset 5 -use_site_row -site_def unit
save_block -as L_CORD

#PORT PLACEMENT

#HOW many ports ?

help *ports*

get_ports -> collection of all the ports

sizeof_collection [get_ports]
¥237

sizeof_collection [all_outputs]
#142

#input
all_inputs
#clock ports & input ports
sizeof_collection [remove_from_collection [all_inputs] [get_ports "clk"] ]

clock
sizeof_collection [get_ports *clk* ]

#PORT_PLACEMENT
#INPUT PORTS
set a [get_attribute [get_selection] bbox ]
create_pin_guide -boundary $a -layers M5 -pin_spacing 1 [remove_from_collection [all_inputs] [get_ports *clk*]]
place_pins -ports [remove_from_collection [all_inputs] [get_ports *clk*]]
#CLOCK PORTS
set a [get_attribute [get_selection] bbox]
create_pin_guide -layers M6 -boundary $a -pin_spacing 5 [get_ports *clk*]
place_pins -ports [get_ports *clk*]
#OUTPUT PORTS
set a [get_attribute [get_selection] bbox]
create_pin_guide . layers M5 -pin_spacing 1 -boundary $a [all_outputs]
lace_pins -ports [all_outputs]

#SANITY CHECK
check_pin_placement -wire_track true

remove_placement_blockages -all -force

#SANITY CHECK AFTER VOLTAGE AREA CREATION
check_mv_design

derive_placement_blockages
#Create soft blockages

#Keepout margin - to avoid congestion near the macro pins
create_keepout_margin -outer {1 1 1 1} [get_flat_cells -filter "is_hard_macro"]
#FIX THE MACRO
set_fixed_objects [get_flat_cells -filter "is_hard_macro"]
#PHYSICAL ONLY CELLS

remove_cells [get_flat_cells -all *tapfiller*]
remove_cells [get_flat_cells -all "boundary"]

#BOUNDARY CELLS
set_boundary_cell_rules -right_boundary_cell DCAP_HVT -left_boundary_cell DCAP_HVT -at_va_boundary
compile_boundary_cells

#Sanity check
check_boundary_cells

#TAP CELLS
create_tap_cells -lib_cell DCAP_HVT -distance 30 -pattern stagger -skip_fixed_cells

#Sanity check
check_legality

#HARD BLOCKAGE : No cells are added
#Partial : blockage percentage - 80% , 20 % of the area cells are placed
#Soft blockage : allow only buffers , invertors

#ASSIGNMENT
#IF WE CREATE PARTIAL BLOCKAGE WITH 100% BLOCKAGE PERCENTAGE , so it will be hard blockage then what is the use of hard blockage.

set_fixed_objects [get_flat_cells -filter "is_hard_macro"] -unfix
#MACRO PLACEMENT USING TOOL

#APP_OPTIONS
#PLACE ONLY THE MACRO'S NOT THE STANDARD CELLS
set_app_options -name plan.macro.macro_place_only -value true

#PLACE MACRO'S OF SAME HEIRARCHY TOGETHER
set_app_options -name plan.macro.grouping_by_hierarchy -value true

#GIVE CHANNEL SPACE IN TOP AND BOTTOM/HORIZONTAL SPACING - 10um
set_app_options -name plan.macro.spacing_rule_heights -value {5um 5um}

WGIVE CHANNEL SPACE IN RIGHT AND LEFT/VERTICAL SPACING - 10um
set_app_options -name plan.macro.spacing_rule_widths -value {5um 5um}

create_placement -floorplan

#CHECK THE CONGESTIONS
report_congestion -rerun_global_router > FLOORPLAN_cong.rpt

#CONGESTION should be less than 0.5%
#POWERPLAN

source ./scripts/powerfinal.tcl
check_pg_connectivity -check_std_cell pins none
check_pg_missing_vias
check_pg_drc -do_not_check_shapes_in_hier_blocks

set_fixed_objects [get_flat_cells -filter "is_hard_macro"] -unfix

WPLACE PHYSICAL ONLY CELLS

#CHECK FOR CONGESTION

report_congestion -rerun_global_router > POWERPLAN_cong.rpt
