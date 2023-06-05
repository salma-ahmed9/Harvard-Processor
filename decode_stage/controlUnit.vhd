LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
entity controlUnit is
  port (

  -- Clk:IN std_logic;
  -- rst:IN std_logic;
  -- RESET_IN:IN std_logic;
  Opcode:IN std_logic_vector(4 DOWNTO 0);
  needJump:IN std_logic;
  HDU_freezPC:IN std_logic;
  intr_freezePC:IN std_logic;
  Reset_SP:IN std_logic;


--Sync outputs
ALU_OpCode:out std_logic_vector(2 DOWNTO 0);
ALU_Operand_1:out std_logic_vector(1 DOWNTO 0);
ALU_Operand_2:out std_logic;
MemRead:out std_logic;
MemWrite:out std_logic;
MemAddress:out std_logic;
MemData:out std_logic;
RegWriteSrc:out std_logic;
RegWrite:out std_logic;
needsTwoOps: out std_logic;
SP_value:out std_logic_vector(1 DOWNTO 0);


--Async 
branch_Result:in std_logic;
PC_Decision:out std_logic_vector(1 DOWNTO 0);
freez_PC: out std_logic;
--flush
IF_ID_Rst:out std_logic;    
ID_IE_Rst:out std_logic;    
IE_IM1_Rst:out std_logic;    
IM1_IM2_Rst:out std_logic
    
  ) ;
end controlUnit ;




architecture arch of controlUnit is

  
  begin

    -- most likely must be changed to accomodate for other cases ?
    IF_ID_Rst<=branch_Result;
    ID_IE_Rst<=branch_Result;
    IE_IM1_Rst<=branch_Result;
    -- IM1_IM2_Rst<=branch_Result;
    IM1_IM2_Rst<='0';
    --WHEN is it 00????? 
    --11 at RET, RTI, CALL. 10 at JZ, JC, JMP
    -- 10 at JZ, JC, JMP
    -- PC_Decision<="11" WHEN Opcode="11010" OR Opcode="11100" OR Opcode="11000"
    -- ELSE "10" WHEN Opcode="10001" OR Opcode="10010" OR Opcode="10011"
    -- ELSE "01"; 
    --accomodate for reset later
    PC_Decision<="10" WHEN branch_Result='1'
    ELSE "01"; 


    -- PC_Decision<= "01"; --hardcoded
    
    
    -- ALU_OpCode <= "010"  WHEN Opcode="00010" --inc
    -- ELSE "110" WHEN OPcode="00110" --add
    -- ELSE "000";
    -- ALU_Operand_1<="00" WHEN Opcode="00010" 
    -- ELSE "01" WHEN Opcode="10110" --in
    -- ELSE "00";

     -- total is 17
    -- Reg_ALU_opcode_sig is (16 downto 14)
    -- Reg_ALU_operand1_sig is (13 downto 12)
    -- Reg_ALU_operand2_sig is (11)
    -- Reg_MemRead_sig is (10)
    -- Reg_MemWrite_sig is (9)
    -- Reg_MemAddress_sig is (8)
    -- Reg_MemData_sig is (7)
    -- Reg_RegWrite_sig is (6)
    -- Reg_RegWriteSrc_sig is (5)
    -- needsTwoOps_sig is (4)
    -- SP_value_sig is (3 downto 2)
    -- PC_Decision_sig is (1 downto 0)

    ALU_OpCode <= Opcode(2 downto 0)  WHEN Opcode(4 downto 3)="00" --R type
    ELSE "100" WHEN OPcode="01001" --IADD
    ELSE "000";

    ALU_Operand_1<="10" WHEN Opcode="01000" --LDM 
    ELSE "01" WHEN Opcode="10110" --IN
    ELSE "00";

    ALU_Operand_2<='1' WHEN Opcode="01001" --IADD
    else '0'; 


    --LDD --RET --RTI --POP
    MemRead<='1' WHEN Opcode="01010" OR Opcode="11010" OR Opcode="11100" OR  Opcode="11011"
    ELSE '0';
    --STD --CALL --PUSH
    MemWrite<='1' WHEN Opcode="01011"  OR Opcode="11000" OR Opcode="11001"
    ELSE '0';
    -- 1 when base is 11 
    MemAddress<= '1' WHEN Opcode(4 downto 3) ="11" 
    ELSE '0'; 

    -- 1 when call 
    MemData<='1' WHEN Opcode="11000" 
    ELSE '0';  

    -- 1 when r type or LDM or Iadd or IN else 0
    RegWriteSrc<='1' WHEN Opcode(4 downto 3)="00"  OR Opcode= "01000" OR Opcode="10110" or Opcode="01001"
    ELSE '0';


    -- 1 when r type or LDM or Iadd or LDD or IN or POP else 0
    -- 1 when r type 
    RegWrite<='1' WHEN Opcode(4 downto 3)="00" OR Opcode= "01000" OR Opcode="10110" OR Opcode="01001" OR Opcode="01010" OR Opcode="11011"
    ELSE '0';

    --01 at POP, RET, RTI
    SP_value<="01" WHEN Opcode="11011" OR Opcode="11010" OR Opcode="11100"
    ELSE "10" WHEN Opcode="11001" --PUSH
    ELSE "00";
    

    

    -- 1 at ADD, SUB, AND, OR, LDD ,STD 
    needsTwoOps <='1' WHEN Opcode="00100" Or Opcode="00101" Or Opcode="00110" Or Opcode="00111" Or Opcode="01010" Or Opcode="01011"
    ELSE '0';
    
    freez_PC<='1' WHEN needJump='0' AND (HDU_freezPC='1' OR intr_freezePC='1')
    ELSE '0';
    
    -- --Async 
        
    -- --flush
    -- IF_ID_Rst:out std_logic;    
    -- ID_IE_Rst:out std_logic;    
    -- IE_IM1_Rst:out std_logic;    
    -- IM1_IM2_Rst:out std_logic; 
    -- Reset_SP:IN std_logic




end architecture ; -- arch
