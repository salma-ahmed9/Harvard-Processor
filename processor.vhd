library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;


entity processor is 
port(
    Clk_module: IN std_logic;
    Rst_module: IN std_logic;
    inPort_module:IN std_logic_vector(15 DOWNTO 0);
    --there remains other ports for next phases 
    outPort_module : out std_logic_vector (15 downto 0)
);
end;


architecture proc of processor is 


component fetch_stage is 
port(
    Clk_module: IN std_logic;
    Rst_module: IN std_logic;
    inPCDecision_module:IN std_logic_vector(1 DOWNTO 0);
    inPort_module:IN std_logic_vector(15 DOWNTO 0);
    inPort_outModule : out std_logic_vector(15 DOWNTO 0);--will move out side the module
    instruction_outModule : out std_logic_vector(31 DOWNTO 0);--instruction passed outside the module
    new_PC:OUT std_logic_vector(15 DOWNTO 0);
    IF_ID_reset:IN std_logic;
    branchResult:IN std_logic_vector(15 DOWNTO 0);
    PC_freeze: in std_logic;
    IF_ID_freeze: in std_logic

);
end component;


component decode_stage is 
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
end component;





component execute_stage is 
port(
    Clk_module: IN std_logic;
    Rst_module: IN std_logic;
    inPort_module:IN std_logic_vector(15 DOWNTO 0);
    controlSingals_module:IN std_logic_vector(16 DOWNTO 0);
    Rdst_module:IN std_logic_vector(2 DOWNTO 0);
    Rs_module: IN std_logic_vector(15 DOWNTO 0);
    Rt_module: IN std_logic_vector(15 DOWNTO 0);
    immediate_module:IN std_logic_vector(15 DOWNTO 0);
    IE_IM1_Rdst:out std_logic_vector(2 downto 0);
    IE_IM1_Rsrc2_data:out std_logic_vector(15 downto 0);
    IE_IM1_ALU_out:out std_logic_vector(15 downto 0);
    new_PC_out:out std_logic_vector (15 downto 0);
    CCR_out:out std_logic_vector(2 downto 0);
    controlSingals_Outmodule:OUT std_logic_vector(16 DOWNTO 0);
    WB_value : in std_logic_vector(15 downto 0);
    M1_M2_aluout: in std_logic_vector(15 downto 0);
    FU_operand1 : out std_logic_vector (1 downto 0);
    FU_operand2 : out std_logic_vector (1 downto 0);
    ID_IE_OPcode: in std_logic_vector (4 downto 0);
    IE_IM1_OPcode: out std_logic_vector (4 downto 0);
    branch_zero : in std_logic;
    branch_carry : in std_logic;
    DE_RS : in std_logic_vector(2 downto 0);
    DE_RT :in std_logic_vector(2 downto 0);
    WB_RD : in std_logic_vector(2 downto 0);
    M1M2_RD :in std_logic_vector(2 downto 0);
    M1M2_regwrite : in std_logic;
    WB_regwrite : in std_logic;
    newPC_in: in std_logic_vector (15 downto 0);
    IE_IM1_Rst:in std_logic;
    --sp
    SP_rst:in std_logic;
    ID_IE_SP_value: IN std_logic_vector(1 DOWNTO 0);

    outport : out std_logic_vector (15 downto 0);
    IE_IM1_sp: OUT std_logic_vector (15 downto 0);
    IM1_IM2_memread: in std_logic;
    IM1_IM2_memwrite: in std_logic;
    Freeze_ID_IE:out std_logic;
    Freeze_PC:out std_logic;
    Freeze_IF_ID:  out std_logic

);
end component;

