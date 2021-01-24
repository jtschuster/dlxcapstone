SHELL := /bin/tcsh
LEF_LIB = /vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef
LIB = /vol/ece303/genus_tutorial/NangateOpenCellLibrary_typical.lib
SDC = /vol/ece303/genus_tutorial/alu_conv.sdc
SYNTH_FOLDER = synthesis


%: %.v
	source /vol/ece303/genus_tutorial/cadence.env && \
	cd $(SYNTH_FOLDER) && \
	echo "read_hdl ../$(@).v \
	set_db library $(LIB) \
	set_db lef_library $(LEF_LIB) \
	elaborate \
	current_design $(@) \
	read_sdc $(SDC) \
	syn_generic \
	syn_map \
	syn_opt \
	report timing > timing.rpt \
	report_are > area.rpt \
	write_hdl > _$(@)_syn.v \
	quit" | genus;
	cd $(SYNTH_FOLDER) && \
	echo '`timescale 1ns/10ps\n' `cat _$(@)_syn.v` > $(@)_syn.v;


asdf: %.v
	source /vol/ece303/genus_tutorial/cadence.env;
	xrun -64bit -gui -access r $(@).v
