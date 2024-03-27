library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
    -- width of instruction (opcode)
    port ( opcode : in std_logic_vector(6 downto 0);
           f3, f7, zero : in std_logic;
           PCSrc, ALUSrc, MemWrite,ResultSrc, ALUControl, RegWrite: out std_logic );
end ControlUnit;

architecture behavior of ControlUnit is
begin
    -- fixed values for PCSrc, ALUControl and RegWrite
    PCSrc <= '0';
    ALUControl <= "000";
    RegWrite <= '1';

    -- main decoder logic
    process (opcode)
    begin
        case opcode is
            when "0110011" =>  -- ADD rd rs1 rs2
                ALUSrc <= '0';
                MemWrite <= '0';
                ResultSrc <= '0';
            when "0010011" =>  -- ADDI rd rs1 + imm
                ALUSrc <= '1';
                MemWrite <= '0';
                ResultSrc <= '0';
            when "0100011" =>  -- sw s2, 4(s1)
                ALUSrc <= '0';
                MemWrite <= '1';
                ResultSrc <= '0';
            when "0000011" =>  -- lw s1 0(s1)
                ALUSrc <= '0';
                MemWrite <= '0';
                ResultSrc <= '1';
        end case;
    end process;
end behavior;
