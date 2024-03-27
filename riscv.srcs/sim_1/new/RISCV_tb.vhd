library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.finish;

entity RISCV_tb is
end RISCV_tb;



architecture Behavioral of RISCV_tb is

   constant clk_period : time := 10 ns;
   
      component InstructionMemory is
      port (
        Address : in STD_LOGIC_VECTOR ( 31 downto 0 );
        instruction : out STD_LOGIC_VECTOR ( 31 downto 0 )
      );
      end component;
      
        component DataMemory is
      port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        writeEnable : in STD_LOGIC;
        Address : in STD_LOGIC_VECTOR ( 31 downto 0 );
        dataIn : in STD_LOGIC_VECTOR ( 31 downto 0 );
        dataOut : out STD_LOGIC_VECTOR ( 31 downto 0 )
      );
      end component;
      
       component RISCV is
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
      end component;
      
    signal clk :  STD_LOGIC := '0';
    signal rst :  STD_LOGIC := '0';
    
    signal Instruction_Address :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal instruction_Data    :  STD_LOGIC_VECTOR ( 31 downto 0 );
    
    signal Data_writeEnable :  STD_LOGIC;
    signal Data_Address     :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal Data_dataIn      :  STD_LOGIC_VECTOR ( 31 downto 0 );
    signal Data_dataOut     :  STD_LOGIC_VECTOR ( 31 downto 0 );
  
begin

clk <= not clk after clk_period / 2;

DataMemory_0: DataMemory
     port map (
      Address(31 downto 0) => Data_Address,
      clk => clk,
      dataIn(31 downto 0) => Data_dataIn(31 downto 0),
      dataOut(31 downto 0) => Data_dataOut(31 downto 0),
      rst => rst,
      writeEnable => Data_writeEnable
    );
    
InstructionMemory_0: InstructionMemory
     port map (
      Address(31 downto 0) => Instruction_Address(31 downto 0),
      instruction(31 downto 0) => Instruction_Data(31 downto 0)
    );

DUT: RISCV 
  port map (
    clk => clk,
    rst => rst,
    Instruction_Address => Instruction_Address,
    instruction_Data => instruction_Data,
    Data_writeEnable => Data_writeEnable,
    Data_Address => Data_Address,
    Data_dataIn => Data_dataIn,
    Data_dataOut => Data_dataOut
  );

  tb_process :process
   begin
        -- Reset the system
        report "Reset the system.";
        rst <= '1';
        wait for 4 * clk_period;
        
        report "Start the system.";
        rst <= '0';
        wait for clk_period / 2;
        

        -- First cycle, check value fetched.
        report "Testing sequence." ;
        
        assert instruction_Address = X"00000000" report "CPU PC incorrect" severity error;
        assert instruction_Data = X"00148493" report "ROM content doesnt match expectation." severity error;
        wait for clk_period;
        
        assert instruction_Address = X"00000004" report "CPU PC incorrect" severity error;
        assert instruction_Data = X"00290913" report "ROM content doesnt match expectation." severity error;
        wait for clk_period;
        
        assert instruction_Address = X"00000008" report "CPU PC incorrect" severity error;
        assert instruction_Data = X"00990933" report "ROM content doesnt match expectation." severity error;
        wait for clk_period;
        
        assert instruction_Address = X"0000000C" report "CPU PC incorrect" severity error;
        assert instruction_Data = X"0124a223" report "ROM content doesnt match expectation." severity error;
        assert data_address = X"00000005" report "Address incorect for instruction sw" severity error;
        wait for clk_period;
        
        assert instruction_Address = X"00000010" report "CPU PC incorrect" severity error;
        assert instruction_Data = X"0004a483" report "ROM content doesnt match expectation." severity error;
        assert data_address = X"00000001" report "Address incorect for instruction lw" severity error;
        wait for clk_period;
        
        finish;
   end process;



  
end Behavioral;
