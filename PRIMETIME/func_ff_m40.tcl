set search_path {/home/tools/libraries/28nm/lib/stdcell_hvt/db_nldm /home/tools/libraries/28nm/lib/stdcell_lvt/db_nldm /home/tools/libraries/28nm/lib/stdram_lp_new/db_nldm}

set_app_var link_library "* saed32lvt_ff0p95vn40c.db saed32rvt_ff0p95vn40c.db saed32hvt_ff0p95vn40c.db saed32hvt_ulvl_fflp16vn40c_i0p95v.db saed32rvt_ulc_i0p95v.db saed32hvt_dlvl_ff0p95vn40c_ilp16v.db saed32lvt_dlvl_ff0p95vn40c_ilp16v.db saed32rvt_dlvl_ff0p95vn40c_i1p16v. db saed32sramlp_ff0p95vn40c_i0p9"
read_verilog /home/attulsharma/PD_ADV_MAY25/ORCA_TOP/PRIME_TIME/inputs/routed_netlist.v
current_design ORCA_TOP
set link_create_black_boxes false
link_design ORCA_TOP

load_upf /home/attulsharma/PD_ADV_MAY25/ORCA_TOP/PRIME_TIME/inputs/ORCA_TOP.upf
define_scaling_lib_group {saed32lvt_ff0p95vn40c.db saed32lvt_fflp16vn40c.db}
define_scaling_lib_group {saed32rvt_ff0p95vn40c.db saed32rvt_ff1p16vn40c.db}
define_scaling_lib_group {saed32hvt_ff0p95vn40c.db saed32hvt_fflp16vn40c.db}
define_scaling_lib_group {saed32sramlp_ff0p95vn40c_i0p95v.db saed32sramlp_fflp16vn40c_ilp16v.db}
set_eco_options -physical_icc2_lib ./ .. /PD/outputs/ORCA_TOP.nlib -physical_icc2_blocks route_opt_done

read_parasitics /home/attulsharma/PD_ADV_MAY25/ORCA_TOP/PRIME_TIME/inputs/ORCATOP.cbest.spef -keep_capacitive_coupling
read_sdc /home/attulsharma/PD_ADV_MAY25/ORCA_TOP/PRIME_TIME/inputs/ff_n40c.sdc
set si_enable_analysis true
set si_xtalk_composite_aggr_mode statistical
check_eco

update_timing -full
save_session ./sessions/func_min. session
