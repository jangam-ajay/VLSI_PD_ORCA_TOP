set p= pwd
#mkdir ./outputs/works/cworst
cd $p/outputs/works/cworst
#to generate spef for the corner 125c
/home/tools/synopsys/SYNOPSYS_INSTALL/starrc/V-2023.12-SP5-1/bin/StarXtract -clean $p/scripts/cworst_spef.cmd
cd -
