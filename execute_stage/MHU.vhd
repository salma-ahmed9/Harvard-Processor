LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.NUMERIC_STD.ALL;
entity MHU is
port (ID_IE_memread,ID_IE_memwrite,IM1_IM2_memread,IM1_IM2_memwrite,IE_IM1_memread,IE_IM1_memwrite:in std_logic;
Freeze_ID_IE,Freeze_PC,Freeze_IF_ID,zero_cs:out std_logic
);
end entity;

architecture memoryhazard of MHU is

    signal condition:std_logic;
begin
    condition <= '1' when ((ID_IE_memread='1' or ID_IE_memwrite='1')and (IM1_IM2_memread='1' or IM1_IM2_memwrite='1')and (IE_IM1_memread='0' and IE_IM1_memwrite='0')) or ((ID_IE_memread='1' or ID_IE_memwrite='1') and (IE_IM1_memread='1' or IE_IM1_memwrite='1'))
    else '0';


    Freeze_ID_IE<='1' when  condition= '1'
    else '0';

    Freeze_PC<='1'  when condition= '1'
    else '0';
    Freeze_IF_ID<='1' when  condition= '1' 
    else '0';
    zero_cs<='1'  when  condition= '1' 
    else '0';




end memoryhazard;