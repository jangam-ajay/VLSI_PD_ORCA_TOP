#SANITY CHECKS

check_design -checks pre_route_stage

check_routability >./outputs/routing_check.txt
#for u shape

#OFF TRACK PINS
#REDUNDANT PG SHAPES
#DIFFERENT PIN OVEWRLAPS PIN

#ROUTING STAGE:
#->GLOBAL ROUTING
#->TRACK ASSIGNMENT
#->DETAILED ROUTING
#->SEARCH AND REPAIR

#Remove global routing
remove_routes -global_route

#Check congession before routing
report_congestion -rerun_global_router


#APP OPTIONS
#report_app_options +timing+driven*

#timing driven
set_app_options -name route.global.timing_driven -value true
set_app_options -name route. track. timing_driven -value true
set_app_options -name route.detail.timing_driven -value true

#report_app_options *crosstalk*driven*

#xtalk driven
set_app_options -name route.global.crosstalk_driven -value true
set_app_options -name route. track.crosstalk_driven -value true

set_app_options -name time.si_enable_analysis -value true
set_app_options -name time.si_xtalk_composite_aggr_mode -value statistical
set_app_options -name time.all_clocks_propagated -value true

set_app_options -name opt.common. user_instance_name_prefix -value route_opt
set_dont_touch_network -clock_only [get_ports *clk*]
#read antenna rule
source /home/vlsiguru/PHYSICAL_DESIGN/TRAINER1/ICC2/ORCA_TOP/ref/tech/saed32nm_ant_1p9m.tcl

#route_auto -save_after_global_route true -save_after_track_assignment true -save_after_detail_route true
route_global
save_block -as global_u_route
Coute_track
save_block -as track_u_route
route_detail

save_block -as detail_u_route
open_block detail_u_route
route_opt

save_block -as route_opt_u_all
