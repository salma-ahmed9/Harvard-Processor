LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY Memory2_WriteBack_buffer is
port(
clk:in std_logic;
IM1_IM2_Rdst:in std_logic_vector (2 downto 0);
WB_value:in std_logic_vector(15 downto 0);
IM2_IWB_Rdst:out std_logic_vector(2 downto 0);
IM2_IWB_WB_value:out std_logic_vector (15 downto 0);
IM2_WB_Rst:in std_logic;
RegWrite_in:in std_logic;
RegWrite_out:out std_logic;
Freeze:in std_logic
);
end entity;

architecture IM2_WB_buffer of Memory2_WriteBack_buffer is
begin
process(IM2_WB_Rst,clk) is
begin
if   IM2_WB_Rst='1' then
     IM2_IWB_Rdst<=(others=>'0');
     IM2_IWB_WB_value<=(others=>'0');
     RegWrite_out<='0';
 
elsif falling_edge(clk) then
     if Freeze='0' then
     IM2_IWB_Rdst<=IM1_IM2_Rdst;
     IM2_IWB_WB_value<=WB_value;
     RegWrite_out<=RegWrite_in;
     end if;
end if;
end process;
end IM2_WB_buffer;
