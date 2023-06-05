LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity CCR is 
port (
Clk: in std_logic;
rst : in std_logic;
alu_c,alu_z, alu_n : in std_logic;
clcflag , setcflag : in std_logic;
branch_z : in std_logic;
branch_c : in std_logic;
ccr_out : out std_logic_vector (2 downto 0)
);
end entity;
architecture mmycr of CCR is
begin
process (Clk,rst)
variable carry : std_logic;
variable zerofg : std_logic;
begin
    if rst ='1' then
        ccr_out<=(others => '0');
    elsif(rising_edge(Clk)) then
        carry:=alu_c;
        zerofg:=alu_z;
        if clcflag ='1' or branch_c='1' then
         carry:='0';
        elsif setcflag = '1' then
            carry:='1';
        end if;
        if branch_z='1' then
            zerofg:='0';
        end if;
        ccr_out <= zerofg & alu_n & carry;
    end if;
end process;
end architecture;

