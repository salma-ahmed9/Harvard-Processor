library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity execute_stage is 
port(
    Clk_module: IN std_logic;
    Rst_module: IN std_logic;
    inPort_module:IN std_logic_vector(15 DOWNTO 0);
    controlSingals_module:IN std_logic_vector(16 DOWNTO 0);
    Rdst_module:IN std_logic_vector(2 DOWNTO 0);
    Rs_module: IN std_logic_vector(15 DOWNTO 0);
    Rt_module: IN std_logic_vector(15 DOWNTO 0);
    immediate_module:IN std_logic_vector(15 DOWNTO 0);
    IE_IM1_Rdst:out std_logic_vector(2 downto 0);
    IE_IM1_Rsrc2_data:out std_logic_vector(15 downto 0);
    IE_IM1_ALU_out:out std_logic_vector(15 downto 0);
    new_PC_out:out std_logic_vector (15 downto 0);
    CCR_out:out std_logic_vector(2 downto 0);
    controlSingals_Outmodule:OUT std_logic_vector(16 DOWNTO 0);
    WB_value : in std_logic_vector(15 downto 0);
    M1_M2_aluout: in std_logic_vector(15 downto 0);
    FU_operand1 : out std_logic_vector (1 downto 0);
    FU_operand2 : out std_logic_vector (1 downto 0);
    ID_IE_OPcode: in std_logic_vector (4 downto 0);
    IE_IM1_OPcode: out std_logic_vector (4 downto 0);
    branch_zero : in std_logic;
    branch_carry : in std_logic;
    DE_RS : in std_logic_vector(2 downto 0);
    DE_RT :in std_logic_vector(2 downto 0);
    WB_RD : in std_logic_vector(2 downto 0);
    M1M2_RD :in std_logic_vector(2 downto 0);
    M1M2_regwrite : in std_logic;
    WB_regwrite : in std_logic;
    newPC_in: in std_logic_vector (15 downto 0);
    IE_IM1_Rst:in std_logic;
    --sp
    SP_rst:in std_logic;
    ID_IE_SP_value: IN std_logic_vector(1 DOWNTO 0);

    outport : out std_logic_vector (15 downto 0);
    IE_IM1_sp: OUT std_logic_vector (15 downto 0);
    
    IM1_IM2_memread: in std_logic;
    IM1_IM2_memwrite: in std_logic;
    Freeze_ID_IE:out std_logic;
    Freeze_PC:out std_logic;
    Freeze_IF_ID:  out std_logic

);
end;


--Control signals
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

architecture Myarch of execute_stage is

    component stackPointerModule is
        port (
        ID_IE_SP_value: IN std_logic_vector(1 DOWNTO 0);
        Rst                     : in  std_logic;
        Clk                    : in  std_logic;
        sum : OUT std_logic_vector(15 DOWNTO 0)
        ) ;
      end component ;

component Execute_Memory1_buffer is
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
    end component;


    component mux_1_exstage is 
port (
Rsc1,Inport,imm : in std_logic_vector(15 downto 0);
alu_operand_1 : in std_logic_vector (1 downto 0);
alu_in_1 : out std_logic_vector(15 downto 0)
);
end component;


component mux_2_exstage is 
port (
Rsc2,imm : in std_logic_vector(15 downto 0);
alu_operand_2 : in std_logic ;
alu_in_2 : out std_logic_vector(15 downto 0)
);
end component;

component CCR_unit is 
port (
D_E_opcode : in std_logic_vector (4 downto 0 );
clrflag,setflag:out std_logic
);
end component;

component CCR is 
port (
Clk: in std_logic;
rst : in std_logic;
alu_c,alu_z, alu_n : in std_logic;
clcflag , setcflag : in std_logic;
branch_z : in std_logic;
branch_c : in std_logic;
ccr_out : out std_logic_vector (2 downto 0)
);
end component;

component OutUnit is
    port(
    DE_opcode :in std_logic_vector (4 downto 0);
    ALU_out : in std_logic_vector(15 downto 0);
    out_port : out std_logic_vector (15 downto 0)
    );
