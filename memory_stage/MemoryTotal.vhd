LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY MemoryTotal is
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

end entity;

architecture MTotal of MemoryTotal is

    component M1 is
        port(clk,rst:in std_logic ;  -- we need to put them in diagram
        IE_IM1_memAddress:in std_logic;  --selector of mux that determines the address of memory
        IE_IM1_memData:in std_logic;  --selector of mux that determines the data which would be stored in memory
        IE_IM1_memRead:in std_logic;
        IE_IM1_memWrite:in std_logic;
        IE_IM1_ALU_out:in std_logic_vector(15 downto 0);
        IE_IM1_SP:in std_logic_vector (15 downto 0);
        IE_IM1_Rsrc2_data:in std_logic_vector (15 downto 0);  --data stored in memory in case of store instruction
        Reset:in std_logic ;
        Mem_out:out std_logic_vector (15 downto 0);
        ALU_out:out std_logic_vector (15 downto 0);
        M1_ALU_out:out std_logic_vector (15 downto 0);
        Rdst:in std_logic_vector(2 downto 0);
        Rdst_out:out std_logic_vector(2 downto 0);
        IE_IM1_RegWrite:in std_logic;
        IE_IM1_RegWrite_out:out std_logic;
        IE_IM1_RegWriteSrc:in std_logic;
        IE_IM1_RegWriteSrc_out:out std_logic;
        M1_Data_Rsrc2_out:out std_logic_vector (15 downto 0);
        IE_IM1_PC_out:in std_logic_vector(15 downto 0)
        );
        end component;


        component Memory1_Memory2_buffer is 
        port(
            clk:in std_logic;
            Mem_out:in std_logic_vector (15 downto 0);
            IE_IM1_ALU_out:in std_logic_vector (15 downto 0);
            IE_IM1_RegWrite:in std_logic;
            IM1_IM2_RegWrite:out std_logic;
            IE_IM1_RegWriteSrc:in std_logic;
            IM1_IM2_RegWriteSrc:out std_logic;
            IE_IM1_Rdst:in std_logic_vector (2 downto 0);
            IM1_IM2_rst:in std_logic;
            IM1_IM2_MemOut:out std_logic_vector (15 downto 0);
            IM1_IM2_ALUout:out std_logic_vector (15 downto 0);
            IM1_IM2_Rdst:out std_logic_vector (2 downto 0);
            Freeze:in std_logic;
            IE_IM1_CCR:in std_logic_vector (2 downto 0);
            IM1_IM2_CCR:out std_logic_vector (2 downto 0);
            OPcode_in:in std_logic_vector(4 downto 0);
            OPcode_out:out std_logic_vector(4 downto 0);
            IM1_IM2_memread_in:in std_logic;
            IM1_IM2_memwrite_in:in std_logic;
            IM1_IM2_memread_out:out std_logic;
            IM1_IM2_memwrite_out:out std_logic
        );
        end component;

        component M2 is 
        port(
            IM1_IM2_MemOut:in std_logic_vector (15 downto 0);
            IM1_IM2_ALUout:in std_logic_vector (15 downto 0);
            IM1_IM2_Rdst:in std_logic_vector (2 downto 0);
            IM1_IM2_RegWriteSrc:in std_logic;  --selector of mux that determines which value for write baack value
            Rdst:out std_logic_vector (2 downto 0);
            WB_value:out std_logic_vector (15 downto 0);
            IM1_IM2_RegWrite:in std_logic;
            Opcode:in std_logic_vector(4 downto 0);
            IM1_IM2_CCR:in std_logic_vector (2 downto 0);
            Reg_write_out:out std_logic;
            BranchResult:out std_logic;
            branchZ : out std_logic;
            branchC : out std_logic;
            BranchValue:out std_logic_vector(15 downto 0)
        );
        end component;

  



signal Mem_out,ALU_out,IM1_IM2_MemOut,IM1_IM2_ALUout,M2_WB_value:std_logic_vector(15 downto 0);
signal Rdst_out_sig,IM1_IM2_Rdst_sig,M2_Rdst:std_logic_vector(2 downto 0);
signal IE_IM1_RegWrite_out, IE_IM1_RegWriteSrc_out, IM1_IM2_RegWriteSrc, M2_RegWrite_out:std_logic;

signal IM1_IM2_RegWrite:std_logic;

signal M1_ALU_out_sig: std_logic_vector (15 downto 0);

signal M1_Data_Rsrc2_out_sig:std_logic_vector (15 downto 0);

signal IM1_IM2_PC_out,M2_PC_out:std_logic_vector(15 downto 0);

signal M1_Opcode_sig:std_logic_vector(4 downto 0);
signal IM1_IM2_CCR_sig:std_logic_vector(2 downto 0);
signal IM1_IM2_rst_sig:std_logic;
signal IM2_WB_Rst_sig:std_logic;
signal BranchResult_sig,branchZ_sig,branchC_sig,Branchuncond_sig:std_logic;

