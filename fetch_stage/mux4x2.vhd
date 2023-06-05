library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4x2 is 
port(A,B,C,D: in std_logic_vector(15 downto 0);
     s:in std_logic_vector(1 downto 0);
     F:out std_logic_vector(15 downto 0));
end entity;
architecture arch of mux4x2 is
begin
F<=A when s="00" else
B when s="01" else
C when s="10" else
D when s="11" ;
end arch;

