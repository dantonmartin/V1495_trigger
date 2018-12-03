library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lpm;
use lpm.lpm_components.all;

entity ADDN is
    generic(WD: integer := 4);
    port(CK: in  std_logic;
         L:  in  std_logic_vector((WD - 1) downto 0);
         M:  in  std_logic_vector((WD - 1) downto 0);
         N:  out std_logic_vector(WD downto 0));
end ADDN;

architecture BEHAVIORAL of ADDN is
    component lpm_ff is
        generic(LPM_FFTYPE: string;
                LPM_WIDTH:  integer);
        port(clock: in  std_logic;
             data:  in  std_logic_vector((LPM_WIDTH - 1) downto 0);
             q:     out std_logic_vector((LPM_WIDTH - 1) downto 0));
    end component;

    signal S_CK: std_logic;
    signal S_L:  unsigned(WD downto 0);
    signal S_M:  unsigned(WD downto 0);
    signal S_N:  std_logic_vector(WD downto 0);

    signal S_T: std_logic_vector(WD downto 0);
begin
    S_CK <= CK;
    S_L  <= resize(unsigned(L), WD + 1);
    S_M  <= resize(unsigned(M), WD + 1);

    S_T <= std_logic_vector(S_L + S_M);

    REG: lpm_ff generic map(LPM_FFTYPE => "DFF",
                            LPM_WIDTH  => WD + 1)
                port map(clock => S_CK,
                         data  => S_T,
                         q     => S_N);

    N <= S_N;
end BEHAVIORAL;
