LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY M1 is
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
end entity;
architecture Memory1 of M1 is
component MemArray IS
PORT (
     clk,rst            : in  std_logic;
    IE_IM1_memRead  : in  std_logic;
    IE_IM1_memWrite : in  std_logic;
    Address         : in  std_logic_vector(9 downto 0);
    writeData       : in  std_logic_vector(15 downto 0);
    Reset           : in  std_logic;
    Mem_out         : out std_logic_vector(15 downto 0)
    );
END component MemArray;

component mux2x1 is 
port(A,B: in std_logic_vector(15 downto 0);
     s:in std_logic;
     F:out std_logic_vector(15 downto 0));
end component mux2x1;
signal outofmux1,outofmux2,outofmux0:std_logic_vector(15 downto 0);
signal IE_IM1_Rsrc1_Extended:std_logic_vector(15 downto 0);
signal spminus1:std_logic_vector(15 downto 0);
signal outOfMux0_trimmed:std_logic_vector(9 downto 0);
begin
--address
spminus1<= std_logic_vector(unsigned(IE_IM1_SP)-1);
M1_Data_Rsrc2_out<= IE_IM1_Rsrc2_data;
M1_ALU_out<=IE_IM1_ALU_out;
outOfMux0_trimmed<=outOfMux0_trimmed(9 downto 0);
chooseSPValue:mux2x1 port map(IE_IM1_SP,spminus1,IE_IM1_memRead,outofmux0);
ToAddress:mux2x1 port map(IE_IM1_ALU_out,outofmux0,IE_IM1_memAddress,outofmux1);
--data
ToWrite:mux2x1 port map(IE_IM1_Rsrc2_data,IE_IM1_PC_out,IE_IM1_memData,outofmux2);
DataMemory:MemArray port map(clk,rst,
IE_IM1_memRead
,IE_IM1_memWrite,
outofmux1(9 downto 0),
outofmux2,
Reset,
Mem_out);
ALU_out<=IE_IM1_ALU_out;
Rdst_out<=Rdst;
IE_IM1_RegWrite_out<=IE_IM1_RegWrite;
IE_IM1_RegWriteSrc_out<=IE_IM1_RegWriteSrc;
end Memory1;
