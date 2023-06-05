LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity interuptUnit is
  port (
    Clk:IN std_logic;
    rst:IN std_logic;

    CCR : IN std_logic_vector(15 DOWNTO 0);
    interuptIN:IN std_logic;
    inPort_passed : out std_logic_vector(15 DOWNTO 0);

    freezePC:OUT std_logic;
    controlInstruction:OUT std_logic;
    interuptInstruction : out std_logic_vector(31 DOWNTO 0)
 
    ) ;
end interuptUnit ;

architecture arch of interuptUnit is
begin

    process(Clk,rst,interuptIN)
    VARIABLE counter: std_logic_vector(3 downto 0):="0000";
    begin

        if rst='1'then
            counter := "000";
            freezePC<='0';
            controlInstruction<='0';
            interuptInstruction<=x"00000000";
        elsif interuptIN='1'then
            counter:= std_logic_vector(unsigned(counter) + 1); 
            end if;
        if counter>="0101"then    
        freezePC<='1'
        interuptInstruction<="01000"&"001" &"000" &"000" &"0000000000000001" &"00";--ldm r1,1;
        if counter=="0110"
        counter:= std_logic_vector(unsigned(counter) + 1);
        interuptInstruction<="01010"& "010" &"000"& "001" &"0000000000000000"& "00";--ldd r2,r1
           elsif counter=="0111" then
            counter:= std_logic_vector(unsigned(counter) + 1);
            
            interuptInstruction<="11000"& "000"& "010"& "000"& "0000000000000001" &"00";--call r2
               elsif counter=="0111" then
                counter:= std_logic_vector(unsigned(counter) + 1);
                interuptInstruction<="01000"&"001"& "000"& "000"&CCR& "00";--lmd r1,carry flags

                 elsif counter=="1000" then
                    counter:= std_logic_vector(unsigned(counter) + 1);
                    interuptInstruction<="11001"& "000"& "000" &"001" &"0000000000000000"&"00";--push r1
                        end if;
            



         end if;    

            
         end process;




end architecture ; -- arch