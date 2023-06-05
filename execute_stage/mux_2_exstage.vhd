LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

Entity mux_2_exstage is 
port (
Rsc2,imm : in std_logic_vector(15 downto 0);
alu_operand_2 : in std_logic ;
alu_in_2 : out std_logic_vector(15 downto 0)
);
end entity;

architecture mymux2 of mux_2_exstage is
begin 
alu_in_2 <=Rsc2 when alu_operand_2 ='0'
else imm;
end architecture;
