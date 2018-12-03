library ieee;
use ieee.std_logic_1164.all;

entity ADD32B is
    port(CK: in  std_logic;
         L:  in  std_logic_vector(31 downto 0);
         P:  out std_logic_vector(5 downto 0));
end ADD32B;

architecture STRUCTURAL of ADD32B is
    component ADD4B is
        port(CK: in  std_logic;
             L:  in  std_logic;
             M:  in  std_logic;
             N:  in  std_logic;
             O:  in  std_logic;
             P:  out std_logic_vector(2 downto 0));
    end component;

    component ADDN is
        generic(WD: integer := 4);
        port(CK: in  std_logic;
             L:  in  std_logic_vector((WD - 1) downto 0);
             M:  in  std_logic_vector((WD - 1) downto 0);
             N:  out std_logic_vector(WD downto 0));
    end component;

    signal S_CK: std_logic;
    signal S_L:  std_logic_vector(31 downto 0);
    signal S_P:  std_logic_vector(5 downto 0);

    signal S_ADD4B1_P: std_logic_vector(2 downto 0);
    signal S_ADD4B2_P: std_logic_vector(2 downto 0);
    signal S_ADD4B3_P: std_logic_vector(2 downto 0);
    signal S_ADD4B4_P: std_logic_vector(2 downto 0);
    signal S_ADD4B5_P: std_logic_vector(2 downto 0);
    signal S_ADD4B6_P: std_logic_vector(2 downto 0);
    signal S_ADD4B7_P: std_logic_vector(2 downto 0);
    signal S_ADD4B8_P: std_logic_vector(2 downto 0);

    signal S_ADD31_N: std_logic_vector(3 downto 0);
    signal S_ADD32_N: std_logic_vector(3 downto 0);
    signal S_ADD33_N: std_logic_vector(3 downto 0);
    signal S_ADD34_N: std_logic_vector(3 downto 0);

    signal S_ADD41_N: std_logic_vector(4 downto 0);
    signal S_ADD42_N: std_logic_vector(4 downto 0);

    signal S_ADD5_N: std_logic_vector(5 downto 0);
begin
    S_CK <= CK;
    S_L  <= L;

    ADD4B1: ADD4B port map(CK => S_CK,
                           L  => S_L(0),
                           M  => S_L(1),
                           N  => S_L(2),
                           O  => S_L(3),
                           P  => S_ADD4B1_P);

    ADD4B2: ADD4B port map(CK => S_CK,
                           L  => S_L(4),
                           M  => S_L(5),
                           N  => S_L(6),
                           O  => S_L(7),
                           P  => S_ADD4B2_P);

    ADD4B3: ADD4B port map(CK => S_CK,
                           L  => S_L(8),
                           M  => S_L(9),
                           N  => S_L(10),
                           O  => S_L(11),
                           P  => S_ADD4B3_P);

    ADD4B4: ADD4B port map(CK => S_CK,
                           L  => S_L(12),
                           M  => S_L(13),
                           N  => S_L(14),
                           O  => S_L(15),
                           P  => S_ADD4B4_P);

    ADD4B5: ADD4B port map(CK => S_CK,
                           L  => S_L(16),
                           M  => S_L(17),
                           N  => S_L(18),
                           O  => S_L(19),
                           P  => S_ADD4B5_P);

    ADD4B6: ADD4B port map(CK => S_CK,
                           L  => S_L(20),
                           M  => S_L(21),
                           N  => S_L(22),
                           O  => S_L(23),
                           P  => S_ADD4B6_P);

    ADD4B7: ADD4B port map(CK => S_CK,
                           L  => S_L(24),
                           M  => S_L(25),
                           N  => S_L(26),
                           O  => S_L(27),
                           P  => S_ADD4B7_P);

    ADD4B8: ADD4B port map(CK => S_CK,
                           L  => S_L(28),
                           M  => S_L(29),
                           N  => S_L(30),
                           O  => S_L(31),
                           P  => S_ADD4B8_P);

    ADD31: ADDN generic map(WD => 3)
                port map(CK => S_CK,
                         L  => S_ADD4B1_P,
                         M  => S_ADD4B2_P,
                         N  => S_ADD31_N);

    ADD32: ADDN generic map(WD => 3)
                port map(CK => S_CK,
                         L  => S_ADD4B3_P,
                         M  => S_ADD4B4_P,
                         N  => S_ADD32_N);

    ADD33: ADDN generic map(WD => 3)
                port map(CK => S_CK,
                         L  => S_ADD4B5_P,
                         M  => S_ADD4B6_P,
                         N  => S_ADD33_N);

    ADD34: ADDN generic map(WD => 3)
                port map(CK => S_CK,
                         L  => S_ADD4B7_P,
                         M  => S_ADD4B8_P,
                         N  => S_ADD34_N);

    ADD41: ADDN generic map(WD => 4)
                port map(CK => S_CK,
                         L  => S_ADD31_N,
                         M  => S_ADD32_N,
                         N  => S_ADD41_N);

    ADD42: ADDN generic map(WD => 4)
                port map(CK => S_CK,
                         L  => S_ADD33_N,
                         M  => S_ADD34_N,
                         N  => S_ADD42_N);

    ADD5: ADDN generic map(WD => 5)
               port map(CK => S_CK,
                        L  => S_ADD41_N,
                        M  => S_ADD42_N,
                        N  => S_P);
    P <= S_P;
end STRUCTURAL;
