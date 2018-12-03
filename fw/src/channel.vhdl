library ieee;
use ieee.std_logic_1164.all;

entity CHANNEL is
    generic(G_WDTH: integer := 8);
    port(I_CLK:   in  std_logic;
         I_RST:   in  std_logic;
         I_WDTH:  in  std_logic_vector((G_WDTH - 1) downto 0);
         I_DATA:  in  std_logic;
         O_PULSE: out std_logic);
end CHANNEL;

architecture STRUCTURAL of CHANNEL is
    component EDETR is
        generic(WD: integer);
        port(CK:   in  std_logic;
             SIG:  in  std_logic_vector((WD - 1) downto 0);
             RISE: out std_logic_vector((WD - 1) downto 0);
             FALL: out std_logic_vector((WD - 1) downto 0));
    end component;

    component PULSEGENERATOR is
        generic(G_WDTH: integer);
        port(I_CLK:   in  std_logic;
             I_RST:   in  std_logic;
             I_WDTH:  in  std_logic_vector((G_WDTH - 1) downto 0);
             I_TRIG:  in  std_logic;
             O_PULSE: out std_logic);
    end component;

    signal S_CLK:   std_logic;
    signal S_RST:   std_logic;
    signal S_WDTH:  std_logic_vector((G_WDTH - 1) downto 0);
    signal S_DATA:  std_logic;
    signal S_PULSE: std_logic;

    signal S_TRIG: std_logic;
begin
    S_CLK  <= I_CLK;
    S_RST  <= I_RST;
    S_WDTH <= I_WDTH;
    S_DATA <= I_DATA;

    THR_DETECTOR: EDETR generic map(WD => 1)
                        port map(CK      => S_CLK,
                                 SIG(0)  => S_DATA,
                                 RISE(0) => S_TRIG,
                                 FALL    => open);

    COIN_WINDOW: PULSEGENERATOR generic map(G_WDTH => G_WDTH)
                                port map(I_CLK   => S_CLK,
                                         I_RST   => S_RST,
                                         I_WDTH  => S_WDTH,
                                         I_TRIG  => S_TRIG,
                                         O_PULSE => S_PULSE);

    O_PULSE <= S_PULSE;
end STRUCTURAL;
