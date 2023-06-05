LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
entity fetchDecodeReg is
  port (
    Clk:IN std_logic;
    freeze:IN std_logic;
    rst:IN std_logic;
    inPort : IN std_logic_vector(15 DOWNTO 0);
    instruction : IN std_logic_vector(31 DOWNTO 0);
    inPort_passed : out std_logic_vector(15 DOWNTO 0);
    instruction_passed : out std_logic_vector(31 DOWNTO 0);
    newPC_in: IN std_logic_vector(15 DOWNTO 0);
    newPC : out std_logic_vector(15 DOWNTO 0)

  ) ;
end fetchDecodeReg ;

architecture arch of fetchDecodeReg is



begin
    process(rst,Clk,freeze)
    variable temp_InPort : std_logic_vector(15 downto 0);
    variable temp_instruction : std_logic_vector(31 DOWNTO 0);
    begin 
    if freeze='0'then
    if rst='1' then 
    -- temp_InPort := (others => '0');
    -- temp_instruction := (others => '0');
    inPort_passed <=(others => '0');
    instruction_passed <=(31 downto 27=>'1', others => '0');  -- 1's for avoiding the Mov command  (Invalid command )
    newPC <=(others => '0');
    elsif falling_edge(Clk) then
      inPort_passed <=inPort;
      instruction_passed <=instruction;
      newPC <=newPC_in;
        -- temp_InPort := inPort;
        -- temp_instruction := instruction;
    end if;
    end if;

    -- inPort_passed <=temp_InPort;
    -- instruction_passed <=temp_instruction;
    -- instruction_passed <=temp_instruction;
    end process;
end architecture ; -- arch