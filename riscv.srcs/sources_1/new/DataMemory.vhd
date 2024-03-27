library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- DataMemory is a RAM
-- Reset active-high
entity DataMemory is
    port (
        clk         :in std_logic;
        rst         :in std_logic;
        writeEnable :in std_logic;
        Address     :in std_logic_vector(31 downto 0);
        dataIn      :in std_logic_vector(31 downto 0);
        dataOut     :out std_logic_vector(31 downto 0)
    );
end entity DataMemory;

architecture behavioural of DataMemory is

    type RAM_T is array (15 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : RAM_T := (others => (others => '0'));
begin
process(clk, rst)
    begin
        if rst = '1' then
            RAM <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if (writeEnable = '1') then
                RAM(to_integer(unsigned(address) + 0)) <= dataIn(7 downto 0);
                RAM(to_integer(unsigned(address) + 1)) <= dataIn(15 downto 8);
                RAM(to_integer(unsigned(address) + 2)) <= dataIn(23 downto 16);
                RAM(to_integer(unsigned(address) + 3)) <= dataIn(31 downto 24);
            end if;
    end if;
    end process;
    
    dataOut <= RAM(to_integer(unsigned(address) + 3)) & 
               RAM(to_integer(unsigned(address) + 2)) &
               RAM(to_integer(unsigned(address) + 1)) & 
               RAM(to_integer(unsigned(address) + 0)); 

end architecture;