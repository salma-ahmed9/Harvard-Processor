library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2x1 is 
port(A,B: in std_logic_vector(15 downto 0);
     s:in std_logic;
     F:out std_logic_vector(15 downto 0));
end entity;
architecture arch of mux2x1 is
begin
F<=B when s='1' 
else A when s='0';
end arch;
