library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RISCV is
port (
clk : in STD_LOGIC;
rst : in STD_LOGIC;
      Instruction_Address : out STD_LOGIC_VECTOR ( 31 downto 0 );
        instruction_Data    : in STD_LOGIC_VECTOR ( 31 downto 0 );
        
        Data_writeEnable : out STD_LOGIC;
        Data_Address : out STD_LOGIC_VECTOR ( 31 downto 0 );
        Data_dataIn  : out STD_LOGIC_VECTOR ( 31 downto 0 );
        Data_dataOut : in STD_LOGIC_VECTOR ( 31 downto 0 )
  
);
end entity;

architecture behavioural of RISCV is
begin
end architecture;