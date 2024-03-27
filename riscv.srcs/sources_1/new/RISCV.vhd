library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RISCV is
  port (
  
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    
    Instruction_Address : out STD_LOGIC_VECTOR ( 31 downto 0 );
    instruction_Data    : in STD_LOGIC_VECTOR ( 31 downto 0 );
    
    Data_writeEnable : out STD_LOGIC;
    Data_Address     : out STD_LOGIC_VECTOR ( 31 downto 0 );
    Data_dataIn      : out STD_LOGIC_VECTOR ( 31 downto 0 );
    Data_dataOut     : in STD_LOGIC_VECTOR ( 31 downto 0 )
    
  );
end RISCV;

architecture structural of RISCV is
  
  component mux is 
  port (muxIn0 : in STD_LOGIC_VECTOR(31 downto 0);
           muxIn1 : in STD_LOGIC_VECTOR(31 downto 0);
           selector : in STD_LOGIC;
           muxOut : out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  
  component ProgramCounter is
  port (
    PCIn : in STD_LOGIC_VECTOR ( 31 downto 0 );
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    PCOut : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component;
  
  component RegFile is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    writeReg : in STD_LOGIC;
    sourceReg1 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    sourceReg2 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    destinyReg : in STD_LOGIC_VECTOR ( 4 downto 0 );
    data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    readData1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    readData2 : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component;
  
  component ImmediateGenerator is
  port (
    instruction : in STD_LOGIC_VECTOR ( 31 downto 0 );
    immediate : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component;
  
  component ALU is
  port (
    operator1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    operator2 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    ALUOp     : in STD_LOGIC_VECTOR ( 2 downto 0 );
    result    : out STD_LOGIC_VECTOR ( 31 downto 0 );
    zero      : out STD_LOGIC;
    carryOut  : out STD_LOGIC;
    signo     : out STD_LOGIC
  );
  end component;
  
  component Add4 is
  port (
    PC     : in STD_LOGIC_VECTOR ( 31 downto 0 );
    NextPC : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component;
  
  component Adder is
  port (
    X : in STD_LOGIC_VECTOR ( 31 downto 0 );
    Y : in STD_LOGIC_VECTOR ( 31 downto 0 );
    Sum : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component;
  
  component ControlUnit is
  port (
    opcode : in STD_LOGIC_VECTOR ( 6 downto 0 );
    funct3 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    funct7 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    zero : in STD_LOGIC;
    PCSrc : out STD_LOGIC;
    ResultSrc : out STD_LOGIC;
    MemWrite : out STD_LOGIC;
    ALUSrc : out STD_LOGIC;
    ALUControl : out STD_LOGIC_VECTOR ( 2 downto 0 );
    RegWrite : out STD_LOGIC
  );
  end component;
  
  
  signal ALUresult : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal zero : STD_LOGIC;
  signal PCPlus4 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NewPC : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ALUControl : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ALUSrc : STD_LOGIC;
  signal MemWrite : STD_LOGIC;
  signal PCSrc : STD_LOGIC;
  signal RegWrite : STD_LOGIC;
  signal ResultSrc : STD_LOGIC;
  signal ReadData : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal immediate : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal instruction : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal operand2 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal result : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NextPC : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal PCOut : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal readData1 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal readData2 : STD_LOGIC_VECTOR ( 31 downto 0 );
  
  -- Decode informations
  signal sourceReg1 : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal sourceReg2: STD_LOGIC_VECTOR ( 4 downto 0 );
  signal targetReg : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal opcode : STD_LOGIC_VECTOR ( 6 downto 0 );
  signal funct3 : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal funct7 : STD_LOGIC_VECTOR ( 6 downto 0 );
  
  
      
      
  signal NLW_ALU32_0_carryOut_UNCONNECTED : STD_LOGIC;
  signal NLW_ALU32_0_signo_UNCONNECTED : STD_LOGIC;
begin

  Data_Address(31 downto 0) <= ALUresult(31 downto 0);
  Data_dataIn(31 downto 0) <= readData2(31 downto 0);
  ReadData(31 downto 0) <= Data_dataOut(31 downto 0) ;
      
  Data_writeEnable <= MemWrite;
  Instruction_Address(31 downto 0) <= PCOut(31 downto 0);
  instruction(31 downto 0) <= Instruction_Data(31 downto 0);
    
    
 -- Decode the instruction
   
 funct7 <= instruction (31 downto 25);
 sourceReg2 <= instruction (24 downto 20);
 sourceReg1 <= instruction (19 downto 15);
 funct3 <= instruction (14 downto 12);
 targetReg <= instruction (11 downto 7); 
 opcode <= instruction (6 downto 0);   
    

    
    
ALU32_0: component ALU
     port map (
      ALUOp(2 downto 0) => ALUControl(2 downto 0),
      carryOut => NLW_ALU32_0_carryOut_UNCONNECTED,
      operator1(31 downto 0) => readData1(31 downto 0),
      operator2(31 downto 0) => operand2(31 downto 0),
      result(31 downto 0) => ALUresult(31 downto 0),
      signo => NLW_ALU32_0_signo_UNCONNECTED,
      zero => zero
    );
Add4_0: component Add4
     port map (
      NextPC(31 downto 0) => PCPlus4(31 downto 0),
      PC(31 downto 0) => PCOut(31 downto 0)
    );
Adder_0: Adder
     port map (
      Sum(31 downto 0) => NewPC(31 downto 0),
      X(31 downto 0) => immediate(31 downto 0),
      Y(31 downto 0) => PCOut(31 downto 0)
    );
ControlUnit_0: component ControlUnit
     port map (
      ALUControl(2 downto 0) => ALUControl(2 downto 0),
      ALUSrc => ALUSrc,
      MemWrite => MemWrite,
      PCSrc => PCSrc,
      RegWrite => RegWrite,
      ResultSrc => ResultSrc,
      funct3(2 downto 0) => funct3(2 downto 0),
      funct7(6 downto 0) => funct7(6 downto 0),
      opcode(6 downto 0) => opcode(6 downto 0),
      zero => zero
    );
ImmediateGenerator_0: component ImmediateGenerator
     port map (
      immediate(31 downto 0) => immediate(31 downto 0),
      instruction(31 downto 0) => instruction(31 downto 0)
    );
Multiplexer_operand2: component mux
     port map (
      muxIn0(31 downto 0) => readData2(31 downto 0),
      muxIn1(31 downto 0) => immediate(31 downto 0),
      muxOut(31 downto 0) => operand2(31 downto 0),
      selector => ALUSrc
    );
Multiplexer_result: component mux
     port map (
      muxIn0(31 downto 0) => ALUresult(31 downto 0),
      muxIn1(31 downto 0) => ReadData(31 downto 0),
      muxOut(31 downto 0) => result(31 downto 0),
      selector => ResultSrc
    );
Multiplexer_NextPC: component mux
     port map (
      muxIn0(31 downto 0) => PCPlus4(31 downto 0),
      muxIn1(31 downto 0) => NewPC(31 downto 0),
      muxOut(31 downto 0) => NextPC(31 downto 0),
      selector => PCSrc
    );
ProgramCounter_0: component ProgramCounter
     port map (
      PCIn(31 downto 0) => NextPC(31 downto 0),
      PCOut(31 downto 0) => PCOut(31 downto 0),
      clk => clk,
      rst => rst
    );
RegisterFile_0: component RegFile
     port map (
      clk => clk,
      data(31 downto 0) => result(31 downto 0),
      destinyReg(4 downto 0) => targetReg(4 downto 0),
      readData1(31 downto 0) => readData1(31 downto 0),
      readData2(31 downto 0) => readData2(31 downto 0),
      rst => rst,
      sourceReg1(4 downto 0) => sourceReg1(4 downto 0),
      sourceReg2(4 downto 0) => sourceReg2(4 downto 0),
      writeReg => RegWrite
    );

end architecture;
