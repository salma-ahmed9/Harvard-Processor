LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity OutUnit is
port(
DE_opcode :in std_logic_vector (4 downto 0);
ALU_out : in std_logic_vector(15 downto 0);
out_port : out std_logic_vector (15 downto 0)
);
end entity;

architecture myoutunit of OutUnit is
begin
out_port<= Alu_out when DE_opcode ="10111" 
  else (others=>'Z') ;
end architecture ;