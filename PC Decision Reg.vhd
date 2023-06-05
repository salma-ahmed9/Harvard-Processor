LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY PCDecisionReg is
port(
CLK:in std_logic;
PCDec_in:in std_logic_vector (1 downto 0);
PCDec_out:out std_logic_vector (1 downto 0);
freeze:IN std_logic

);
end entity;


architecture branchPCR of PCDecisionReg is
begin
process(CLK) is
begin
    if falling_edge(CLK) then
        PCDec_out<=PCDec_in;
end if;
end process;
end branchPCR;
