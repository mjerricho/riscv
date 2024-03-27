library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionMemory is
    port (
        Address     : in std_logic_vector(31 downto 0);
        instruction : out std_logic_vector(31 downto 0) 
    );
end entity InstructionMemory;

architecture behavioural of InstructionMemory is
    
    type ROM_ARRAY is array (0 to 64) of std_logic_vector(7 downto 0);
    

    
    constant ROM : ROM_ARRAY := (
        X"00", X"14", X"84", X"93", --    addi s1, s1,   1  
        X"00", X"29", X"09", X"13", --    addi s2, s2,   2   
        X"00", X"99", X"09", X"33", --    add  s2, s2,   s1 
        X"01", X"24", X"a2", X"23", --    sw   s2, 4(s1)    
        X"00", X"04", X"a4", X"83", --    lw   s1, 0(s1)    
        others => X"00"
);

begin
    instruction <= ROM(to_integer(unsigned(address) + 0)) &
                   ROM(to_integer(unsigned(address) + 1)) &
                   ROM(to_integer(unsigned(address) + 2)) &
                   ROM(to_integer(unsigned(address) + 3));
end architecture;
