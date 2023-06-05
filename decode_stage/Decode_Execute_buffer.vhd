LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY Decode_Execute_buffer is
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
end entity;


architecture D_E_buffer of Decode_Execute_buffer is
begin
process(ID_IE_Rst,CLK) is
begin
if   ID_IE_Rst='1' then
    
    ALU_opcode_out<=(others=>'0');
    ALU_operand1_out<=(others=>'0');
    ALU_operand2_out<='0';
    inport_out<=(others=>'0');
    imm_out<=(others=>'0');
    Rscr1_data_out<=(others=>'0');
    Rscr2_data_out<=(others=>'0');
    ID_IE_RegWriteDst<='0';
    ID_IE_memData<='0';
    ID_IE_memAddress<='0';
    ID_IE_memRead<='0';
    ID_IE_memWrite<='0';
    ID_IE_RegWrite<='0';
    new_PC_out<=(others=>'0');
    -- ID_IE_sp<=(others=>'0');
    ID_IE_Rdst<=(others=>'0');
    PC_Decision_out<=(others=>'0');
    ID_IE_OPcode_out<=(others=>'0');
    Rs_Addr<=(others=>'0');
    Rt_Addr<=(others=>'0');
    
    elsif falling_edge(CLK) then
        if freeze='0'then
        ALU_opcode_out<=ALU_opcode_in;
        ALU_operand1_out<=ALU_operand1_in;
        ALU_operand2_out<=ALU_operand2_in;
        inport_out<=inport;
        imm_out<=imm_in;
        Rscr1_data_out<=Rscr2_data_in;
        Rscr2_data_out<=Rscr1_data_in;
        ID_IE_RegWrite<=Regwrite;
        ID_IE_RegWriteDst<=RegWriteDst;
        ID_IE_memData<=MemData;
        ID_IE_memAddress<=MemAddress;
        ID_IE_memRead<=MemRead;
        ID_IE_memWrite<=MemWrite;
        new_PC_out<=new_PC_in;
        -- ID_IE_sp<=sp;
        ID_IE_Rdst<=Rdst;
        PC_Decision_out<=PC_Decision_in;
        ID_IE_OPcode_out<=OPcode_In;
        Rs_Addr<=Rs_Addr_in;
        Rt_Addr<=Rt_Addr_in;
        end if;
end if;
end process;
end D_E_buffer;
