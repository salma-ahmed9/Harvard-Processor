vsim work.decode_stage
# vsim work.decode_stage 
# Start time: 08:54:29 on Apr 20,2023
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.decode_stage(myarch)
# Loading work.registerfile(sync_ram_a)
# Loading work.controlunit(arch)
# Loading work.decode_execute_buffer(d_e_buffer)
add wave -position insertpoint  \
sim:/decode_stage/Clk_module
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: DELL  Hostname: DESKTOP-KVLS732  ProcessID: 16188
#           Attempting to use alternate WLF file "./wlftb0bhrx".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlftb0bhrx
add wave -position insertpoint  \
sim:/decode_stage/inPort_module
add wave -position insertpoint  \
sim:/decode_stage/Rst_module
add wave -position insertpoint  \
sim:/decode_stage/instruction_Module
add wave -position insertpoint  \
sim:/decode_stage/controlSignalsOut_sig
add wave -position insertpoint  \
sim:/decode_stage/Rdst_outModule

force -freeze sim:/decode_stage/Clk_module 1 0, 0 {50 ps} -r 100
force -freeze sim:/decode_stage/Rst_module 1 0
run 
force -freeze sim:/decode_stage/Rst_module 0 0
run 
force -freeze sim:/decode_stage/instruction_Module 10110101000000000000000000000000
run 
run 

