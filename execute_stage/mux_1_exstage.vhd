LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

Entity mux_1_exstage is 
port (
Rsc1,Inport,imm : in std_logic_vector(15 downto 0);
alu_operand_1 : in std_logic_vector (1 downto 0);
alu_in_1 : out std_logic_vector(15 downto 0)
);
end entity;

architecture mymux1 of mux_1_exstage is
begin 
alu_in_1 <=Rsc1 when alu_operand_1 ="00"
else imm when alu_operand_1 ="10"
else Inport;
end architecture;
