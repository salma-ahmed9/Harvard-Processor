LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY branchResultReg is
port(
CLK:in std_logic;
branchRes_in:in std_logic_vector (15 downto 0);
branchRes_out:out std_logic_vector (15 downto 0);
freeze:IN std_logic

);
end entity;


architecture branchArcher of branchResultReg is
begin
process(CLK) is
begin
    if falling_edge(CLK) then
        branchRes_out<=branchRes_in;
end if;
end process;
end branchArcher;
