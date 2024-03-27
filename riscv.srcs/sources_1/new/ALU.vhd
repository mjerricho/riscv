entity ALU is
    Port (
        operator1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
        operator2 : in STD_LOGIC_VECTOR ( 31 downto 0 );
        ALUOp : in STD_LOGIC_VECTOR ( 2 downto 0 );
        result : out STD_LOGIC_VECTOR ( 31 downto 0 );
        zero : out STD_LOGIC;
        CarryOut : out STD_LOGIC;
        signo : out STD_LOGIC
    );
end ALU;

architecture Behavioral of ALU is
    signal addition : STD_LOGIC_VECTOR ( 32 downto 0 );
begin
    addition <= ('0' & operator1) + ('0' & operator2);
    result <= addition(31 downto 0);
    CarryOut <= addition(32);
    zero <= '0';
    signo <= '0';
end Behavioral;
