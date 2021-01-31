SHELL := /bin/tcsh
LEF_LIB = /vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef
LIB = /vol/ece303/genus_tutorial/NangateOpenCellLibrary_typical.lib
SDC = /vol/ece303/genus_tutorial/alu_conv.sdc
SYNTH_FOLDER = synthesis
OUR_FILES = ../alu_32.v ../EX_stage.v ../ALUctrl.v ../Extender.v  ../alu_msb.v ../forwarding_ex.v ../srl.v ../alu_unit.v ../full_alu.v ../and_6.v ../ID_stage.v ../ifecth.v ../Control_signal.v ../CPU.v ../IF_stage.v ../PC.v ../WB_stage.v ../readReg.v ../write32.v ../Mem_stage.v ../RegisterFiles.v ../writeReg.v ../sll.v ../slt_sltu.v 

PROVIDED_FILES = ../mux_n.v ../nor_gate.v ../not_gate_n.v ../not_gate.v ../and_gate.v ../or_gate_32.v ../or_gate.v ../dec_n.v ../dffr.v ../xnor_gate.v ../dff.v ../mux_32.v ../xor_gate.v ../mux.v
RAM_FILES = ../syncram.v ../sram.v

all:
	source /vol/ece303/genus_tutorial/cadence.env && \
	cd $(SYNTH_FOLDER) && \
	echo "read_hdl  $(PROVIDED_FILES) $(RAM_FILES) $(OUR_FILES) \
	set_db library $(LIB) \
	set_db lef_library $(LEF_LIB) \
	elaborate \
	current_design CPU \
	read_sdc $(SDC) \
	syn_generic \
	syn_map \
	syn_opt \
	report timing > timing.rpt \
	report_area > area.rpt \
	write_hdl > _CPU_syn.v \
	quit" | genus;
	cd $(SYNTH_FOLDER) && \
	echo '`timescale 1ns/10ps\n' > timescale.txt && \
	cat timescale.txt _CPU_syn.v > CPU_syn.v;

#all:
#	source /vol/ece303/genus_tutorial/cadence.env && \
#	cd $(SYNTH_FOLDER) && \
#	echo "read_hdl $(OUR_FILES) \
#	set_db library $(LIB) \
#	set_db lef_library $(LEF_LIB) \
#	elaborate \
#	current_design CPU \
#	read_sdc $(SDC) \
#	syn_generic \
#	syn_map \
#	syn_opt \
#	report timing > timing.rpt \
#	report_are > area.rpt \
#	write_hdl > $(@)_syn.v \
#	quit" | genus;
#	cd $(SYNTH_FOLDER);
#	cd synthesis && echo '`timescale 1ns/10ps\n' `cat $(@)_syn.v` > $(@)_syn.v;

# For synthesizing individual files
%: %.v
	source /vol/ece303/genus_tutorial/cadence.env && \
	cd $(SYNTH_FOLDER) && \
	echo "read_hdl $(PROVIDED_FILES) $(OUR_FILES) \
	set_db library $(LIB) \
	set_db lef_library $(LEF_LIB) \
	elaborate \
	current_design $(@) \
	read_sdc $(SDC) \
	syn_generic \
	syn_map \
	syn_opt \
	report timing > timing.rpt \
	report_area > area.rpt \
	write_hdl > $(@)_syn.v \
	quit" | genus;
#	cd $(SYNTH_FOLDER) && \
#	echo '`timescale 1ns/10ps\n' > timescale.txt && \
#	cat timescale.txt $(@)_syn.v > $(@)_syn.v;


