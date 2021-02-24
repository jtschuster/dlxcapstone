
# XM-Sim Command File
# TOOL:	xmsim(64)	18.09-s011
#

set tcl_prompt1 {puts -nonewline "xcelium> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1
set assert_reporting_mode 0
alias . run
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves CPU_tb.scp.ctrl.jumpBranch.immi CPU_tb.scp.ctrl.jumpBranch.instruction CPU_tb.scp.ctrl.jumpBranch.name CPU_tb.scp.ctrl.jumpBranch.newPC CPU_tb.scp.ctrl.jumpBranch.nullRegisterRead CPU_tb.scp.ctrl.jumpBranch.opcode CPU_tb.scp.ctrl.jumpBranch.outputPC CPU_tb.scp.ctrl.jumpBranch.pc_plus_four CPU_tb.scp.ctrl.jumpBranch.register31 CPU_tb.scp.ctrl.jumpBranch.rs CPU_tb.scp.ctrl.jumpBranch.rs1 CPU_tb.scp.ctrl.jumpBranch.rt CPU_tb.scp.ctrl.jumpBranch.signExtendedImmediate CPU_tb.scp.ctrl.jumpBranch.signExtendedName CPU_tb.scp.ctrl.jumpBranch.takeBranch CPU_tb.scp.ctrl.jumpBranch.writeSelect
probe -create -database waves CPU_tb.scp.cpu_rf.r[6]
probe -create -database waves CPU_tb.scp.cpu_ex.Op_ex
probe -create -database waves CPU_tb.scp.cpu_ex.A CPU_tb.scp.cpu_ex.B CPU_tb.scp.cpu_ex.cpu_alu.Op

simvision -input /home/ctm2245/eecs362/dlxcapstone/final_pipeline/final_pipeline/.simvision/3310312_ctm2245_batman.ece.northwestern.edu_autosave.tcl.svcf
