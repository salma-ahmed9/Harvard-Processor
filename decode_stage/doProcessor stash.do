########################Stash runs until end of simmmmm#################
vcom Processor.vhd
vsim Processor

#vsim partA
#//////////////////////For B///////////////////////////////
#-h before signal to make it formatted in hexadecimal
add wave -position insertpoint  \
sim:/processor/ControlSignals_DE_sig \
sim:/processor/ControlSignals_EM1_sig \
-h sim:/processor/IE_IM1_ALU_out_sig \
sim:/processor/IE_IM1_CCR_sig \
sim:/processor/IE_IM1_Rdst_sig \
sim:/processor/IE_IM1_Rsrc1_sig \
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
#
#100 ps
force -freeze sim:/processor/Clk_module 1 0, 0 {50 ps} -r 100   
force Rst_module 1
run
force Rst_module 0
run
mem load -i {F:/College Stuff/Computer Architecture/Project/testCases.mem} /processor/myFetch/MyinstructionCache/instructionCache

# run 1 inst
force inPort_module 'hFFFE
run
run
run 600 ps

#NOPS
run 500 ps
#INC
run 100 ps
force inPort_module 'h0001
run 100 ps
force inPort_module 'h000F
run 100 ps
force inPort_module 'h00C8
run 100 ps
force inPort_module 'h001F
run 100 ps
force inPort_module 'h00FC
run 100 ps
#NOP
run 100 ps
#STD
run 100 ps
run 100 ps
run 100 ps
#run 300 ps
#run 1000 ps

#run 600 ps
#run 600 ps
##for quitting
##quit -sim
#
##how to restart sim
## restart -f # for restarting simulation
#
##to make clock
##force clk 0 , 1 {5 ns} -r 10 ns

