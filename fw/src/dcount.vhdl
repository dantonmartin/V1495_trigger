library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DCOUNT is
    generic(G_WDTH: integer := 16);
    port(I_CLK:  in  std_logic;
         I_RST:  in  std_logic;
         I_LD:   in  std_logic;
         I_EN:   in  std_logic;
         I_DATA: in  std_logic_vector((G_WDTH - 1) downto 0);
         O_DATA: out std_logic_vector((G_WDTH - 1) downto 0));
end DCOUNT;

architecture BEHAVIORAL of DCOUNT is
    signal S_DATA: std_logic_vector((G_WDTH - 1) downto 0) := (others => '0');
begin
    process(I_CLK)
    begin
        if(rising_edge(I_CLK)) then
            if(I_RST = '1') then
                S_DATA <= (others => '0');
            elsif(I_LD = '1') then
                S_DATA <= I_DATA;
            elsif(I_EN = '1') then
                S_DATA <= S_DATA - '1';
            end if;
        end if;
    end process;
    
    O_DATA <= S_DATA;
end BEHAVIORAL;
