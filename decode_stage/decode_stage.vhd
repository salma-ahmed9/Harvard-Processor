library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity decode_stage is 
port(
    Clk_module: IN std_logic;
    Rst_module: IN std_logic;
    inPort_module:IN std_logic_vector(15 DOWNTO 0);
    inPort_outModule : out std_logic_vector(15 DOWNTO 0);--will move out side the module
    instruction_Module : in std_logic_vector(31 DOWNTO 0);--instruction passed outside the module
    PCDecision_outModule : out std_logic_vector(1 DOWNTO 0);
    PCDecision_BuffoutModule : out std_logic_vector(1 DOWNTO 0);
    controlSignals_outModule : out std_logic_vector(16 DOWNTO 0);
    Rdst_outModule : out std_logic_vector(2 DOWNTO 0);
    Rt_outModule : out std_logic_vector(15 DOWNTO 0);
    Rs_outModule : out std_logic_vector(15 DOWNTO 0);
    immediate_outModule : out std_logic_vector(15 DOWNTO 0);
    IF_ID_newPC: in std_logic_vector(15 DOWNTO 0);
    ID_IE_newPC: out std_logic_vector(15 DOWNTO 0);
    IM2_WB_writeData_Module : in std_logic_vector(15 DOWNTO 0);
    IM2_WB_Rdst_Module : in std_logic_vector(2 DOWNTO 0);
    IM2_WB_Regwrite_Module : in std_logic;
    branchC: in std_logic;
    branchZ: in std_logic;
    IM1_IM2_branch_uncond: in std_logic;
    HDU_freezePC: in std_logic;
    intr_freezePC: in std_logic;
    ID_IE_OPcode: out std_logic_vector(4 DOWNTO 0);
    Rs_Addr: out std_logic_vector(2 DOWNTO 0);
    Rt_Addr: out std_logic_vector(2 DOWNTO 0);
    IF_ID_Rst:out std_logic;    
    ID_IE_Rst:out std_logic;    
    IE_IM1_Rst:out std_logic;    
    IM1_IM2_Rst:out std_logic;
    branchResult: in std_logic;
    ID_IE_freeze: in std_logic

);
end;

-------components

architecture Myarch of decode_stage is



    component controlUnit is
        port (
      
        -- Clk:IN std_logic;
        -- rst:IN std_logic;
        -- RESET_IN:IN std_logic;
        Opcode:IN std_logic_vector(4 DOWNTO 0);
        needJump:IN std_logic;
        HDU_freezPC:IN std_logic;
        intr_freezePC:IN std_logic;
        Reset_SP:IN std_logic;


        --Sync outputs
        ALU_OpCode:out std_logic_vector(2 DOWNTO 0);
        ALU_Operand_1:out std_logic_vector(1 DOWNTO 0);
        ALU_Operand_2:out std_logic;
        MemRead:out std_logic;
        MemWrite:out std_logic;
        MemAddress:out std_logic;
        MemData:out std_logic;
        RegWriteSrc:out std_logic;
        RegWrite:out std_logic;
        needsTwoOps: out std_logic;
        SP_value:out std_logic_vector(1 DOWNTO 0);
      
      
        --Async 
        branch_Result:in std_logic;

        PC_Decision:out std_logic_vector(1 DOWNTO 0);
        freez_PC: out std_logic;
        --flush
        IF_ID_Rst:out std_logic;    
        ID_IE_Rst:out std_logic;    
        IE_IM1_Rst:out std_logic;    
        IM1_IM2_Rst:out std_logic
          
        ) ;
      end component ;
      

    component Decode_Execute_buffer is
        port(
            CLK:in std_logic;
            ALU_opcode_in:in std_logic_vector (2 downto 0);
            ALU_operand1_in:in std_logic_vector (1 downto 0);
            ALU_operand2_in:in std_logic;
            ALU_operand1_out:out std_logic_vector (1 downto 0);
            ALU_operand2_out:out std_logic;
            ALU_opcode_out:out std_logic_vector (2 downto 0);
            MemData:in std_logic; --selector to mux of memory that determines which data to be stored
            MemRead:in std_logic;
            MemWrite:in std_logic;
            MemAddress:in std_logic; --selector to mux of memory that determines which address to acces in memory
            Rdst:in std_logic_vector (2 downto 0);
            Regwrite:in std_logic; -- determines whether to write back or not
            RegWriteDst:in std_logic; --selector to mux of m2 that determines write back value
            PC_Decision_in:in std_logic_vector(1 downto 0);
            PC_Decision_out:out std_logic_vector(1 downto 0);
            ID_IE_RegWriteDst:out std_logic;
            ID_IE_RegWrite:out std_logic;
            ID_IE_memData:out std_logic;
            ID_IE_memAddress:out std_logic;
            ID_IE_memRead:out std_logic;
            ID_IE_memWrite:out std_logic;
            
            OPcode_In: in std_logic_vector(4 downto 0);
            ID_IE_OPcode_out:out std_logic_vector(4 downto 0);
            
            inport:in std_logic_vector(15 downto 0);
            inport_out:out std_logic_vector(15 downto 0);
            imm_in:in std_logic_vector(15 downto 0);
            imm_out:out std_logic_vector (15 downto 0);
            Rscr1_data_in:in std_logic_vector(15 downto 0);
            Rscr2_data_in:in std_logic_vector(15 downto 0);
            Rscr1_data_out:out std_logic_vector(15 downto 0);
            Rscr2_data_out:out std_logic_vector(15 downto 0);
            
            ID_IE_Rst:in std_logic;
            -- new_PC:in std_logic_vector (15 downto 0);
            -- sp:in std_logic_vector(15 downto 0);
            new_PC_in:in std_logic_vector (15 downto 0);
            new_PC_out:out std_logic_vector (15 downto 0);
            -- ID_IE_sp:out std_logic_vector (15 downto 0);
            ID_IE_Rdst:out std_logic_vector(2 downto 0);
            Rs_Addr_in:in std_logic_vector(2 downto 0);
            Rt_Addr_in:in std_logic_vector(2 downto 0);
            Rs_Addr:out std_logic_vector(2 downto 0);
            Rt_Addr:out std_logic_vector(2 downto 0);
            freeze:IN std_logic
        );
        end component;



        component RegisterFile IS
        PORT (clk ,rst: IN std_logic;
        readAddress1:in std_logic_vector (2 downto 0);
        readAddress2:in std_logic_vector (2 downto 0);
        writeAddress:in std_logic_vector (2 downto 0);
        writeData:in std_logic_vector(15 downto 0);
        RegWrite:in std_logic;
        ReadData1:out std_logic_vector(15 downto 0);
        ReadData2:out std_logic_vector (15 downto 0)
        );
        END component;
