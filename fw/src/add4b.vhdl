library ieee;
use ieee.std_logic_1164.all;

library lpm;
use lpm.lpm_components.all;

entity ADD4B is
    port(CK: in  std_logic;
         L:  in  std_logic;
         M:  in  std_logic;
         N:  in  std_logic;
         O:  in  std_logic;
         P:  out std_logic_vector(2 downto 0));
end ADD4B;

architecture STRUCTURAL of ADD4B is
    component HADD is
        port(L: in  std_logic;
             M: in  std_logic;
             N: out std_logic;
             C: out std_logic);
    end component;

    component FADD is
        port(L: in  std_logic;
             M: in  std_logic;
             N: in  std_logic;
             O: out std_logic;
             C: out std_logic);
    end component;

    component lpm_ff is
        generic(LPM_FFTYPE: string;
                LPM_WIDTH:  integer);
        port(clock: in  std_logic;
             data:  in  std_logic_vector((LPM_WIDTH - 1) downto 0);
             q:     out std_logic_vector((LPM_WIDTH - 1) downto 0));
    end component;

    signal S_CK: std_logic;
    signal S_L:  std_logic;
    signal S_M:  std_logic;
    signal S_N:  std_logic;
    signal S_O:  std_logic;
    signal S_P:  std_logic_vector(2 downto 0);

    signal S_HADD1_N: std_logic;
    signal S_HADD1_C: std_logic;

    signal S_HADD2_N: std_logic;
    signal S_HADD2_C: std_logic;

    signal S_HADD3_N: std_logic;
    signal S_HADD3_C: std_logic;

    signal S_FADD1_O: std_logic;
    signal S_FADD1_C: std_logic;
begin
    S_CK <= CK;
    S_L  <= L;
    S_M  <= M;
    S_N  <= N;
    S_O  <= O;

    HADD1: HADD port map(L => S_L,
                         M => S_M,
                         N => S_HADD1_N,
                         C => S_HADD1_C);

    HADD2: HADD port map(L => S_N,
                         M => S_O,
                         N => S_HADD2_N,
                         C => S_HADD2_C);

    HADD3: HADD port map(L => S_HADD1_N,
                         M => S_HADD2_N,
                         N => S_HADD3_N,
                         C => S_HADD3_C);

    FADD1: FADD port map(L => S_HADD1_C,
                         M => S_HADD2_C,
                         N => S_HADD3_C,
                         O => S_FADD1_O,
                         C => S_FADD1_C);

    REG: lpm_ff generic map(LPM_FFTYPE => "DFF",
                            LPM_WIDTH  => 3)
                port map(clock   => S_CK,
                         data(2) => S_FADD1_C,
                         data(1) => S_FADD1_O,
                         data(0) => S_HADD3_N,
                         q       => S_P);

    P <= S_P;
end STRUCTURAL;
