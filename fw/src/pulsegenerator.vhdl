library ieee;
use ieee.std_logic_1164.all;

library lpm;
use lpm.lpm_components.all;

entity PULSEGENERATOR is
    generic(G_WDTH: integer := 32);
    port(I_CLK:   in  std_logic;
         I_RST:   in  std_logic;
         I_WDTH:  in  std_logic_vector((G_WDTH - 1) downto 0);
         I_TRIG:  in  std_logic;
         O_PULSE: out std_logic);
end PULSEGENERATOR;

architecture STRUCTURAL of PULSEGENERATOR is
    component DCOUNT is
        generic(G_WDTH: integer);
        port(I_CLK:  in  std_logic;
             I_RST:  in  std_logic;
             I_LD:   in  std_logic;
             I_EN:   in  std_logic;
             I_DATA: in  std_logic_vector((G_WDTH - 1) downto 0);
             O_DATA: out std_logic_vector((G_WDTH - 1) downto 0));
    end component;

    component lpm_compare is
        generic(LPM_REPRESENTATION:    string;
                LPM_WIDTH:             integer;
                ONE_INPUT_IS_CONSTANT: string);
        port(dataa: in  std_logic_vector((LPM_WIDTH - 1) downto 0);
             datab: in  std_logic_vector((LPM_WIDTH - 1) downto 0);
             aneb:  out std_logic);
    end component;

    signal S_CLK:   std_logic;
    signal S_RST:   std_logic;
    signal S_WDTH:  std_logic_vector((G_WDTH - 1) downto 0);
    signal S_TRIG:  std_logic;
    signal S_PULSE: std_logic;

    signal S_GENERATOR_CNTR_LD:   std_logic;
    signal S_GENERATOR_CNTR_EN:   std_logic;
    signal S_GENERATOR_CNTR_DATA: std_logic_vector((G_WDTH - 1) downto 0);

    constant C_ZEROES: std_logic_vector(S_GENERATOR_CNTR_DATA'range) := (others => '0');
begin
    S_CLK  <= I_CLK;
    S_RST  <= I_RST;
    S_WDTH <= I_WDTH;
    S_TRIG <= I_TRIG;

    S_GENERATOR_CNTR_EN <= S_PULSE;

    GENERATOR: DCOUNT generic map(G_WDTH => G_WDTH)
                      port map(I_CLK  => S_CLK,
                               I_RST  => S_RST,
                               I_LD   => S_TRIG,
                               I_EN   => S_GENERATOR_CNTR_EN,
                               I_DATA => S_WDTH,
                               O_DATA => S_GENERATOR_CNTR_DATA);

    COMP: lpm_compare generic map(LPM_REPRESENTATION    => "UNSIGNED",
                                  LPM_WIDTH             => G_WDTH,
                                  ONE_INPUT_IS_CONSTANT => "YES")
                      port map(dataa => S_GENERATOR_CNTR_DATA,
                               datab => C_ZEROES,
                               aneb  => S_PULSE);

    O_PULSE <= S_PULSE;
end STRUCTURAL;
