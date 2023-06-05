library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY add IS
PORT( old_PC : IN std_logic_vector(15 DOWNTO 0);
 sum : OUT std_logic_vector(15 DOWNTO 0));
END add;


ARCHITECTURE myC OF add 
IS

BEGIN
sum<= std_logic_vector(unsigned(old_PC)+1);


END myC;

