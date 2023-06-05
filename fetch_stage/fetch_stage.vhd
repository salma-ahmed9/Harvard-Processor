library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity fetch_stage is 
port(
    Clk_module: IN std_logic;
    Rst_module: IN std_logic;
    inPCDecision_module:IN std_logic_vector(1 DOWNTO 0);
    inPort_module:IN std_logic_vector(15 DOWNTO 0);
    inPort_outModule : out std_logic_vector(15 DOWNTO 0);--will move out side the module
    instruction_outModule : out std_logic_vector(31 DOWNTO 0); --instruction passed outside the module
    new_PC:OUT std_logic_vector(15 DOWNTO 0);
    IF_ID_reset:IN std_logic;
    branchResult:IN std_logic_vector(15 DOWNTO 0);
    PC_freeze: in std_logic;
    IF_ID_freeze: in std_logic
);
end;

-------components

architecture Myarch of fetch_stage is

    component PC IS
    PORT( freeze                  : in  std_logic;
    Rst                     : in  std_logic;
    Clk                     : in  std_logic;
    interuptSig             : in  std_logic;
    PC_Result               : in  std_logic_vector(15 downto 0);
    memZero                 : in  std_logic_vector(31 downto 0);
    memOne                 : in  std_logic_vector(31 downto 0);
    instructionCacheAddress : out std_logic_vector(15 downto 0);
    old_PC                  : out std_logic_vector(15 downto 0)
    );
    
    END component;

component add IS
PORT( old_PC : IN std_logic_vector(15 DOWNTO 0);
 sum : OUT std_logic_vector(15 DOWNTO 0));
END component;


component mux4x2 is     
port(A,B,C,D: in std_logic_vector(15 downto 0);
     s:in std_logic_vector(1 downto 0);
     F:out std_logic_vector(15 downto 0));
end component;

component instructionCache IS
	PORT(
		address : IN  std_logic_vector(15 DOWNTO 0);
        memZero : OUT  std_logic_vector(31 DOWNTO 0);
        memOne  : OUT  std_logic_vector(31 downto 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END component ;

component fetchDecodeReg is
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
  end component ;

  component branchResultReg is
    port(
    CLK:in std_logic;
    branchRes_in:in std_logic_vector (15 downto 0);
    branchRes_out:out std_logic_vector (15 downto 0);
    freeze:IN std_logic
    
    );
    end component;

    component PCDecisionReg is
        port(
        CLK:in std_logic;
        PCDec_in:in std_logic_vector (1 downto 0);
        PCDec_out:out std_logic_vector (1 downto 0);
        freeze:IN std_logic
        
        );
        end component;

-----------------------------


---------signals-----------
--pc
signal pc_result_sig: std_logic_vector(15 DOWNTO 0);
signal old_PC_sig: std_logic_vector(15 DOWNTO 0);
signal memZero_sig: std_logic_vector(31 DOWNTO 0);
signal memOne_sig: std_logic_vector(31 DOWNTO 0);
signal instructionCacheAddress_sig: std_logic_vector(15 DOWNTO 0);
signal PC_freeze_sig: std_logic;
signal freeze_sig: std_logic;

--add
signal new_PC_sig: std_logic_vector(15 DOWNTO 0);
signal IF_ID_newPC_sig: std_logic_vector(15 DOWNTO 0);


--mux
-- signal PC_Decison: std_logic_vector(1 DOWNTO 0);
--old pc
--new pc
-- signal branchResult_sig: std_logic_vector(15 DOWNTO 0);
signal M1_M2_MemOut_sig: std_logic_vector(15 DOWNTO 0);
signal intructionOut: std_logic_vector(31 DOWNTO 0);




--fetch decode reg
signal freeze_fetchDecodeReg_sig: std_logic;
signal RegResetSig: std_logic;
------------------------------------------
--Branch Result reg
signal branchResult_sig: std_logic_vector(15 downto 0);
signal PCDecision_sig: std_logic_vector(1 downto 0);

begin
    PC_freeze_sig<=PC_freeze;
    myBranchResultReg:branchResultReg port map(
        CLK=>Clk_module,
        branchRes_in=>branchResult,
        branchRes_out=>branchResult_sig,
        freeze=>freeze_sig
    );

    myPCDReg:PCDecisionReg port map(
        CLK=>Clk_module,
        PCDec_in=>inPCDecision_module,
        PCDec_out=>PCDecision_sig,
        freeze=>freeze_sig
    );
    RegResetSig<=IF_ID_reset or Rst_module;
    MyPC:PC port map(
        freeze=>PC_freeze_sig,
        Rst=>Rst_module,
        Clk=>Clk_module,
        interuptSig=>'0',
        PC_Result=>pc_result_sig,
        memZero=>memZero_sig,
        memOne=>memOne_sig,
        instructionCacheAddress=>instructionCacheAddress_sig,
        old_PC=>old_PC_sig
    ); 
    Myadd:add port map(
        old_pc=>old_PC_sig,
        sum=>new_PC_sig
    );

    Mymux:mux4x2 port map(
        A=>old_PC_sig,
        B=>new_PC_sig,
        C=>branchResult_sig,
        D=>M1_M2_MemOut_sig,
        s=>PCDecision_sig,
        F=>pc_result_sig
    );

    MyinstructionCache:instructionCache port map(
        address=>instructionCacheAddress_sig,
        memZero=>memZero_sig,
        memOne=>memOne_sig,
        dataout =>intructionOut
    );

    MyfetchDecodeReg:fetchDecodeReg port map(
        Clk=>Clk_module,
        freeze=>IF_ID_freeze,
        rst=>RegResetSig,
        inPort =>inPort_module ,
        instruction => intructionOut,
        inPort_passed =>inPort_outModule ,
        instruction_passed => instruction_outModule,
        newPC_in=>new_PC_sig,
        newPC=>IF_ID_newPC_sig

    );
    freeze_sig<='0';
    new_PC<=IF_ID_newPC_sig;


end Myarch ; 