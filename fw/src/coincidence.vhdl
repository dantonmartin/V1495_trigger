library ieee;
use ieee.std_logic_1164.all;

library lpm;
use lpm.lpm_components.all;

entity COINCIDENCE is
    port(I_CLK:     in  std_logic;
         I_COINVAL: in  std_logic_vector(5 downto 0);
         I_COINWIN: in  std_logic_vector(31 downto 0);
         O_PULSE:   out std_logic);
end COINCIDENCE;

architecture STRUCTURAL of COINCIDENCE is
    component ADD32B is
        port(CK: in  std_logic;
             L:  in  std_logic_vector(31 downto 0);
             P:  out std_logic_vector(5 downto 0));
    end component;

    component lpm_ff is
        generic(LPM_FFTYPE: string;
                LPM_WIDTH:  integer);
        port(clock: in  std_logic;
             data:  in  std_logic_vector((LPM_WIDTH - 1) downto 0);
             q:     out std_logic_vector((LPM_WIDTH - 1) downto 0));
    end component;

    component lpm_compare is
        generic(LPM_REPRESENTATION: string;
                LPM_WIDTH:          integer);
        port(dataa: in  std_logic_vector((LPM_WIDTH - 1) downto 0);
             datab: in  std_logic_vector((LPM_WIDTH - 1) downto 0);
             agb:   out std_logic);
    end component;

    component EDETR is
        generic(WD: integer);
        port(CK:   in  std_logic;
             SIG:  in  std_logic_vector((WD - 1) downto 0);
             RISE: out std_logic_vector((WD - 1) downto 0);
             FALL: out std_logic_vector((WD - 1) downto 0));
    end component;

    signal S_CLK:     std_logic;
    signal S_COINVAL: std_logic_vector(5 downto 0);
    signal S_COINWIN: std_logic_vector(31 downto 0);
    signal S_PULSE:   std_logic;

    signal S_ADD32: std_logic_vector(5 downto 0);

    signal S_COIN: std_logic;
begin
    S_CLK     <= I_CLK;
    S_COINVAL <= I_COINVAL;
    S_COINWIN <= I_COINWIN;

    ADD: ADD32B port map(CK => S_CLK,
                         L  => S_COINWIN,
                         P  => S_ADD32);

    COINCOMPARE: lpm_compare generic map(LPM_REPRESENTATION => "UNSIGNED",
                                         LPM_WIDTH          => 6)
                             port map(dataa => S_ADD32,
                                      datab => S_COINVAL,
                                      agb   => S_COIN);

    EDGE: EDETR generic map(WD => 1)
                port map(CK      => S_CLK,
                         SIG(0)  => S_COIN,
                         RISE(0) => S_PULSE,
                         FALL    => open);

    O_PULSE <= S_PULSE;
end STRUCTURAL;
