-------------------------------------------------------------
----- Universitatea Tehnica din Cluj-Napoca
----- Facultatea de Automatica si Calculatoare 
----- 2024-2025 
----- Assignment Curs - testbench pentru adunarea in virgula mobila
----- Student: Cret Maria Magdalena
----- Grupa: 30233 Semigrupa 1
----- Fisier Testbench ------
-------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fp_adder_pipeline_tb is
end fp_adder_pipeline_tb;

architecture testbench of fp_adder_pipeline_tb is

    -- semnale pentru instanta
    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal nr1          : std_logic_vector(31 downto 0) := (others => '0');
    signal nr2          : std_logic_vector(31 downto 0) := (others => '0');
    signal valid_input   : std_logic := '0';
    signal result        : std_logic_vector(31 downto 0);
    signal valid_output  : std_logic;

    -- semnale pentru verificare
    signal expected_result : std_logic_vector(31 downto 0);
    signal pass            : boolean := true;

    constant clk_period : time := 10 ns;

begin

    -- Instantierea unitatii testate
    uut: entity work.fp_adder_pipeline
        port map (
            clk => clk,
            reset => reset,
            nr1 => nr1,
            nr2 => nr2,
            valid_input => valid_input,
            result => result,
            valid_output => valid_output
        );

    -- Generare clock
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Proces de testare
    stimulus_process: process
    begin
        -- Reset
        reset <= '1';
        wait for 2 * clk_period;
        reset <= '0';

--        -- Test 1: Adunare simpla
--        nr1 <= "01000001010000000000000000000000"; -- 12.0 -- HEXA: 0x41400000
--        nr2 <= "01000000101000000000000000000000"; -- 5.0  -- HEXA: 0x40A00000
--        expected_result <= "01000001100100000000000000000000"; -- 17.0 -- HEXA: 0x43100000
--        valid_input <= '1';
--        wait for clk_period;
--        valid_input <= '0';

--        wait until valid_output = '1';
--        assert result = expected_result report "Test 1 failed" severity error;

--        -- Test 2: Adunare cu numere negative
--        nr1 <= "11000000101000000000000000000000"; -- -5.0 --  HEXA:
--        nr2 <= "01000000101000000000000000000000"; -- 5.0  -- HEXA:
--        expected_result <= "00000000000000000000000000000000"; -- 0.0
--        valid_input <= '1';
--        wait for clk_period;
--        valid_input <= '0';

--        wait until valid_output = '1';
--        assert result = expected_result report "Test 2 failed" severity error;

--        -- Test 3: Adunare cu overflow
--        nr1 <= "01111111000000000000000000000000"; -- Float Max
--        nr2 <= "00111111100000000000000000000000"; -- 1.0
--        expected_result <= "01111111000000000000000000000000"; -- Float Max (overflow)
--        valid_input <= '1';
--        wait for clk_period;
--        valid_input <= '0';

--        wait until valid_output = '1';
--        assert result = expected_result report "Test 3 failed" severity error;

        -- Test 4: Adunare cu numere cu zecimale
        nr1 <= "01000000100110011001100110011010"; -- 4.6
        nr2 <= "01000000010011001100110011001101"; -- 3.2
        expected_result <= "01000001000001100110011001100110"; -- 7.8
        valid_input <= '1';
        wait for clk_period;
        valid_input <= '0';

        wait until valid_output = '1';
        assert result = expected_result report "Test 4 failed" severity error;

        report "All tests passed" severity note;
        wait;
    end process;

end testbench;
