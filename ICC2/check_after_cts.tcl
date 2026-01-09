#pre cts -> clock paths
#cells in clock path
#buffers , INV ,mux , CG , OCC ,REG
#CLOCK PORT -> OCC -> ICG -> REG

#script : to check whether all the reg are connected with ICG ot not ?
#sanity check
#check mv design
#check legality
#timing
#congestion
#design mismatch
#clock trees
#scanchains

#warnings
#dontch touch net ->up level shifter
#in to out ->SD_DDRCLk , SD_DDR_CLKn [feedthrough clocks]
#clcoks are not connect to any sink pins [feedthrough clocks]
#cells no leq[logic equivalence] for resizing [macros]
#eg .... #cts 012
#cts 019
#cts 904
#cts 905

#cts spec file [cts script]
#excluding all library cells for cts
#set a derive_clock_cell_reference
#include cells for cts @a ,NBUFF_LVT , INV_LVT ,DFF_LVT

#NDR rules :
#dpouble spacing , tapper distance

#metal layer : M4 M5

report_min_pulse_width > ./outputs/U_OPT/cts_mpw.txt
report_global_timing >./outputs/U_OPT/cts_timing.txt

report_clock_qor >./outputs/U_OPT/cts_qor.txt
#max_cap
#max_tran

#difference between normal buffer and clock buffer
#Hold violations
report_timing -delay_type min

#useful skew
#to fix the setup voilation
# -- >before useful skew method we need to check setup margin in the next path

report_timing -from [get_cells <endpoint name>] -path_type end -max_paths 10
# --- >Hold margin the in the same path
report_timing -from [get_cells <start_point>] -to [get_cells <end point>] -delay_type min

#To fix the hold violation
# -.. >before fix the hold violation we need to check the hold margin for the
report_timing -to [get_cells <endpoint name>] -path_type end -max_paths 10 -delay_type min

launch ff (before path)

# --- >to see total cells present in clock path
report_timing -path_type full_clock

#insert_buffer
#we need to add the budffer near to the clock pin of the capture flipflop
insert_buffer <capture flipflop ref_name> NBUFFX2_LVT
#If we have more neagative skack we can add delay buffer --- DELLN1X2_LVT
legalize_placement -incremental

report_global_timing
report_timing -from <start_point> -to <end_point>
#useful_skew for hol vio?

#Multicycle path

#slow to fast clock
current_mode func

set_multicycle_path -setup 2 -from [get_clocks SYS_CLK] -to [get_clocks SYS_2x_CLK] -end
set_multicycle_path -hold 1 -from [get_clocks SYS_CLK] -to [get_clocks SYS_2x_CLK] -end
current_mode test
set_multicycle_path -setup 2 -from [get_clocks SYS_CLK] -to [get_clocks SYS_2x_CLK] -end
set_multicycle_path -hold 1 -from [get_clocks SYS_CLK] -to [get_clocks SYS_2x_CLK] -end

#fast to slow clock
current_mode func

set_multicycle_path -setup 2 -from [get_clocks SYS_2x_CLK] -to [get_clocks SYS_CLK] -start
set_multicycle_path -hold 1 -from [get_clocks SYS_2x_CLK] -to [get_clocks SYS_CLK] -start

current_mode test
set_multicycle_path -setup 2 -from [get_clocks SYS_2x_CLK] -to [get_clocks SYS_CLK] -start
set_multicycle_path -hold 1 -from [get_clocks SYS_2x_CLK] -to [get_clocks SYS_CLK] -start
#setup n edge . hold = [n-1] edge
