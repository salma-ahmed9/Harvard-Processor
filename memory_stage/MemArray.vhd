library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MemArray is
  port (
    clk,rst            : in  std_logic;
    IE_IM1_memRead  : in  std_logic;
    IE_IM1_memWrite : in  std_logic;
    Address         : in  std_logic_vector(9 downto 0);
    writeData       : in  std_logic_vector(15 downto 0);
    Reset           : in  std_logic;
    Mem_out         : out std_logic_vector(15 downto 0)
  );
end entity MemArray;

architecture sync_ram_a of MemArray is
  type ram_type is array (0 to 1023) of std_logic_vector(15 downto 0);
  signal ram : ram_type;
begin
  process (clk, rst)
  begin
    if rst = '1' then
      ram <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if IE_IM1_memWrite = '1' then
        if to_integer(unsigned(Address)) >= 0 and to_integer(unsigned(Address)) < 1024 then
          ram(to_integer(unsigned(Address))) <= writeData;
        else
          report "MemArray: Write address out of range" severity error;
        end if;
      elsif IE_IM1_memRead = '1' then
        if to_integer(unsigned(Address)) >= 0 and to_integer(unsigned(Address)) < 1024 then
          Mem_out <= ram(to_integer(unsigned(Address)));
        else
          report "MemArray: Read address out of range" severity error;
        end if;
      end if;
    end if;
  end process;
end sync_ram_a;
