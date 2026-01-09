set search_path {/home/tools/libraries/28nm/lib/stdcell_hvt/db_nldm /home/tools/libraries/28nm/lib/stdcell_lvt/db_nldm /home/tools/libraries/28nm/lib/stdram_lp_new/db_nldm}

set_app_var link_library "* saed32lvt_ff0p95v125c.db saed32rvt_ff0p95v125c.db saed32hvt_ff0p95v125c.db saed32hvt_ulvl_ff1p16v125c_i0p95v.db saed32rvt_ul5c_i0p95v.db saed32hvt_dlvl_ff0p95v125c_i1p16v.db saed32lvt_dlvl_ff0p95v125c_ilp16v.db saed32rvt_dlvl_ff0p95v125c_ilp16v.db saed32sramlp_ff0p95v125c_i0p9"

read_verilog /home/ajayjangam/VG_B5/PRIMETIME/inputs/routed_netlist.v
current_design ORCA_TOP
set link_create_black_boxes false

link_design ORCA_TOP
load_upf /home/ajayjangam/VG_B5/PRIMETIME/inputs/ORCA_TOP.upf
define_scaling_lib_group {saed32lvt_ff0p95v125c.db saed32lvt_ff1p16v125c.db}
define_scaling_lib_group {saed32rvt_ff0p95v125c.db saed32rvt_fflp16v125c.db}
define_scaling_lib_group {saed32hvt_ff0p95v125c.db saed32hvt_ff1p16v125c.db}
define_scaling_lib_group {saed32sramlp_ff0p95v125c_i0p95v.db saed32sramlp_fflp16v125c_ilp16v.db}
set_eco_options -physical_icc2_lib ./ .. /PD/outputs/ORCA_TOP.nlib -physical_icc2_blocks route_opt_u_all

read_parasitics /home/ajayjangam/VG_B5/PRIMETIME/inputs/ORCATOP.cbest.spef -keep_capacitive_coupling
read_sdc /home/ajayjangam/VG_B5/PRIMETIME/inputs/ff_125.sdc
set si_enable_analysis true
set si_xtalk_composite_aggr_mode statistical
check_eco

update_timing -full

save_session ./sessions/func_min.session

