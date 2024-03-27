library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ProgramCounter is
    port (
        PCIn    : in std_logic_vector(31 downto 0);
        clk     : in std_logic;
        rst     : in std_logic;
        PCOut   : out std_logic_vector(31 downto 0)
    );
end entity ProgramCounter;

architecture arch of ProgramCounter is

begin
    process( clk, rst)
    begin
        if rst = '1' then
            PCOut <= (others => '0');
        else
            if rising_edge(clk) then        
                    PCOut <= PCIn;
            end if;
        end if;
    end process ;
end arch;