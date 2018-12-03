library ieee;
use ieee.std_logic_1164.all;

library lpm;
use lpm.lpm_components.all;

entity EDETR is
    generic(WD: integer := 32);
    port(CK:   in  std_logic;
         SIG:  in  std_logic_vector((WD - 1) downto 0);
         RISE: out std_logic_vector((WD - 1) downto 0);
         FALL: out std_logic_vector((WD - 1) downto 0));
end EDETR;

architecture STRUCTURAL of EDETR is
    component lpm_ff is
        generic(LPM_FFTYPE: string;
                LPM_WIDTH:  integer);
        port(clock: in  std_logic;
             data:  in  std_logic_vector((LPM_WIDTH - 1) downto 0);
             q:     out std_logic_vector((LPM_WIDTH - 1) downto 0));
    end component;

    signal S_CK:   std_logic;
    signal S_SIG:  std_logic_vector((WD - 1) downto 0);
    signal S_RISE: std_logic_vector((WD - 1) downto 0);
    signal S_FALL: std_logic_vector((WD - 1) downto 0);

    signal S_SIG_t2: std_logic_vector((WD - 1) downto 0);
    signal S_SIG_t1: std_logic_vector((WD - 1) downto 0);

    signal S_PRISE: std_logic_vector((WD - 1) downto 0);
    signal S_PFALL: std_logic_vector((WD - 1) downto 0);
begin
    S_CK  <= CK;
    S_SIG <= SIG;

    DTFF_t2: lpm_ff generic map(LPM_FFTYPE => "DFF",
                                LPM_WIDTH  => WD)
                    port map(clock => S_CK,
                             data  => S_SIG,
                             q     => S_SIG_t2);

    DTFF_t1: lpm_ff generic map(LPM_FFTYPE => "DFF",
                                LPM_WIDTH  => WD)
                    port map(clock => S_CK,
                             data  => S_SIG_t2,
                             q     => S_SIG_t1);

    S_PRISE <= S_SIG_t2 and (not S_SIG_t1);
    S_PFALL <= S_SIG_t1 and (not S_SIG_t2);

    DTFF_RISE: lpm_ff generic map(LPM_FFTYPE => "DFF",
                                  LPM_WIDTH  => WD)
                      port map(clock => S_CK,
                               data  => S_PRISE,
                               q     => S_RISE);

    DTFF_FALL: lpm_ff generic map(LPM_FFTYPE => "DFF",
                                  LPM_WIDTH  => WD)
                      port map(clock => S_CK,
                               data  => S_PFALL,
                               q     => S_FALL);

    RISE <= S_RISE;
    FALL <= S_FALL;
end STRUCTURAL;
