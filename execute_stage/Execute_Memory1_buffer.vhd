LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


entity Execute_Memory1_buffer is
port(
CLK:in std_logic;
new_PC:in std_logic_vector (15 downto 0);
CCR:in std_logic_vector (2 downto 0);
Rscr2_data: in std_logic_vector(15 downto 0);
Rdst:in std_logic_vector(2 downto 0);
CCR_out:out std_logic_vector(2 downto 0);
ALU_out: in std_logic_vector (15 downto 0);
IE_IM1_Rst:in std_logic;
new_PC_out:out std_logic_vector (15 downto 0);
IE_IM1_Rsrc2_data:out std_logic_vector(15 downto 0);
IE_IM1_ALU_out:out std_logic_vector(15 downto 0);
IE_IM1_Rdst:out std_logic_vector(2 downto 0);
controlSignals : in std_logic_vector(16 DOWNTO 0);
IE_IM1_controlSignals : out std_logic_vector(16 DOWNTO 0);
ID_IE_OPcode: in std_logic_vector (4 downto 0);
IE_IM1_OPcode: out std_logic_vector (4 downto 0);
SP_IN:in std_logic_vector(15 downto 0);
IE_IM1_sp:out std_logic_vector (15 downto 0);
Freeze:in std_logic
);
end entity;


architecture IE_IM1_buffer of Execute_Memory1_buffer is
begin
process(CLK) is
begin
     
     if falling_edge(CLK) then
     if Freeze='0' then
          new_PC_out<=new_PC;
          IE_IM1_Rsrc2_data<=Rscr2_data;
     IE_IM1_ALU_out<=ALU_out;
     IE_IM1_sp<=SP_IN;
     CCR_out<=CCR;
     IE_IM1_Rdst<=Rdst;
     IE_IM1_controlSignals <= controlSignals;
     IE_IM1_OPcode<=ID_IE_OPcode;
     end if;
     if   IE_IM1_Rst='1' then
          new_PC_out<=(others=>'0');
          IE_IM1_Rsrc2_data<=(others=>'0');
          IE_IM1_ALU_out<=(others=>'0');
          CCR_out<=(others=>'0');
          IE_IM1_Rdst<=(others=>'0');
          IE_IM1_controlSignals <= (others => '0');
          IE_IM1_OPcode<=(others=>'0');
          IE_IM1_sp<=(others=>'0');
          end if;

end if;
end process;
end IE_IM1_buffer;