-------------------------------------------------------------
----- Universitatea Tehnica din Cluj-Napoca
----- Facultatea de Automatica si Calculatoare 
----- 2024-2025 
----- Assignment Curs - testbench pentru adunarea in virgula mobila
----- Student: Cret Maria Magdalena
----- Grupa: 30233 Semigrupa 1
----- Fisier Implementare Floating Adder Pipeline ------
-------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fp_adder_pipeline is
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        nr1        : in  std_logic_vector(31 downto 0);  
        nr2        : in  std_logic_vector(31 downto 0);  
        valid_input: in  std_logic;
        result     : out std_logic_vector(31 downto 0);
        valid_output: out std_logic
    );
end fp_adder_pipeline;

architecture pipeline of fp_adder_pipeline is

    constant EXPONENT_BITS : integer := 8;
    constant MANTISSA_BITS : integer := 23;

    subtype sign_type is std_logic;
    subtype exp_type is unsigned(EXPONENT_BITS-1 downto 0);
    subtype mantissa_type is unsigned(MANTISSA_BITS downto 0);
    subtype sum_type is unsigned(MANTISSA_BITS+2 downto 0);

    -- Semnale pentru etape
    signal stage1_sign_array : sign_type;
    signal stage1_exp_array  : exp_type;
    signal stage1_mant_array : mantissa_type;
    signal stage1_valid      : std_logic;

    signal stage2_larger_exp : exp_type;
    signal stage2_larger_mant: mantissa_type;
    signal stage2_smaller_mant: mantissa_type;
    signal stage2_exp_diff   : integer;
    signal stage2_valid      : std_logic;

    signal stage3_sign       : sign_type;
    signal stage3_sum        : sum_type;
    signal stage3_exp        : exp_type;
    signal stage3_valid      : std_logic;

    signal stage4_mant_norm  : mantissa_type;
    signal stage4_exp_norm   : exp_type;
    signal stage4_sign       : sign_type;
    signal stage4_valid      : std_logic;

begin

    -- Etapa 1: Extrage semnul, exponentul si mantisa
    process(clk, reset)
    begin
        if reset = '1' then
            stage1_valid <= '0';
        elsif rising_edge(clk) then
            stage1_sign_array <= nr1(31);
            stage1_exp_array <= unsigned(nr1(30 downto 23));
            stage1_mant_array <= "1" & unsigned(nr1(22 downto 0)); -- Adaugarea bitului ascuns
            stage1_valid <= valid_input;
        end if;
    end process;

    -- Etapa 2: Alinierea mantiselor
    process(clk, reset)
    begin
        if reset = '1' then
            stage2_valid <= '0';
        elsif rising_edge(clk) then
            if stage1_exp_array >= unsigned(nr2(30 downto 23)) then
                stage2_larger_exp <= stage1_exp_array;
                stage2_larger_mant <= stage1_mant_array;
                stage2_smaller_mant <= "1" & unsigned(nr2(22 downto 0));
                stage2_exp_diff <= to_integer(stage1_exp_array - unsigned(nr2(30 downto 23)));
            else
                stage2_larger_exp <= unsigned(nr2(30 downto 23));
                stage2_larger_mant <= "1" & unsigned(nr2(22 downto 0));
                stage2_smaller_mant <= stage1_mant_array;
                stage2_exp_diff <= to_integer(unsigned(nr2(30 downto 23)) - stage1_exp_array);
            end if;
            stage2_valid <= stage1_valid;
        end if;
    end process;

    -- Etapa 3: Adunare sau scadere mantise
    process(clk, reset)
    variable smaller_mant_shifted : mantissa_type;
    begin
        if reset = '1' then
            stage3_valid <= '0';
        elsif rising_edge(clk) then
            if stage2_exp_diff > 0 then
                smaller_mant_shifted := shift_right(stage2_smaller_mant, stage2_exp_diff);
            else
                smaller_mant_shifted := stage2_smaller_mant;
            end if;

            if stage1_sign_array = nr2(31) then
                -- Semne egale, adunare
                stage3_sum <= resize(stage2_larger_mant, MANTISSA_BITS+3) + resize(smaller_mant_shifted, MANTISSA_BITS+3);
                stage3_sign <= stage1_sign_array;
            else
                -- Semne diferite, scadere
                stage3_sum <= resize(stage2_larger_mant, MANTISSA_BITS+3) - resize(smaller_mant_shifted, MANTISSA_BITS+3);
                -- Semnul se pastreaza de la mantisa mai mare
                stage3_sign <= stage2_larger_mant(MANTISSA_BITS);  
            end if;

            stage3_exp <= stage2_larger_exp;
            stage3_valid <= stage2_valid;
        end if;
    end process;

    -- Etapa 4: Normalizare
    process(clk, reset)
    begin
        if reset = '1' then
            stage4_valid <= '0';
        elsif rising_edge(clk) then
            if stage3_sum(MANTISSA_BITS+2) = '1' then
                stage4_mant_norm <= stage3_sum(MANTISSA_BITS+1 downto 1);  -- Mutare mantisa pentru normalizare
                stage4_exp_norm <= stage3_exp + 1;
            else
                stage4_mant_norm <= stage3_sum(MANTISSA_BITS downto 0);
                stage4_exp_norm <= stage3_exp;
            end if;

            stage4_sign <= stage3_sign;
            stage4_valid <= stage3_valid;
        end if;
    end process;

    -- Rezultat final
    process(clk, reset)
    begin
        if reset = '1' then
            result <= (others => '0');
            valid_output <= '0';
        elsif rising_edge(clk) then
            if stage4_valid = '1' then
                result <= stage4_sign & std_logic_vector(stage4_exp_norm) &
                          std_logic_vector(stage4_mant_norm(MANTISSA_BITS-1 downto 0));
                valid_output <= '1';
            else
                valid_output <= '0';
            end if;
        end if;
    end process;

end pipeline;
