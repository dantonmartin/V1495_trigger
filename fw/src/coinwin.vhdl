library ieee;
use ieee.std_logic_1164.all;

entity COINWIN is
    generic(G_WDTH:   integer := 8;
            G_NCHANS: integer := 32);
    port(I_CLK:   in  std_logic;
         I_RST:   in  std_logic;
         I_WDTH:  in  std_logic_vector((G_WDTH - 1) downto 0);
         I_DATA:  in  std_logic_vector((G_NCHANS - 1) downto 0);
         O_PULSE: out std_logic_vector((G_NCHANS - 1) downto 0));
end COINWIN;

architecture STRUCTURAL of COINWIN is
    component CHANNEL is
        generic(G_WDTH: integer);
        port(I_CLK:   in  std_logic;
             I_RST:   in  std_logic;
             I_WDTH:  in  std_logic_vector((G_WDTH - 1) downto 0);
             I_DATA:  in  std_logic;
             O_PULSE: out std_logic);
    end component;

    signal S_CLK:   std_logic;
    signal S_RST:   std_logic;
    signal S_WDTH:  std_logic_vector((G_WDTH - 1) downto 0);
    signal S_DATA:  std_logic_vector((G_NCHANS - 1) downto 0);
    signal S_PULSE: std_logic_vector((G_NCHANS - 1) downto 0);
begin
    S_CLK  <= I_CLK;
    S_RST  <= I_RST;
    S_WDTH <= I_WDTH;
    S_DATA <= I_DATA;

    GEN_COINWIN: for I in 0 to (G_NCHANS - 1) generate
        CHX: CHANNEL generic map(G_WDTH => G_WDTH)
                     port map(I_CLK   => S_CLK,
                              I_RST   => S_RST,
                              I_WDTH  => S_WDTH,
                              I_DATA  => S_DATA(I),
                              O_PULSE => S_PULSE(I));
    end generate GEN_COINWIN;

    O_PULSE <= S_PULSE;
end STRUCTURAL;