-- controlSignalsOut_sig<=Reg_ALU_opcode_sig &
    --  Reg_ALU_operand1_sig & Reg_ALU_operand2_sig &
    --  Reg_MemRead_sig & Reg_MemWrite_sig & 
    -- Reg_MemAddress_sig & Reg_MemData_sig &
    --  Reg_RegWrite_sig & Reg_RegWriteSrc_sig;

    component MemoryTotal is
        port(
            clk:in std_logic ;  -- we need to put them in diagram
            Reset_in:in std_logic ;
            OPcode_module:in std_logic_vector (4 downto 0);
            IE_IM1_memAddress_in:in std_logic;  --selector of mux that determines the address of memory
            IE_IM1_memData_in:in std_logic;  --selector of mux that determines the data which would be stored in memory
            IE_IM1_memRead_in:in std_logic;
            IE_IM1_memWrite_in:in std_logic;
            IE_IM1_ALU_out_in:in std_logic_vector(15 downto 0);
            IE_IM1_SP_in:in std_logic_vector (15 downto 0);
            IE_IM1_Rsrc2_in:in std_logic_vector (15 downto 0);  --data stored in memory in case of store instruction
            new_PC_in:in std_logic_vector (15 downto 0); --data stored in memory (pushing pc in stack)
            Rdst_in:in std_logic_vector(2 downto 0);
            IE_IM1_RegWrite_in:in std_logic;
            IE_IM1_RegWriteSrc_in:in std_logic;
            Freeze_M1_M2_buffer:in std_logic;
            IM1_IM2_rst_in:in std_logic;
            IM2_WB_Rst_in:in std_logic;
            Freeze_IM2_WB_in:in std_logic;
            IM2_IWB_Rdst:out std_logic_vector (2 downto 0);
            IM2_IWB_WB_value:out std_logic_vector (15 downto 0);
            RegWrite_out:out std_logic;
            IE_IM1_CCR:in std_logic_vector(2 downto 0);
            IM1_IM2_Rdst_out:out std_logic_vector (2 downto 0);
            IM1_IM2_Regwrite_out:out std_logic;
            IM1_IM2ALUOUT_outModule:out std_logic_vector (15 downto 0);
            branch_Result_out:out std_logic;
            branch_Value:out std_logic_vector (15 downto 0);
            IM1_IM2_memread_out:out std_logic;
            IM1_IM2_memwrite_out:out std_logic
        );
        
        end component;
        


--signals 
--FD Signals
signal inpPort_FD_sig : std_logic_vector(15 DOWNTO 0);
signal instruction_FD_sig : std_logic_vector(31 DOWNTO 0);
signal IF_ID_newPC_sig : std_logic_vector(15 DOWNTO 0);

--DE Signals

signal inpPort_DE_sig : std_logic_vector(15 DOWNTO 0);
signal ControlSignals_DE_sig : std_logic_vector(16 DOWNTO 0);
signal Rdst_DE_sig : std_logic_vector(2 DOWNTO 0);
signal Rt_DE_sig : std_logic_vector(15 DOWNTO 0);
signal Rs_DE_sig : std_logic_vector(15 DOWNTO 0);
signal immediate_DE_sig : std_logic_vector(15 DOWNTO 0);
signal ID_IE_newPC_sig : std_logic_vector(15 DOWNTO 0);
signal PC_Decision_sig : std_logic_vector(1 DOWNTO 0);
signal ID_IE_Opcode_sig : std_logic_vector(4 DOWNTO 0);
signal Rs_Addr_sig : std_logic_vector(2 DOWNTO 0);
signal Rt_Addr_sig : std_logic_vector(2 DOWNTO 0);


--EM1 Signals
signal IE_IM1_Rsrc2_data_sig: std_logic_vector(15 downto 0);
signal IE_IM1_Rdst_sig: std_logic_vector(2 downto 0);
signal IE_IM1_ALU_out_sig: std_logic_vector(15 downto 0);
signal IE_IM1_CCR_sig: std_logic_vector(2 downto 0);
signal ControlSignals_EM1_sig : std_logic_vector(16 DOWNTO 0);
signal IE_IM1_Opcode_sig : std_logic_vector(4 DOWNTO 0);
signal FU1_sig: std_logic_vector(1 downto 0);
signal FU2_sig: std_logic_vector(1 downto 0);
signal IE_IM1_sp_sig: std_logic_vector (15 downto 0);


--Branch Signals
signal Branch_Result_sig : std_logic;
signal Branch_Value_sig : std_logic_vector(15 downto 0);





--red signals
signal IE_IM1_newPC: std_logic_vector(15 downto 0);