begin

    myM1Stage:M1 port map(
    clk=>clk,
    rst=>Reset_in,
    IE_IM1_memAddress=>IE_IM1_memAddress_in,
    IE_IM1_memData=>IE_IM1_memData_in,
    IE_IM1_memRead=>IE_IM1_memRead_in,
    IE_IM1_memWrite=>IE_IM1_memWrite_in,
    IE_IM1_ALU_out=>IE_IM1_ALU_out_in,
    IE_IM1_SP=>IE_IM1_SP_in,
    IE_IM1_Rsrc2_data=>IE_IM1_Rsrc2_in,
    Reset=>Reset_in,
    Mem_out=>Mem_out,
    ALU_out=>ALU_out,
    M1_ALU_out=>M1_ALU_out_sig,
    Rdst=>Rdst_in,
    Rdst_out=>Rdst_out_sig,
    IE_IM1_RegWrite=>IE_IM1_RegWrite_in,
    IE_IM1_RegWrite_out=>IE_IM1_RegWrite_out,
    IE_IM1_RegWriteSrc=>IE_IM1_RegWriteSrc_in,
    IE_IM1_RegWriteSrc_out=>IE_IM1_RegWriteSrc_out,
    M1_Data_Rsrc2_out=>M1_Data_Rsrc2_out_sig,
    IE_IM1_PC_out=>new_PC_in
    );

    

    IM1_IM2_rst_sig<=IM1_IM2_rst_in or Reset_in;
Mem12Buff:Memory1_Memory2_buffer port map(
    clk=>clk,
    Mem_out=>Mem_out,
    IE_IM1_ALU_out=>ALU_out,
    IE_IM1_RegWrite=>IE_IM1_RegWrite_in,
    IM1_IM2_RegWrite=>IM1_IM2_RegWrite,
    IE_IM1_RegWriteSrc=>IE_IM1_RegWriteSrc_in,
    IM1_IM2_RegWriteSrc=>IM1_IM2_RegWriteSrc,
    IE_IM1_Rdst=>Rdst_out_sig,
    IM1_IM2_rst=>IM1_IM2_rst_sig,
    IM1_IM2_MemOut=>IM1_IM2_MemOut,
    IM1_IM2_ALUout=>IM1_IM2_ALUout,
    IM1_IM2_Rdst=>IM1_IM2_Rdst_sig,
    Freeze=>Freeze_M1_M2_buffer,
    IE_IM1_CCR=>IE_IM1_CCR,
    IM1_IM2_CCR=>IM1_IM2_CCR_sig,
    OPcode_in=>OPcode_module,
    OPcode_out=>M1_Opcode_sig,
    IM1_IM2_memread_in=>IE_IM1_memRead_in,
    IM1_IM2_memwrite_in=>IE_IM1_memWrite_in,
    IM1_IM2_memread_out=>IM1_IM2_memread_out,
    IM1_IM2_memwrite_out=>IM1_IM2_memwrite_out
    );
IM1_IM2_Rdst_out<=IM1_IM2_Rdst_sig;
IM1_IM2_Regwrite_out<=IM1_IM2_RegWrite;
IM1_IM2ALUOUT_outModule<=IM1_IM2_ALUout;


branch_Result_out<=BranchResult_sig;
branch_Value<=M2_PC_out;
myMem2Stage: M2 port map(
IM1_IM2_MemOut=>IM1_IM2_MemOut,
IM1_IM2_ALUout=>IM1_IM2_ALUout,
IM1_IM2_Rdst=>IM1_IM2_Rdst_sig,
IM1_IM2_RegWriteSrc=>IM1_IM2_RegWriteSrc,
Rdst=>M2_Rdst,
WB_value=>M2_WB_value,
IM1_IM2_RegWrite=>IM1_IM2_RegWrite,
Opcode=>M1_Opcode_sig,
IM1_IM2_CCR=>IM1_IM2_CCR_sig,
Reg_write_out=>M2_RegWrite_out,
BranchResult=>BranchResult_sig,
branchZ=>branchZ_sig,
branchC=>branchC_sig,
BranchValue=>M2_PC_out
);
IM2_WB_Rst_sig<=IM2_WB_Rst_in or Reset_in;
Mem2WBBuff:entity work.Memory2_WriteBack_buffer port map(
clk=>clk,
IM1_IM2_Rdst=>M2_Rdst,
WB_value=>M2_WB_value,
IM2_IWB_Rdst=>IM2_IWB_Rdst,
IM2_IWB_WB_value=>IM2_IWB_WB_value,
IM2_WB_Rst=>IM2_WB_Rst_sig,
RegWrite_in=>M2_RegWrite_out,
RegWrite_out=>RegWrite_out,
Freeze=>Freeze_IM2_WB_in);


end Mtotal;
