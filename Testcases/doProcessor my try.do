vcom Processor.vhd
vsim Processor

#-h before signal to make it formatted in hexadecimal
add wave -position insertpoint  \
-h sim:/processor/myFetch/MyinstructionCache/dataout
add wave -position insertpoint  \
sim:/processor/ControlSignals_DE_sig \
sim:/processor/ControlSignals_EM1_sig \
-h sim:/processor/IE_IM1_ALU_out_sig \
sim:/processor/IE_IM1_CCR_sig \
sim:/processor/IE_IM1_Rdst_sig \
sim:/processor/IM2_WB_Rdst_DE_sig \
sim:/processor/IM2_WB_Regwrite_DE_sig \
sim:/processor/IM2_WB_writeData_DE_sig \
sim:/processor/immediate_DE_sig \
sim:/processor/instruction_FD_sig \
sim:/processor/Rdst_DE_sig \
sim:/processor/Rs_DE_sig \
sim:/processor/Rt_DE_sig
add wave -position insertpoint  \
-h sim:/processor/myDecode/myRegfile/ram

add wave Clk_module Rst_module -h inPort_module  ControlSignals_DE_sig

add wave -position insertpoint sim:/processor/myDecode/myCU/*
mem load -i {F:/College Stuff/Computer Architecture/Project/InstCache.mem} /processor/myFetch/MyinstructionCache/instructionCache

#
#100 ps
force -freeze sim:/processor/Clk_module 1 0, 0 {50 ps} -r 100   
force -freeze sim:/processor/Rst_module 1 0
run
force -freeze sim:/processor/Rst_module 0 0
run

# run 1 inst
force inPort_module 'hFFFE
run
# run 1 inst
force inPort_module 'hFFFF
run
run 600 ps


##for quitting
##quit -sim
#
##how to restart sim
## restart -f # for restarting simulation
#
##to make clock
##force clk 0 , 1 {5 ns} -r 10 ns

