LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY BranchUnit IS
PORT(Opcode:in std_logic_vector (4 downto 0);
IM1_IM2_CCR:in std_logic_vector (2 downto 0);
BranchZ:out std_logic;
BranchC:out std_logic;
Branchuncond:out std_logic
);
END BranchUnit;

architecture Branching of BranchUnit is
Begin
--JZ
BranchZ<='1' when Opcode="10001" and IM1_IM2_CCR(0)='1' 
else '0';
--JC
BranchC<='1' when Opcode="10010" and IM1_IM2_CCR(2)='1'
else '0';
--JMP
Branchuncond<='1' when Opcode="10011" 
else '0';

end Branching;
