LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity Memory1_Memory2_buffer is 
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
end entity;

architecture M1_M2_buffer of Memory1_Memory2_buffer is
begin
process(IM1_IM2_rst,clk) is
begin
if   IM1_IM2_rst='1' then
     IM1_IM2_MemOut<=(others=>'0');
     IM1_IM2_ALUout<=(others=>'0');
     IM1_IM2_Rdst<=(others=>'0');
     IM1_IM2_RegWriteSrc<='0';
     IM1_IM2_RegWrite<='0';
     IM1_IM2_CCR<=(others=>'0');
     OPcode_out<=(others=>'0');
     IM1_IM2_memread_out<='0';
     IM1_IM2_memwrite_out<='0';
     
elsif falling_edge(clk) then
     if Freeze='0' then
     IM1_IM2_MemOut<=Mem_out;
     IM1_IM2_Rdst<=IE_IM1_Rdst;
     IM1_IM2_ALUout<=IE_IM1_ALU_out;
     IM1_IM2_RegWriteSrc<=IE_IM1_RegWriteSrc;
     IM1_IM2_RegWrite<=IE_IM1_RegWrite;
     IM1_IM2_CCR<=IE_IM1_CCR;
     OPcode_out<=OPcode_in;
     IM1_IM2_memread_out<=IM1_IM2_memread_in;
     IM1_IM2_memwrite_out<=IM1_IM2_memwrite_in;
     end if;
end if;
end process;
end M1_M2_buffer;
