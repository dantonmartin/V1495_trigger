library ieee;
use ieee.std_logic_1164.all;

entity HADD is
    port(L: in  std_logic;
         M: in  std_logic;
         N: out std_logic;
         C: out std_logic);
end HADD;

architecture STRUCTURAL of HADD is
    signal S_L: std_logic;
    signal S_M: std_logic;
    signal S_N: std_logic;
    signal S_C: std_logic;
begin
    S_L <= L;
    S_M <= M;

    S_N <= S_L xor S_M;
    S_C <= S_L and S_M;

    N <= S_N;
    C <= S_C;
end;