--M1/M2 signals 
signal IM1_IM2_memread_sig : std_logic;
signal IM1_IM2_memwrite_sig : std_logic;
--WB Signals
signal IM2_WB_writeData_DE_sig : std_logic_vector(15 DOWNTO 0);
signal IM1_M2_Rdst_DE_sig : std_logic_vector(2 DOWNTO 0);
signal IM2_WB_Rdst_DE_sig : std_logic_vector(2 DOWNTO 0);
signal IM2_WB_Regwrite_DE_sig : std_logic;
signal IM1_M2_Regwrite_sig : std_logic;
signal IM1_M2_ALU_out_sig : std_logic_vector(15 DOWNTO 0);

--rst signals
signal IF_ID_Rst_sig : std_logic;
signal ID_IE_Rst_sig : std_logic;
signal IE_IM1_Rst_sig : std_logic;
signal IM1_IM2_Rst_sig : std_logic;
signal IM2_WB_Rst_sig : std_logic;

--freeze Sigs
signal ID_IE_freeze_MHU: std_logic;
signal PC_freeze_MHU: std_logic;
signal IF_ID_freeze_MHU: std_logic;

signal ID_IE_freeze_sig: std_logic;

signal PC_freeze_sig: std_logic;
signal IF_ID_freeze_sig: std_logic;


