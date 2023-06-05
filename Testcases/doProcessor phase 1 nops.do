vcom Processor.vhd
vsim Processor


# MOST LIKELY CONTAINS PROLBEMS BUT IS MOSTLY SYNCHRONIZED
#-h before signal to make it formatted in hexadecimal
add wave -position insertpoint  \
-h sim:/processor/myFetch/MyinstructionCache/dataout
add wave -position insertpoint  \
-h sim:/processor/IE_IM1_ALU_out_sig \
sim:/processor/IE_IM1_Rdst_sig \
sim:/processor/instruction_FD_sig \

add wave -position insertpoint  \
-h sim:/processor/myDecode/myRegfile/ram


add wave Clk_module Rst_module  -h inPort_module  

add wave -position insertpoint \
sim:/processor/myDecode/myCU/*
add wave -position insertpoint  \
sim:/processor/myExecute/myalu/alu_in_1 \
sim:/processor/myExecute/myalu/alu_in_2 \
sim:/processor/myExecute/myalu/alu_opcode \
sim:/processor/myExecute/myalu/alu_out
add wave -position insertpoint  \
-h sim:/processor/myFetch/MyfetchDecodeReg/instruction_passed
add wave -position insertpoint  \
-h sim:/processor/myFetch/MyfetchDecodeReg/inPort_passed

add wave -position insertpoint sim:/processor/myFetch/MyPC/*
add wave -position insertpoint sim:/processor/myFetch/MyinstructionCache/*



mem load -i {F:/College Stuff/Computer Architecture/Project/InstCache.mem} /processor/myFetch/MyinstructionCache/instructionCache

#
#100 ps
force -freeze sim:/processor/Clk_module 1 0, 0 {50 ps} -r 100   
force Rst_module 1
run
force inPort_module 'hFFFE
force Rst_module 0
# run IN inst
run
#NOPS
run 500 ps


#INC
run 100 ps
#NOPS
run 500 ps
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
run 300 ps
run 1000 ps

run 600 ps
run 600 ps
#for quitting
#quit -sim

#how to restart sim
# restart -f # for restarting simulation

#to make clock
#force clk 0 , 1 {5 ns} -r 10 ns


