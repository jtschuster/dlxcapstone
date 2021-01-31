tclmode

# Generated by Genus(TM) Synthesis Solution 18.14-s037_1, revision 1.311a
# Generated on: Sat Jan 30 21:16:55 CST 2021 (Sun Jan 31 03:16:55 GMT 2021)

set lec_version [regsub {(-)[A-Za-z]} $env(LEC_VERSION) ""]

tcl_set_command_name_echo on

set_log_file fv/nor_gate/rtl_to_fv_map.log -replace

usage -auto -elapse

set_verification_information rtl_fv_map_db

read_implementation_information fv/nor_gate -revised fv_map

# Root attribute 'wlec_multithread_license_list' can be used to specify a license list
# for multithreaded processing. The default list is used otherwise.
set_parallel_option -threads 4 -norelease_license
set_compare_options -threads 4

set env(RC_VERSION)     "18.14-s037_1"
set env(CDN_SYNTH_ROOT) "/vol/cadence2018/GENUS181/tools.lnx86"
set CDN_SYNTH_ROOT      "/vol/cadence2018/GENUS181/tools.lnx86"
set env(CW_DIR) "/vol/cadence2018/GENUS181/tools.lnx86/lib/chipware"
set CW_DIR      "/vol/cadence2018/GENUS181/tools.lnx86/lib/chipware"

# default is to error out when module definitions are missing
set_undefined_cell black_box -noascend -both

add_search_path . /vol/cadence2018/GENUS181/tools.lnx86/lib/tech -library -both
read_library -liberty -both   /vol/ece303/genus_tutorial/NangateOpenCellLibrary_typical.lib

set_undriven_signal 0 -golden
set_naming_style rc -golden
set_naming_rule "%s\[%d\]" -instance_array -golden
set_naming_rule "%s_reg" -register -golden
set_naming_rule "%L.%s" "%L\[%d\].%s" "%s" -instance -golden
set_naming_rule "%L.%s" "%L\[%d\].%s" "%s" -variable -golden

# Align LEC's treatment of mismatched port widths with constant
# connections with Genus's. Genus message CDFG-467 and LEC message
# HRC3.6 may indicate the presence of this issue. This option is
# only available with LEC 17.20-d301 or later.
set lec_version_required "17.20301"
if {$lec_version >= $lec_version_required} {
    set_hdl_options -const_port_extend
}
set_hdl_options -VERILOG_INCLUDE_DIR "incdir:sep:src:cwd"

add_search_path . -design -golden
read_design   -define SYNTHESIS  -merge bbox -golden -lastmod -noelab -verilog2k ../nor_gate.v
elaborate_design -golden -root {nor_gate} -rootonly 

read_design -verilog95   -revised -lastmod -noelab fv/nor_gate/fv_map.v.gz
elaborate_design -revised -root {nor_gate}

uniquify -all -nolib -golden

report_design_data
report_black_box

set_flatten_model -seq_constant
set_flatten_model -seq_constant_x_to 0
set_flatten_model -nodff_to_dlat_zero
set_flatten_model -nodff_to_dlat_feedback
set_flatten_model -hier_seq_merge

set_analyze_option -auto

write_hier_compare_dofile hier_tmp1.lec.do -noexact_pin_match -constraint -usage -replace -balanced_extraction -input_output_pin_equivalence -prepend_string " report_unmapped_points -notmapped; analyze_datapath -module -verbose ; analyze_datapath   -verbose; "
run_hier_compare hier_tmp1.lec.do -dynamic_hierarchy

report_verification -hier -verbose
set_system_mode lec
puts "No of diff points    = [get_compare_points -NONequivalent -count]"
if {[get_compare_points -NONequivalent -count] > 0} {
    puts "------------------------------------"
    puts "ERROR: Different Key Points detected"
    puts "------------------------------------"
}

write_verification_information
report_verification_information

exit

