library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC is
    port (
        freeze                  : in  std_logic;
        Rst                     : in  std_logic;
        Clk                     : in  std_logic;
        interuptSig             : in  std_logic;
        PC_Result               : in  std_logic_vector(15 downto 0);
        memZero                 : in  std_logic_vector(31 downto 0);
        memOne                 : in  std_logic_vector(31 downto 0);
        instructionCacheAddress : out std_logic_vector(15 downto 0);
        old_PC                  : out std_logic_vector(15 downto 0)
    );
end entity;

architecture myC of PC is
begin
    process (freeze, Rst, Clk)
        variable temp_D : std_logic_vector(15 downto 0);
    begin
        if freeze = '0' then
            if Rst = '1' then
                --temp_D := (others => '1');  -- 0xFFFF to make it overflow 
                temp_D:=std_logic_vector(to_signed(to_integer(unsigned(memZero(15 downto 0))) -1, 16));

            elsif falling_edge(Clk) then
                if interuptSig='1'then
                   temp_D:=std_logic_vector(to_signed(to_integer(unsigned(memOne(15 downto 0))) - 1, 16));
                    else 
                temp_D := PC_Result;
                end if;
            end if;
        end if;
        
        instructionCacheAddress <= temp_D;
        old_PC <= temp_D;
    end process;
end myC;