-----------------------------


---------signals-----------
--pc
-- signal pc_result_sig: std_logic_vector(15 DOWNTO 0);
-- signal old_PC_sig: std_logic_vector(15 DOWNTO 0);
-- signal instructionCacheAddress_sig: std_logic_vector(15 DOWNTO 0);
-- signal freeze_sig: std_logic;

signal read1Res: std_logic_vector(15 DOWNTO 0);
signal read2Res: std_logic_vector(15 DOWNTO 0);

signal needJump_sig: std_logic;

--CU input signals 

--control signals
signal ALU_opcode_sig: std_logic_vector(2 DOWNTO 0);
signal ALU_operand1_sig: std_logic_vector(1 DOWNTO 0);
signal ALU_operand2_sig: std_logic;
signal MemRead_sig: std_logic;
signal MemWrite_sig: std_logic;
signal MemAddress_sig: std_logic;
signal MemData_sig: std_logic;
signal RegWrite_sig: std_logic;
signal RegWriteSrc_sig: std_logic;

--control signals concat
signal controlSignalsOut_sig: std_logic_vector(16 DOWNTO 0);

--RegOut signals
signal Reg_ALU_opcode_sig: std_logic_vector(2 DOWNTO 0);
signal Reg_ALU_operand1_sig: std_logic_vector(1 DOWNTO 0);
signal Reg_ALU_operand2_sig: std_logic;
signal Reg_MemRead_sig: std_logic;
signal Reg_MemWrite_sig: std_logic;
signal Reg_MemAddress_sig: std_logic;
signal Reg_MemData_sig: std_logic;
signal Reg_RegWrite_sig: std_logic;
signal Reg_RegWriteSrc_sig: std_logic;
signal needsTwoOps_sig: std_logic;
signal SP_value_sig: std_logic_vector(1 DOWNTO 0);
signal PC_Decision_sig: std_logic_vector(1 DOWNTO 0);
signal Reg_inPortOut_sig: std_logic_vector(15 DOWNTO 0);
signal ID_IE_Rst_sig: std_logic;
signal RegResetSignal: std_logic;
signal ID_IE_freeze_sig: std_logic;


--execute decode reg
------------------------------------------


