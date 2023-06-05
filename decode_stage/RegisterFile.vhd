LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY RegisterFile IS
PORT (clk ,rst: IN std_logic;
 readAddress1:in std_logic_vector (2 downto 0);
 readAddress2:in std_logic_vector (2 downto 0);
 writeAddress:in std_logic_vector (2 downto 0);
 writeData:in std_logic_vector(15 downto 0);
 RegWrite:in std_logic;
 ReadData1:out std_logic_vector(15 downto 0);
 ReadData2:out std_logic_vector (15 downto 0)
);
END ENTITY;

ARCHITECTURE sync_ram_a OF RegisterFile IS
 TYPE ram_type IS ARRAY(0 TO 7) of std_logic_vector(15 DOWNTO 0);
 SIGNAL ram : ram_type ;
BEGIN
PROCESS(clk,rst) IS
BEGIN
	if rst = '1' THEN
		ram <= (others => (others=> '0'));
	elsIF rising_edge(clk) THEN
		IF RegWrite = '1' THEN
			ram(to_integer(unsigned((writeAddress)))) <= writeData;
		END IF;
	END IF;
END PROCESS;
ReadData1<=ram(to_integer(unsigned(readAddress1)));
ReadData2<=ram(to_integer(unsigned(readAddress2)));

END sync_ram_a;