end component;

component ALU is 
port (
alu_in_1 , alu_in_2 : in std_logic_vector (15 downto 0);
alu_opcode :in std_logic_vector (2 downto 0 );
alu_out : out std_logic_vector (15 downto 0 );
carry_flag,zero_flag,negative_flag : out std_logic
);
end component;

component mux4x2 is 
port(A,B,C,D: in std_logic_vector(15 downto 0);
     s:in std_logic_vector(1 downto 0);
     F:out std_logic_vector(15 downto 0));
end component;

component FU is 
port(
DE_Rs,DE_Rt,EM1_Rd,WB_Rd,M1M2_Rd : in std_logic_vector(2 downto 0);
EM1_regw,M1M2_regw,WB_regw : in std_logic ;
EM1_memread : in std_logic;
FU_selector1,FU_selector2 : out std_logic_vector(1 downto 0)
);
end component;

component MHU is
    port (ID_IE_memread,ID_IE_memwrite,IM1_IM2_memread,IM1_IM2_memwrite,IE_IM1_memread,IE_IM1_memwrite:in std_logic;
    Freeze_ID_IE,Freeze_PC,Freeze_IF_ID,zero_cs:out std_logic
    );
end component;


signal pcaddress : std_logic_vector(15 downto 0);
------------------------ signals --------------------------
signal aluin1: std_logic_vector(15 downto 0);
signal aluin2: std_logic_vector(15 downto 0);
signal aluout : std_logic_vector(15 downto 0);
signal ccroutin : std_logic_vector (2 downto 0);
signal ccrout_out : std_logic_vector (2 downto 0);
signal mux_fu1_out: std_logic_vector(15 downto 0);
signal mux_fu2_out: std_logic_vector(15 downto 0);
signal clrflagsignal : std_logic;
signal setflagsignal :std_logic;
signal carryflag : std_logic;
signal negativeflag:std_logic;
signal zeroflag:std_logic;
signal fu_oper1 : std_logic_vector (1 downto 0);
signal fu_oper2 : std_logic_vector (1 downto 0);
signal IE_IM1_Rst_sig:std_logic;
-----------------------------------------------------------
---bufferouts
signal IE_IM1_Rsrc2_sig:std_logic_vector(15 downto 0);
signal IE_IM1_ALU_out_sig:std_logic_vector(15 downto 0);
signal IE_IM1_Rdst_sig:std_logic_vector(2 downto 0);
signal IE_IM1_new_PC_sig:std_logic_vector (15 downto 0);
signal IE_IM1_CCR_sig:std_logic_vector (2 downto 0);
signal IE_IM1_PC_out:std_logic_vector(15 downto 0);
signal IE_IM1_ControlSignals_SIG:std_logic_vector(16 downto 0);

---sp out sig
signal SPOut:std_logic_vector(15 downto 0);

--Zero Control Signals
signal zero_csIEM1_sig:std_logic;


begin
    IE_IM1_Rsrc2_data<=IE_IM1_Rsrc2_sig;
    CCR_out<=ccrout_out;
    new_PC_out<="0000000000000000";
    IE_IM1_ALU_out<=IE_IM1_ALU_out_sig;
    IE_IM1_Rdst<=IE_IM1_Rdst_sig;
    controlSingals_Outmodule<=IE_IM1_ControlSignals_SIG;
    IE_IM1_Rst_sig<= Rst_module or IE_IM1_Rst or zero_csIEM1_sig;


Mysp :stackPointerModule port map(
Rst=>SP_rst,
Clk=>Clk_module,
ID_IE_SP_value=>ID_IE_SP_value,
sum=>SPOut

);