begin
    controlSignalsOut_sig<=Reg_ALU_opcode_sig & Reg_ALU_operand1_sig & Reg_ALU_operand2_sig & Reg_MemRead_sig & Reg_MemWrite_sig & Reg_MemAddress_sig & Reg_MemData_sig & Reg_RegWrite_sig & Reg_RegWriteSrc_sig & needsTwoOps_sig & SP_value_sig & PC_Decision_sig ; 
    -- controlSignalsOut_sig<=Reg_ALU_opcode_sig & Reg_ALU_operand1_sig
    --  & Reg_ALU_operand2_sig & Reg_MemRead_sig &
    --  Reg_MemWrite_sig & Reg_MemAddress_sig & Reg_MemData_sig
    --  & Reg_RegWrite_sig & Reg_RegWriteSrc_sig
    --   & needsTwoOps_sig & SP_value_sig & PC_Decision_sig ; 
    -- total is 17
    -- Reg_ALU_opcode_sig is (16 downto 14)
    -- Reg_ALU_operand1_sig is (13 downto 12)
    -- Reg_ALU_operand2_sig is (11)
    -- Reg_MemRead_sig is (10)
    -- Reg_MemWrite_sig is (9)
    -- Reg_MemAddress_sig is (8)
    -- Reg_MemData_sig is (7)
    -- Reg_RegWrite_sig is (6)
    -- Reg_RegWriteSrc_sig is (5)
    -- needsTwoOps_sig is (4)
    -- SP_value_sig is (3 downto 2)
    -- PC_Decision_sig is (1 downto 0)
    ID_IE_freeze_sig<=ID_IE_freeze;
    needJump_sig<= branchC or branchZ or IM1_IM2_branch_uncond;
    controlSignals_outModule<=controlSignalsOut_sig;
    RegResetSignal<=Rst_module or IM1_IM2_branch_uncond;
    PCDecision_outModule<= PC_Decision_sig;
    -- inPort_outModule<=inPort_module;
    myRegfile:RegisterFile port map(
        readAddress1=>instruction_Module(23 downto 21),
        readAddress2=>instruction_Module(20 downto 18),
        writeAddress=>IM2_WB_Rdst_Module,
        writeData=>IM2_WB_writeData_Module,
        RegWrite=>IM2_WB_Regwrite_Module,
        ReadData1=>read1Res,
        ReadData2=>read2Res,
        Rst=>Rst_module,
        Clk=>Clk_module
    ); 

    myCU:controlUnit port map(
        -- Rst=>Rst_module,
        -- Clk=>Clk_module,
        -- RESET_IN=>'0',
        Opcode=>instruction_Module(31 downto 27),
        needJump=>needJump_sig,
        HDU_freezPC=>HDU_freezePC,
        intr_freezePC=>intr_freezePC,
        --------
        ALU_opcode=>ALU_opcode_sig,
        ALU_Operand_1=>ALU_operand1_sig,
        ALU_Operand_2=>ALU_operand2_sig,
        MemRead=>MemRead_sig,
        MemWrite=>MemWrite_sig,
        MemAddress=>MemAddress_sig,
        MemData=>MemData_sig,
        RegWrite=>RegWrite_sig,
        RegWriteSrc=>RegWriteSrc_sig,
        Reset_SP=>'0',
        needsTwoOps=>needsTwoOps_sig,
        SP_value=>SP_value_sig,
        PC_Decision=>PC_Decision_sig,
        IF_ID_Rst=>IF_ID_Rst,
        ID_IE_Rst=>ID_IE_Rst_sig,
        IE_IM1_Rst=>IE_IM1_Rst,
        IM1_IM2_Rst=>IM1_IM2_Rst,
        branch_Result=>branchResult

        -- PC_Decision=>PC_Decison,
    );
    myDEBuff:Decode_Execute_buffer port map(
        CLK=>Clk_module,
        ALU_opcode_in=>ALU_opcode_sig,
        ALU_operand1_in=>ALU_operand1_sig,
        ALU_operand2_in=>ALU_operand2_sig,
        ALU_operand1_out=>Reg_ALU_operand1_sig,
        ALU_operand2_out=>Reg_ALU_operand2_sig,
        ALU_opcode_out=>Reg_ALU_opcode_sig,
        MemData=>MemData_sig,
        MemRead=>MemRead_sig,
        MemWrite=>MemWrite_sig,
        MemAddress=>MemAddress_sig,
        Rdst=>instruction_Module(26 downto 24),
        Regwrite=>RegWrite_sig,
        RegWriteDst=>RegWriteSrc_sig,
        PC_Decision_in=>PC_Decision_sig,
        PC_Decision_out=>PCDecision_BuffoutModule,
        ID_IE_RegWrite=>Reg_RegWrite_sig,
        ID_IE_RegWriteDst=>Reg_RegWriteSrc_sig,
        ID_IE_memData=>Reg_MemData_sig,
        ID_IE_memAddress=>Reg_MemAddress_sig,
        ID_IE_memRead=>Reg_MemRead_sig,
        ID_IE_memWrite=>Reg_MemWrite_sig,
        OPcode_In=>instruction_Module(31 downto 27),
        ID_IE_OPcode_out=>ID_IE_OPcode,
        --in
        inport=>inport_module,
        inport_out=>inPort_outModule,
        --imm
        imm_in=>instruction_Module(17 downto 2),
        imm_out=>immediate_outModule,
        Rscr1_data_in=>read1Res,
        Rscr2_data_in=>read2Res,
        Rscr1_data_out=>Rt_outModule,
        Rscr2_data_out=>Rs_outModule,
        ID_IE_Rst=>RegResetSignal, 
        -- sp=>sp_module,
        new_PC_in=>IF_ID_newPC,
        new_PC_out=>ID_IE_newPC,
        -- ID_IE_sp=>sp_module,
        ID_IE_Rdst=>Rdst_outModule,
        Rs_Addr_in=>instruction_Module(23 downto 21),
        Rt_Addr_in=>instruction_Module(20 downto 18),
        Rs_Addr=>Rs_Addr,
        Rt_Addr=>Rt_Addr,
        freeze=>ID_IE_freeze_sig--hardcoded
        );

  





end Myarch ; 