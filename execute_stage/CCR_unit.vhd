LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity CCR_unit is 
port (
D_E_opcode : in std_logic_vector (4 downto 0 );
clrflag,setflag:out std_logic
);
end entity;

architecture myccr of CCR_unit is
begin
clrflag <= '1' when D_E_opcode ="10101" 
else '0';
setflag <= '1' when D_E_opcode ="10100" 
else '0';
end architecture;
