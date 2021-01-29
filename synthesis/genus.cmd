# Cadence Genus(TM) Synthesis Solution, Version 18.14-s037_1, built Mar 27 2019 12:19:21

# Date: Sun Jan 24 20:05:20 2021
# Host: alfred.ece.northwestern.edu (x86_64 w/Linux 4.18.0-240.8.1.el8_3.x86_64) (8cores*8cpus*1physical cpu*Intel(R) Core(TM) i7-9700 CPU @ 3.00GHz 12288KB)
# OS:   Red Hat Enterprise Linux release 8.3 (Ootpa)

read_hdl ../control.v
set_db library /vol/ece303/genus_tutorial/NangateOpenCellLibrary_typical.lib
set_db lef_library /vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef
elaborate
current_design control
read_sdc /vol/ece303/genus_tutorial/alu_conv.sdc
syn_generic
syn_map
syn_opt
report timing > timing.rpt
report_are > area.rpt
write_hdl > _control_syn.v
quit
