LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity LoadUse is

port(
Rsc1 ,Rsc2 ,EM1_rdst , DE_rdst: in std_logic_vector (2 downto 0);
DE_memread,EM1_memread : in std_logic;
HDU_freezepc , zero_controlsig,freeze_FD : out std_logic;
needopcode : in std_logic
);
end entity;

architecture myloaduse of LoadUse is
begin
HdU_freezepc <='1' when (DE_memread ='1' and (Rsc1=DE_rdst or (Rsc2=DE_rdst and needopcode='1'))) or 
                        (EM1_memread ='1' and (Rsc1=DE_rdst or (Rsc2=DE_rdst and needopcode='1')))
        else '0';

zero_controlsig  <='1' when (DE_memread ='1' and (Rsc1=DE_rdst or (Rsc2=DE_rdst and needopcode='1'))) or 
(EM1_memread ='1' and (Rsc1=DE_rdst or (Rsc2=DE_rdst and needopcode='1')))
else '0';

freeze_FD  <='1' when (DE_memread ='1' and (Rsc1=DE_rdst or (Rsc2=DE_rdst and needopcode='1'))) or 
(EM1_memread ='1' and (Rsc1=DE_rdst or (Rsc2=DE_rdst and needopcode='1')))
else '0';             

end architecture;


