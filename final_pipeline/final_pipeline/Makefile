SHELL := /bin/tcsh
LEF_LIB = /vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef
LIB = /vol/ece303/genus_tutorial/NangateOpenCellLibrary_typical.lib
SDC = /vol/ece303/genus_tutorial/alu_conv.sdc
SYNTH_FOLDER = lib/synthesis

 # These are just all the files written by us / the 361 group
OUR_FILES = ./lib/EX_stage.v ./lib/ALUctrl.v ./lib/Extender.v  ./lib/alu_msb.v ./lib/forwarding_ex.v ./lib/srl.v ./lib/alu_unit.v ./lib/and_6.v ./lib/ifecth.v ./lib/Control_signal.v ./lib/IF_stage.v ./lib/PC.v ./lib/WB_stage.v ./lib/readReg.v ./lib/write32.v ./lib/Mem_stage.v ./lib/RegisterFiles.v ./lib/writeReg.v ./lib/sll.v ./lib/slt_sltu.v ./lib/CPU.v ./lib/control.v ./lib/JumpBranch.v ./lib/alu_behavioral.v #./lib/alu_32.v # ./lib/ID_stage.v ./lib/full_alu.v 
# I thought these wouldn't synthesize, so I separated them. These actually do, but I thought we might still want the separate
PROVIDED_FILES = ./lib/mux_n.v ./lib/nor_gate.v ./lib/not_gate_n.v ./lib/not_gate.v ./lib/and_gate.v ./lib/or_gate_32.v ./lib/or_gate.v ./lib/dec_n.v ./lib/dffr.v ./lib/xnor_gate.v ./lib/dff.v ./lib/mux_32.v ./lib/xor_gate.v ./lib/mux.v

# Genus doesn't seem to like synthesizing these, so I think we just add them in when we simulate?
RAM_FILES = ./lib/syncram.v ./lib/sram.v
DUMMY_RAM_FILES = ./lib/sram_dummy.v

# need to supply TB and UNIT args
sim:
	source /vol/ece303/genus_tutorial/cadence.env && \
	xrun -64bit -gui -access r -xmelab_args "-warnmax 0 -delay_mode zero -maxdelays" $(PROVIDED_FILES) $(OUR_FILES) $(RAM_FILES) ./test/CPU_tb.v 
sim_dummy:
	source /vol/ece303/genus_tutorial/cadence.env && \
	xrun -64bit -gui -access r -xmelab_args "-warnmax 0 -delay_mode zero -maxdelays" $(PROVIDED_FILES) $(OUR_FILES) $(DUMMY_RAM_FILES) ./test/CPU_tb.v
ifetch:
	source /vol/ece303/genus_tutorial/cadence.env && \
	xrun -64bit -gui -access r -xmelab_args "-warnmax 0 -delay_mode zero -maxdelays" $(PROVIDED_FILES) ./test/sram_tb.v ./lib/ifecth.v $(RAM_FILES)

regfile:
	source /vol/ece303/genus_tutorial/cadence.env && \
	xrun -64bit -gui -access r -xmelab_args "-warnmax 0 -delay_mode zero -maxdelays" ./lib/RegisterFiles.v ./lib/readReg.v ./lib/writeReg.v ./test/RegisterFiles_tb.v 

all:
	source /vol/ece303/genus_tutorial/cadence.env && \
	echo "read_hdl  $(PROVIDED_FILES) $(OUR_FILES) $(RAM_FILES) \
	set_db library $(LIB) \
	set_db lef_library $(LEF_LIB) \
	set_db hdl_max_loop_limit 8192 \
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
	echo '`timescale 1ns/10ps\n' > timescale.txt && \
	cat timescale.txt _CPU_syn.v > CPU_syn.v;

pc:	
	source /vol/ece303/genus_tutorial/cadence.env && \
	xrun -64bit -gui -access r -xmelab_args "-warnmax 0 -delay_mode zero -maxdelays" ./lib/PC.v ./test/PC_tb.v ./lib/dff.v

alu:
	source /vol/ece303/genus_tutorial/cadence.env && \
	xrun -64bit -gui -access r -xmelab_args "-warnmax 0 -delay_mode zero -maxdelays" ./lib/alu_behavioral.v ./test/ALU_32bit_tb.v 

