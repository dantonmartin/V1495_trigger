library ieee;
use ieee.std_logic_1164.all;

entity FADD is
    port(L: in  std_logic;
         M: in  std_logic;
         N: in  std_logic;
         O: out std_logic;
         C: out std_logic);
end FADD;

architecture STRUCTURAL of FADD is
    component HADD is
        port(L: in  std_logic;
             M: in  std_logic;
             N: out std_logic;
             C: out std_logic);
    end component;

    signal S_L: std_logic;
    signal S_M: std_logic;
    signal S_N: std_logic;
    signal S_O: std_logic;
    signal S_C: std_logic;

    signal S_HADD1_N: std_logic;
    signal S_HADD1_C: std_logic;
    signal S_HADD2_C: std_logic;
begin
    S_L <= L;
    S_M <= M;
    S_N <= N;

    HADD1: HADD port map(L => S_L,
                         M => S_M,
                         N => S_HADD1_N,
                         C => S_HADD1_C);

    HADD2: HADD port map(L => S_N,
                         M => S_HADD1_N,
                         N => S_O,
                         C => S_HADD2_C);

    S_C <= S_HADD1_C or S_HADD2_C;

    O <= S_O;
    C <= S_C;
end STRUCTURAL;
