# Cadence Genus(TM) Synthesis Solution, Version 18.14-s037_1, built Mar 27 2019 12:19:21

# Date: Wed Jan 27 22:47:21 2021
# Host: alfred.ece.northwestern.edu (x86_64 w/Linux 4.18.0-240.8.1.el8_3.x86_64) (8cores*8cpus*1physical cpu*Intel(R) Core(TM) i7-9700 CPU @ 3.00GHz 12288KB)
# OS:   Red Hat Enterprise Linux release 8.3 (Ootpa)

read_hdl ../and_6.v
read_hdl ../alu_unit.v
read_hdl ../alu_32.v
read_hdl ../CPU.v
set_db library /vol/ece303/genus_tutorial/NangateOpenCellLibrary_typical.lib
set_db lef_library /vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef
elaborate
syn_opt
current_design CPU
syn_opt
report_area
exit
