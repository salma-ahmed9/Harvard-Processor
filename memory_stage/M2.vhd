LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity M2 is 
port(
IM1_IM2_MemOut:in std_logic_vector (15 downto 0);
IM1_IM2_ALUout:in std_logic_vector (15 downto 0);
IM1_IM2_Rdst:in std_logic_vector (2 downto 0);
IM1_IM2_RegWriteSrc:in std_logic;  --selector of mux that determines which value for write baack value
Rdst:out std_logic_vector (2 downto 0);
WB_value:out std_logic_vector (15 downto 0);
IM1_IM2_RegWrite:in std_logic;
Opcode:in std_logic_vector(4 downto 0);
IM1_IM2_CCR:in std_logic_vector (2 downto 0);
Reg_write_out:out std_logic;
branchZ : out std_logic;
branchC : out std_logic;
BranchResult:out std_logic;
BranchValue:out std_logic_vector(15 downto 0)

);
end entity;

architecture Memory2 of M2 is
component mux2x1 is 
port(A,B: in std_logic_vector(15 downto 0);
     s:in std_logic;
     F:out std_logic_vector(15 downto 0));
end component;
component BranchUnit IS
PORT(Opcode:in std_logic_vector (4 downto 0);
IM1_IM2_CCR:in std_logic_vector (2 downto 0);
BranchZ:out std_logic;
BranchC:out std_logic;
Branchuncond:out std_logic
);
END component;

signal branchC_sig, branchZ_sig,Branchuncond_sig:std_logic;
signal BranchResult_sig:std_logic;

begin
ToWB:mux2x1 port map(IM1_IM2_MemOut,IM1_IM2_ALUout,IM1_IM2_RegWriteSrc,WB_value);

myBranchUnit:BranchUnit port map(
     Opcode=>Opcode,
     IM1_IM2_CCR=>IM1_IM2_CCR,
     BranchZ=>branchZ_sig,
     BranchC=>branchC_sig,
     Branchuncond=>Branchuncond_sig
     );
BranchResult_sig<=branchZ_sig or branchC_sig or Branchuncond_sig;
Rdst<=IM1_IM2_Rdst;
Reg_write_out<=IM1_IM2_RegWrite;
BranchResult<=BranchResult_sig;
branchZ<=branchZ_sig;
branchC<=branchC_sig;
BranchValue<=IM1_IM2_ALUout;

end Memory2;