myMemHzU: MHU port map(
ID_IE_memread=>controlSingals_module(10),
ID_IE_memwrite=>controlSingals_module(9),
IM1_IM2_memread=>IM1_IM2_memread,
IM1_IM2_memwrite=>IM1_IM2_memwrite,
IE_IM1_memread=>IE_IM1_ControlSignals_SIG(10),
IE_IM1_memwrite=>IE_IM1_ControlSignals_SIG(9),
Freeze_ID_IE=>Freeze_ID_IE,
Freeze_PC=>Freeze_PC,
Freeze_IF_ID=>Freeze_IF_ID,
zero_cs=>zero_csIEM1_sig
);


myfu : FU port map (
DE_Rs=>DE_RS,
DE_Rt=>DE_RT,
EM1_Rd=>IE_IM1_Rdst_sig,
WB_Rd=>WB_RD,
M1M2_Rd=>M1M2_RD,
EM1_regw=>IE_IM1_ControlSignals_SIG(6),
M1M2_regw=> M1M2_regwrite,
WB_regw=>WB_regwrite,
EM1_memread=>IE_IM1_ControlSignals_SIG(10),
FU_selector1=>fu_oper1,
FU_selector2=>fu_oper2
);
mux1: mux_1_exstage port map ( Rsc1=>Rs_module,
Inport=>inPort_module,
imm=>immediate_module,
alu_operand_1=>controlSingals_module(13 downto 12),
alu_in_1=> aluin1 );

mux2: mux_2_exstage port map (Rsc2=>Rt_module,
imm=>immediate_module,
alu_operand_2=>controlSingals_module(11),
alu_in_2=>aluin2);

mux_fu1: mux4x2 port map (A=>aluin1,
B=>IE_IM1_ALU_out_sig,
C=>WB_value,
D=>M1_M2_aluout,
s=>fu_oper1,
F=>mux_fu1_out
);

mux_fu2: mux4x2 port map (A=>aluin2,
B=>IE_IM1_ALU_out_sig,
C=>WB_value,
D=>M1_M2_aluout,
s=>fu_oper2,
F=>mux_fu2_out
);

myalu: ALU port map(alu_in_1=>mux_fu1_out,
alu_in_2=>mux_fu2_out,
alu_opcode=>controlSingals_module(16 downto 14),
alu_out=>aluout,
carry_flag=>carryflag,
zero_flag=>zeroflag,
negative_flag=>negativeflag);

myccrunit : CCR_unit port map (
 D_E_opcode=>ID_IE_OPcode,
 clrflag=>clrflagsignal,
 setflag=>setflagsignal
);
myccr : CCR port map (
Clk=>Clk_module,
rst=>Rst_module,
alu_c=>carryflag,
alu_z=>zeroflag,
alu_n=>negativeflag,
clcflag=>clrflagsignal,
setcflag=>setflagsignal,
branch_z=> branch_zero,
branch_c=> branch_carry,
ccr_out=>ccroutin
);

myoutunit :OutUnit port map(
DE_opcode=>ID_IE_OPcode,
ALU_out=>aluout,
out_port=>outport
);

executemem: Execute_Memory1_buffer port map (CLK=>Clk_module,
Rdst=>Rdst_module,  --Rdst
Rscr2_data=>mux_fu2_out, --Rsrc2
CCR=>ccroutin,--ccrin
CCR_out=>ccrout_out, --ccrout
ALU_out=>aluout, --aluout
IE_IM1_Rst=>IE_IM1_Rst_sig, --rst
--out
new_PC_out=>new_PC_out,
IE_IM1_Rsrc2_data=>IE_IM1_Rsrc2_sig,
IE_IM1_ALU_out=>IE_IM1_ALU_out_sig,
IE_IM1_Rdst=>IE_IM1_Rdst_sig,
controlSignals=>controlSingals_module,
IE_IM1_controlSignals=>IE_IM1_ControlSignals_SIG,
ID_IE_OPcode=>ID_IE_OPcode,
IE_IM1_Opcode=>IE_IM1_Opcode,
new_PC=>newPC_in,
SP_IN=>SPOut, --sp
IE_IM1_sp=>IE_IM1_sp,
Freeze=>'0'
);

end Myarch ; 