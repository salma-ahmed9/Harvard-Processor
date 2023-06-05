vcom Processor.vhd
vsim Processor

#-h before signal to make it formatted in hexadecimal
add wave -position insertpoint  \
-h sim:/processor/myFetch/MyinstructionCache/dataout
add wave -position insertpoint  \
sim:/processor/myMemory/OPcode_module
add wave -position insertpoint  \
-h sim:/processor/IE_IM1_ALU_out_sig \
sim:/processor/IE_IM1_Rdst_sig \

add wave -position insertpoint  \
-h sim:/processor/myDecode/myRegfile/ram


add wave Clk_module Rst_module  -h inPort_module  

add wave -position insertpoint \
sim:/processor/myDecode/myCU/*

add wave -position insertpoint  \
-h sim:/processor/myFetch/MyfetchDecodeReg/instruction_passed

add wave -position insertpoint  \
sim:/processor/myExecute/IE_IM1_ALU_out_sig


add wave -position insertpoint  \
sim:/processor/myExecute/IE_IM1_Rdst_sig
add wave -position insertpoint  \
sim:/processor/myExecute/WB_RD
add wave -position insertpoint  \
sim:/processor/myExecute/M1M2_RD
add wave -position insertpoint  \
sim:/processor/myExecute/M1M2_regwrite
add wave -position insertpoint  \
sim:/processor/myExecute/WB_regwrite
add wave -position insertpoint  \
sim:/processor/myExecute/mux_fu1_out
add wave -position insertpoint  \
sim:/processor/myExecute/Rdst_module
add wave -position insertpoint sim:/processor/myFetch/MyPC/*
add wave -position insertpoint  \
sim:/processor/myMemory/BranchResult_sig
add wave -position insertpoint  \
sim:/processor/myMemory/Branchuncond_sig
add wave -position insertpoint  \
sim:/processor/myMemory/branchZ_sig
add wave -position insertpoint  \
sim:/processor/myMemory/branchC_sig 
add wave -position insertpoint  \
sim:/processor/myMemory/myMem2Stage/myBranchUnit/Opcode

add wave -position insertpoint  \
sim:/processor/outPort_module

add wave -position insertpoint  \
sim:/processor/myExecute/SPOut

add wave -position insertpoint  \
sim:/processor/myMemory/myM1Stage/DataMemory/Address
add wave -position insertpoint  \
sim:/processor/myMemory/myM1Stage/DataMemory/IE_IM1_memWrite    
add wave -position insertpoint  \
sim:/processor/myMemory/myM1Stage/DataMemory/writeData
add wave -position insertpoint  \
sim:/processor/myMemory/myM1Stage/IE_IM1_Rsrc2_data
add wave -position insertpoint  \
sim:/processor/myDecode/read2Res
add wave -position insertpoint  \
sim:/processor/myDecode/Rt_outModule

add wave -position insertpoint  \
sim:/processor/myExecute/fu_oper2
add wave -position insertpoint  \
sim:/processor/myExecute/mux_fu2_out

add wave -position insertpoint  \
sim:/processor/myExecute/ID_IE_OPcode
add wave -position insertpoint  \
sim:/processor/myExecute/Clk_module
add wave -position insertpoint  \
sim:/processor/myDecode/myMHU/condition \
sim:/processor/myDecode/myMHU/Freeze_IF_ID \
sim:/processor/myDecode/myMHU/Freeze_PC \
sim:/processor/myDecode/myMHU/ID_IE_memread \
sim:/processor/myDecode/myMHU/ID_IE_memwrite \
sim:/processor/myDecode/myMHU/IE_IM1_memread \
sim:/processor/myDecode/myMHU/IE_IM1_memwrite \
sim:/processor/myDecode/myMHU/IF_ID_memread \
sim:/processor/myDecode/myMHU/IF_ID_memwrite \
sim:/processor/myDecode/myMHU/zero_cs
add wave -position insertpoint  \
sim:/processor/myDecode/myDEBuff/ID_IE_Rst
add wave -position insertpoint sim:/processor/myDecode/myDEBuff/*




mem load -i {F:/College Stuff/Computer Architecture/Project/InstCache.mem} /processor/myFetch/MyinstructionCache/instructionCache

#
#100 ps
force -freeze sim:/processor/Clk_module 1 0, 0 {50 ps} -r 100   
force inPort_module 'h0001
force Rst_module 1
run
force Rst_module 0
# run IN inst
run
force inPort_module 'h0002
# run IN inst
run
#NOPS
run 500 ps
run 500 ps


#INC
#run 100 ps
##NOPS
#run 500 ps
#run 100 ps
#force inPort_module 'h0001
#run 100 ps
#force inPort_module 'h000F
#run 100 ps
#force inPort_module 'h00C8
#run 100 ps
#force inPort_module 'h001F
#run 100 ps
#force inPort_module 'h00FC
#run 100 ps
##NOP
#run 100 ps
##STD
#run 100 ps
#run 100 ps
#run 100 ps
#run 300 ps
#run 1000 ps
#
#run 600 ps
#run 600 ps
##for quitting
##quit -sim

#how to restart sim
# restart -f # for restarting simulation

#to make clock
#force clk 0 , 1 {5 ns} -r 10 ns


