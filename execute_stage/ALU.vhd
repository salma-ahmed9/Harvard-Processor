LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.NUMERIC_STD.ALL;
Entity ALU is 
port (
alu_in_1 , alu_in_2 : in std_logic_vector (15 downto 0);
alu_opcode :in std_logic_vector (2 downto 0 );
alu_out : out std_logic_vector (15 downto 0 );
carry_flag,zero_flag,negative_flag : out std_logic
);
end entity;

architecture myalu of ALU is
  signal alu_out_sig : std_logic_vector (15 downto 0 );
begin
  alu_out_sig <= std_logic_vector(signed(alu_in_1) + 1)when alu_opcode = "010"  --inc
               else (alu_in_1 AND alu_in_2) when alu_opcode = "110" --and 
               else alu_in_1 when alu_opcode="000" --mov
               else not( alu_in_1 ) when alu_opcode="001" --not 
               else std_logic_vector(signed(alu_in_1) -1 )when alu_opcode = "011" --dec
               else std_logic_vector(signed(alu_in_1) + signed(alu_in_2)) when alu_opcode = "100" --add
               else std_logic_vector(signed(alu_in_1) - signed(alu_in_2)) when alu_opcode = "101" --sub
               else (alu_in_1 OR alu_in_2) when alu_opcode = "111";--or
    alu_out <= alu_out_sig;

    zero_flag <= '1' when alu_out_sig="0000000000000000"
                 else '0';

    negative_flag <= '1' when signed(alu_out_sig) < 0
                         else '0';

   carry_flag <='1' when (alu_in_1 = x"7FFF" and alu_opcode = "010" ) or --inc
         ( (signed(alu_in_1) + signed(alu_in_2) > 32767 or signed(alu_in_1) + signed(alu_in_2) < -32768) and signed(alu_in_1)/=0 and signed(alu_in_2)/=0 and (alu_opcode = "100" )) --add
         or (  signed(alu_in_1) < signed(alu_in_2) and alu_opcode = "101" )--sub
         or ( signed(alu_in_1) = -32768 and alu_opcode="011") --dec
         else '0';
end architecture ;

