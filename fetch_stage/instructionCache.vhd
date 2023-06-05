LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY instructionCache IS
	PORT(
		address : IN  std_logic_vector(15 DOWNTO 0);
		memZero : OUT  std_logic_vector(31 DOWNTO 0);
		memOne : OUT  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY instructionCache;

ARCHITECTURE syncmemory_array_rega OF instructionCache IS

	TYPE instructionCache_type IS ARRAY(0 TO 65535) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL instructionCache : instructionCache_type ;
    constant ZERO_ADDRESS : std_logic_vector(15 downto 0) := (others => '0');
	constant ONE_ADDRESS : std_logic_vector(15 downto 0) :="0000000000000001";
    
	BEGIN
	    memOne<=instructionCache(to_integer(unsigned(ONE_ADDRESS)));
	    memZero <= instructionCache(to_integer(unsigned(ZERO_ADDRESS)));
		dataout <= instructionCache(to_integer(unsigned(address)));
END syncmemory_array_rega;