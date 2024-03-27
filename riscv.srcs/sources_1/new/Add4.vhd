library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Add4 is
    port (
        PC       : in std_logic_vector(31 downto 0);
        NextPC   : out std_logic_vector(31 downto 0)
    );
end Add4;

architecture arch of Add4 is
begin
    NextPC <= PC + 4;     
end arch;
