library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity stackPointerModule is
  port (
  ID_IE_SP_value: IN std_logic_vector(1 DOWNTO 0);
  Rst                     : in  std_logic;
  Clk                    : in  std_logic;
  sum : OUT std_logic_vector(15 DOWNTO 0)
  ) ;
end stackPointerModule ;

architecture arch of stackPointerModule is



    component stack is
        port (
        Rst                     : in  std_logic;--
        Clk                     : in  std_logic;
        stack_Result               : out  std_logic_vector(15 downto 0);
        addressIn : in std_logic_vector(15 downto 0)
        );
    end component ;

    component stackAdd IS
PORT( 
    old_stack : IN std_logic_vector(15 DOWNTO 0);
secondOperand: IN std_logic_vector(15 DOWNTO 0);
 sum : OUT std_logic_vector(15 DOWNTO 0)
 );
END component;

component mux4x2 is 
port(A,B,C,D: in std_logic_vector(15 downto 0);
     s:in std_logic_vector(1 downto 0);
     F:out std_logic_vector(15 downto 0));
end component;


-----------------------------


---------signals-----------
signal stack_result_sig: std_logic_vector(15 DOWNTO 0);
signal mux_result_sig: std_logic_vector(15 DOWNTO 0);
signal add_result_sig: std_logic_vector(15 DOWNTO 0);

begin
Myadd:stackAdd port map(
    old_stack=>stack_result_sig,
    secondOperand=>mux_result_sig,
    sum=>add_result_sig
);
MySP:stack port map(

Rst=>Rst,
Clk=>Clk,
stack_Result=> stack_result_sig,
addressIn=>add_result_sig
);
Mymux:mux4x2 port map(
    A=>x"0000",
    B=>"0000000000000001",
    C=>"1111111111111111",
    D=>x"0000",
    s=>ID_IE_SP_value,
    F=>mux_result_sig
);
sum<=stack_result_sig;



end architecture ; -- arch