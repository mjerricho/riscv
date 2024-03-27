library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux is
    Port ( muxIn0 : in STD_LOGIC_VECTOR(31 downto 0);
           muxIn1 : in STD_LOGIC_VECTOR(31 downto 0);
           selector : in STD_LOGIC;
           muxOut : out STD_LOGIC_VECTOR(31 downto 0));
end mux;

architecture Behavioral of mux is
begin
    muxOut <= muxIn0 when selector = '0' else muxIn1;
end Behavioral;