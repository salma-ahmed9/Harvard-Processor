library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY stackAdd IS
PORT( old_stack : IN std_logic_vector(15 DOWNTO 0);
secondOperand: IN std_logic_vector(15 DOWNTO 0);
 sum : OUT std_logic_vector(15 DOWNTO 0));
END stackAdd;


ARCHITECTURE myC OF stackAdd 
IS

BEGIN
sum<= std_logic_vector(signed(old_stack)+signed(secondOperand) );


END myC;

