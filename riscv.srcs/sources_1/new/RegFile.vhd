
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity RegFile is
  port (
    clk     : in std_logic;
    rst     : in std_logic;
    writeReg : in std_logic;
    sourceReg1 : in std_logic_vector(4 downto 0);
    sourceReg2 : in std_logic_vector(4 downto 0);
    destinyReg : in std_logic_vector(4 downto 0);
    data : in std_logic_vector(31 downto 0);
    readData1 : out std_logic_vector(31 downto 0);
    readData2 : out std_logic_vector(31 downto 0);
    
    Data1 : out std_logic_vector(31 downto 0);
    Data2 : out std_logic_vector(31 downto 0)
  );
end RegFile;

architecture behavioral of RegFile is
    type REG_File is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal REG : REG_File;
begin

proc: process(clk, rst)
begin
    if rst = '1' then
        REG <= (others => (others => '0'));
    elsif rising_edge(clk) then
        -- read a and b
        Data1 <= REG(to_integer(unsigned(sourceReg1)));
        Data2 <= REG(to_integer(unsigned(sourceReg2)));
        if writeReg = '1' then
            --if write then data -> destination
            REG(to_integer(unsigned(destinyReg))) <= data;
            
        end if;
    end if;
end process;


end behavioral;
