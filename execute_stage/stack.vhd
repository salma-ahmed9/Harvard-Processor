library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity stack is
    port (
        Rst                     : in  std_logic;--
        Clk                     : in  std_logic;
        stack_Result               : out  std_logic_vector(15 downto 0);
        addressIn : in std_logic_vector(15 downto 0)
    );
end entity;

architecture myC of stack is
begin
    process (Rst, Clk)
        variable temp_D : std_logic_vector(15 downto 0);
    begin
    
            if Rst = '1' then
                temp_D := (others => '1');  -- 0xFFFF to make it overflow 

            elsif falling_edge(Clk) then
                temp_D := addressIn;
            end if;
        
            stack_Result <= temp_D;
    end process;
end myC;
