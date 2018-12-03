library ieee;
use ieee.std_logic_1164.all;

library lpm;
use lpm.lpm_components.all;

entity NSYNC is
    generic(PL_WD: integer := 2;
            WD:    integer := 32);
    port(CK: in  std_logic;
         D:  in  std_logic_vector((WD - 1) downto 0);
         Q:  out std_logic_vector((WD - 1) downto 0));
end NSYNC;

architecture STRUCTURAL of NSYNC is
    component lpm_ff is
        generic(LPM_FFTYPE: string;
                LPM_WIDTH:  integer);
        port(clock: in  std_logic;
             data:  in  std_logic_vector((LPM_WIDTH - 1) downto 0);
             q:     out std_logic_vector((LPM_WIDTH - 1) downto 0));
    end component;

    type PLD is array (0 to PL_WD) of std_logic_vector((WD - 1) downto 0);

    signal S_CK: std_logic;
    signal S_D:  PLD;
begin
    S_CK   <= CK;
    S_D(0) <= D;

    GEN_NSYNC: for I in 0 to (PL_WD - 1) generate
        REGX: lpm_ff generic map(LPM_FFTYPE => "DFF",
                                 LPM_WIDTH  => WD)
                     port map(clock => S_CK,
                              data  => S_D(I),
                              q     => S_D(I + 1));
    end generate GEN_NSYNC;

    Q <= S_D(PL_WD);
end STRUCTURAL;
