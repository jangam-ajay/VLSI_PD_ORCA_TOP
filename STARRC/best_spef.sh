set p= pwd
mkdir ./outputs/works
mkdir ./outputs/works/cbest
cd ./outputs/works/cbest
#to generate spef file for the corner m40

/home/tools/synopsys/SYNOPSYS_INSTALL/starrc/V-2023.12-SP5-1/bin/StarXtract -clean $p/scripts/cbest_spef.cmd
cd -
