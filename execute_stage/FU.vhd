LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
entity FU is 
port(
DE_Rs,DE_Rt,EM1_Rd,WB_Rd,M1M2_Rd : in std_logic_vector(2 downto 0);
EM1_regw,M1M2_regw,WB_regw : in std_logic ;
EM1_memread : in std_logic;
FU_selector1,FU_selector2 : out std_logic_vector(1 downto 0)
);
end entity;

architecture myfu of FU is 
begin 
---------- cases for operand 1 
FU_selector1<="10" when DE_Rs = WB_Rd and WB_regw='1' --case1 rs = wb
    else "01" when DE_Rs =EM1_Rd and EM1_regw='1' and EM1_memread='0' --case 2 rs =em1    --mem read =0  because at load, we can't access MemOut and we should stall then 
    else "11"  when DE_Rs = M1M2_Rd  and M1M2_regw='1'
    else "00" ;
---------------cases for operand 2----------
FU_selector2<= "10" when DE_Rt=  WB_Rd and WB_regw='1'
   else "01" when DE_Rt= EM1_Rd and EM1_regw='1' and EM1_memread='0'
   else "11" when DE_Rt=M1M2_Rd and M1M2_regw='1' 
   else "00";

end architecture;