begin

    myFetch: fetch_stage
    port map(
        Clk_module => Clk_module,
        Rst_module => Rst_module,
        inPCDecision_module => PC_Decision_sig,
        inPort_module => inPort_module,
        inPort_outModule => inpPort_FD_sig,
        instruction_outModule => instruction_FD_sig,
        new_PC => IF_ID_newPC_sig,
        IF_ID_reset => IF_ID_Rst_sig,
        branchResult=>Branch_Value_sig,
        PC_freeze=>PC_freeze_sig,
        IF_ID_freeze=>IF_ID_freeze_sig
    );

    ID_IE_freeze_sig<=ID_IE_freeze_MHU;
    
    --lacking
    PC_freeze_sig<=PC_freeze_MHU;
    IF_ID_freeze_sig<=IF_ID_freeze_MHU;
    myDecode: decode_stage
    port map(
        Clk_module => Clk_module,
        Rst_module => Rst_module,
        inPort_module => inpPort_FD_sig,
        inPort_outModule => inpPort_DE_sig,
        instruction_Module => instruction_FD_sig,
        PCDecision_outModule=>PC_Decision_sig,
        controlSignals_outModule => ControlSignals_DE_sig,
        Rdst_outModule => Rdst_DE_sig,
        Rt_outModule => Rt_DE_sig,
        Rs_outModule => Rs_DE_sig,
        immediate_outModule => immediate_DE_sig,
        IF_ID_newPC=>IF_ID_newPC_sig,
        ID_IE_newPC=>ID_IE_newPC_sig,
        IM2_WB_writeData_Module => IM2_WB_writeData_DE_sig,
        IM2_WB_Rdst_Module => IM2_WB_Rdst_DE_sig,
        IM2_WB_Regwrite_Module => IM2_WB_Regwrite_DE_sig,
        --hardcoded
        branchC=>'0',
        branchZ=>'0',
        IM1_IM2_branch_uncond => '0',
        HDU_freezePC     => '0',
        intr_freezePC=>'0',
        ID_IE_OPcode=>ID_IE_Opcode_sig,
        Rs_Addr=>Rs_Addr_sig,
        Rt_Addr=>Rt_Addr_sig,
        IF_ID_Rst=>IF_ID_Rst_sig,
        ID_IE_Rst=>ID_IE_Rst_sig,
        IE_IM1_Rst=>IE_IM1_Rst_sig,
        IM1_IM2_Rst=>IM1_IM2_Rst_sig,
        branchResult=>Branch_Result_sig, --hardcoded
        ID_IE_freeze=>ID_IE_freeze_sig
    );

    --Control signals
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

    myExecute: execute_stage
    port map(
        Clk_module => Clk_module,
        Rst_module => Rst_module,
        inPort_module => inpPort_DE_sig,
        controlSingals_module => ControlSignals_DE_sig,
        Rdst_module => Rdst_DE_sig,
        Rs_module => Rs_DE_sig,
        Rt_module => Rt_DE_sig,
        immediate_module => immediate_DE_sig,
        IE_IM1_Rdst => IE_IM1_Rdst_sig,
        IE_IM1_Rsrc2_data => IE_IM1_Rsrc2_data_sig,
        IE_IM1_ALU_out => IE_IM1_ALU_out_sig,
        new_PC_out =>IE_IM1_newPC,
        CCR_out => IE_IM1_CCR_sig,
        controlSingals_Outmodule => ControlSignals_EM1_sig,
        --hardcoded
        -- FU_operand1=>, might be later used for CU
        -- FU_operand1=>, might be later used for CU
        FU_operand1=>FU1_sig,
        FU_operand2=>FU2_sig,
        WB_value=>IM2_WB_writeData_DE_sig,
        M1_M2_aluout=>IM1_M2_ALU_out_sig,
        ID_IE_OPcode=>ID_IE_Opcode_sig,
        IE_IM1_Opcode=>IE_IM1_Opcode_sig,
        --hardcoded
        branch_zero=>'0',
        branch_carry=>'0',
        DE_RS=>Rs_Addr_sig,
        DE_RT=>Rt_Addr_sig,
        WB_RD=>IM2_WB_Rdst_DE_sig,
        M1M2_RD=>IM1_M2_Rdst_DE_sig,
        M1M2_regwrite=>IM1_M2_Regwrite_sig,
        WB_regwrite=>IM2_WB_Regwrite_DE_sig,
        newPC_in=>ID_IE_newPC_sig,
        IE_IM1_Rst=>IE_IM1_Rst_sig,
        SP_rst=>Rst_module,
        ID_IE_SP_value=>ControlSignals_EM1_sig(3 downto 2),
        outport=>outPort_module,
        IE_IM1_sp=>IE_IM1_SP_sig,
        IM1_IM2_memread=>IM1_IM2_memread_sig,
        IM1_IM2_memwrite=>IM1_IM2_memwrite_sig,
        Freeze_ID_IE=>ID_IE_freeze_MHU,
        Freeze_PC=>PC_freeze_MHU,
        Freeze_IF_ID=>IF_ID_freeze_MHU
    );

    -- controlSignalsOut_sig<=Reg_ALU_opcode_sig &
    --  Reg_ALU_operand1_sig & Reg_ALU_operand2_sig &
    --  Reg_MemRead_sig & Reg_MemWrite_sig & 
    -- Reg_MemAddress_sig & Reg_MemData_sig &
    --  Reg_RegWrite_sig & Reg_RegWriteSrc_sig;

    myMemory: MemoryTotal
    port map(
        clk => Clk_module,
        OPcode_module=>IE_IM1_Opcode_sig,
        IE_IM1_memAddress_in => ControlSignals_EM1_sig(8),
        IE_IM1_memData_in => ControlSignals_EM1_sig(7),
        IE_IM1_memRead_in => ControlSignals_EM1_sig(10),
        IE_IM1_memWrite_in => ControlSignals_EM1_sig(9),
        IE_IM1_ALU_out_in => IE_IM1_ALU_out_sig,
        IE_IM1_SP_in => IE_IM1_SP_sig,
        IE_IM1_Rsrc2_in => IE_IM1_Rsrc2_data_sig,
        new_PC_in => IE_IM1_newPC,
        Reset_in => Rst_module,
        Rdst_in => IE_IM1_Rdst_sig,
        IE_IM1_RegWrite_in => ControlSignals_EM1_sig(6),
        IE_IM1_RegWriteSrc_in => ControlSignals_EM1_sig(5),
        Freeze_M1_M2_buffer => '0',
        IM1_IM2_rst_in => IM1_IM2_Rst_sig,
        IM2_WB_Rst_in => Rst_module,
        Freeze_IM2_WB_in => '0',
        IM2_IWB_Rdst => IM2_WB_Rdst_DE_sig,
        IM2_IWB_WB_value => IM2_WB_writeData_DE_sig,
        RegWrite_out => IM2_WB_Regwrite_DE_sig,
        IE_IM1_CCR=>IE_IM1_CCR_sig,
        IM1_IM2_Rdst_out => IM1_M2_Rdst_DE_sig,
        IM1_IM2_Regwrite_out=>IM1_M2_Regwrite_sig,
        IM1_IM2ALUOUT_outModule=>IM1_M2_ALU_out_sig,
        branch_Result_out=>Branch_Result_sig,
        branch_Value=>Branch_Value_sig,
        IM1_IM2_memread_out=>IM1_IM2_memread_sig,
        IM1_IM2_memwrite_out=>IM1_IM2_memwrite_sig
    );



end proc;