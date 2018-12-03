library ieee;
use ieee.std_logic_1164.all;

entity V1495_trigger is
    port(OSC: in std_logic;
         -----------------------
         -- Front Panel Ports --
         -----------------------
         PORT_A:    in    std_logic_vector(31 downto 0); -- (32 x LVDS/ECL)
         PORT_B:    in    std_logic_vector(31 downto 0); -- (32 x LVDS/ECL)
         PORT_C:    out   std_logic_vector(31 downto 0); -- (32 LVDS)
         PORT_D:    inout std_logic_vector(31 downto 0); -- (I/O Expansion)
         PORT_E:    inout std_logic_vector(31 downto 0); -- (I/O Expansion)
         PORT_F:    inout std_logic_vector(31 downto 0); -- (I/O Expansion)
         PORT_GIN:  in    std_logic_vector(1 downto 0);  -- LEMO (2 x NIM/TTL)
         PORT_GOUT: out   std_logic_vector(1 downto 0);  -- LEMO (2 x NIM/TTL)

         ------------------------------------
         -- Front Panel Port Output Enable --
         -- Output: 0                      --
         -- Input:  1                      --
         ------------------------------------
         PORT_D_nOE: out std_logic;
         PORT_E_nOE: out std_logic;
         PORT_F_nOE: out std_logic;
         PORT_G_nOE: out std_logic;

         -----------------------------------
         -- Front Panel Port Level Select --
         -- NIM: 0                        --
         -- TTL: 1                        --
         -----------------------------------
         PORT_D_SEL: out std_logic; -- For A395 D
         PORT_E_SEL: out std_logic; -- For A395 D
         PORT_F_SEL: out std_logic; -- For A395 D
         PORT_G_SEL: out std_logic;

         -------------------------------------
         -- Front Panel Port Identifier     --
         -- A395A: 000 (32 x In LVDS/ECL)   --
         -- A395B: 001 (32 x Out LVDS)      --
         -- A395C: 010 (32 x Out ECL)       --
         -- A395D: 011 (8 x In/Out NIM/TTL) --
         -------------------------------------
         PORT_D_ID: in std_logic_vector(2 downto 0);
         PORT_E_ID: in std_logic_vector(2 downto 0);
         PORT_F_ID: in std_logic_vector(2 downto 0);

         ---------------------------------------------------------
         -- Delay Lines                                         --
         -- Programmable Delay Line: 0-1 (Step = 0.25 ns / FSR) --
         -- Free Running Delay Line: 2-3 (Fixed delay)          --
         -- Step = 0.25 ns / FSR = 64 ns?                       --
         ---------------------------------------------------------
         DL_PULSE:     in    std_logic_vector(3 downto 0);
         FDL_nSTART:   out   std_logic_vector(3 downto 2);
         PDL_START:    out   std_logic_vector(1 downto 0);
         PDL_DLY:      inout std_logic_vector(7 downto 0);
         PDL_DLY0:     out   std_logic;
         PDL_DLY1:     out   std_logic;
         PDL_DIR:      out   std_logic;
         PDL_DLY0_nOE: out   std_logic;
         PDL_DLY1_nOE: out   std_logic;

         -----------------
         -- LED Drivers --
         -- On:  0      --
         -- Off: 1      --
         -----------------
         LEDG_Off: out std_logic; -- Green LED
         LEDR_Off: out std_logic; -- Red LED

         ---------------------
         -- VME Bus Signals --
         ---------------------
         VMEBUSnRST: in    std_logic;
         VMEBUSnBLT: in    std_logic;
         VMEBUSWnR:  in    std_logic;
         VMEBUSnADS: in    std_logic;
         VMEBUSnRDY: out   std_logic;
         VMEBUSDATA: inout std_logic_vector(15 downto 0));
end V1495_trigger;

architecture STRUCTURAL of V1495_trigger is
    component pll is
        port(inclk0: in  std_logic;
             c0:     out std_logic;
             locked: out std_logic);
    end component;

    component NSYNC is
        generic(PL_WD: integer;
                WD:    integer);
        port(CK: in  std_logic;
             D:  in  std_logic_vector((WD - 1) downto 0);
             Q:  out std_logic_vector((WD - 1) downto 0));
    end component;

    component COINWIN is
        generic(G_WDTH:   integer;
                G_NCHANS: integer);
        port(I_CLK:   in  std_logic;
             I_RST:   in  std_logic;
             I_WDTH:  in  std_logic_vector((G_WDTH - 1) downto 0);
             I_DATA:  in  std_logic_vector((G_NCHANS - 1) downto 0);
             O_PULSE: out std_logic_vector((G_NCHANS - 1) downto 0));
    end component;

    component COINCIDENCE is
        port(I_CLK:     in  std_logic;
             I_COINVAL: in  std_logic_vector(5 downto 0);
             I_COINWIN: in  std_logic_vector(31 downto 0);
             O_PULSE:   out std_logic);
    end component;

    signal S_OSC: std_logic;

    signal S_CLK_250M: std_logic;
	signal S_LOCK:     std_logic;

	signal S_RST: std_logic;

    signal S_PORT_B: std_logic_vector(31 downto 0);
    signal S_SYNC_B: std_logic_vector(31 downto 0);
    signal S_EDGE_B: std_logic_vector(31 downto 0);

    signal S_COINWIN: std_logic_vector(31 downto 0);
    signal S_COIN:    std_logic;
begin
    S_OSC    <= OSC;
    S_PORT_B <= PORT_B;
    S_RST    <= '0';

    CLKMGR: pll port map(inclk0 => S_OSC,
                         c0     => S_CLK_250M,
                         locked => S_LOCK);

    BSYNC: NSYNC generic map(PL_WD => 3,
                             WD    => 32)
                 port map(CK => S_CLK_250M,
                          D  => S_PORT_B,
                          Q  => S_SYNC_B);

    COINWINDOW: COINWIN generic map(G_WDTH   => 8,
                                    G_NCHANS => 32)
                        port map(I_CLK   => S_CLK_250M,
                                 I_RST   => S_RST,
                                 I_WDTH  => "00000001",
                                 I_DATA  => S_SYNC_B,
                                 O_PULSE => S_COINWIN);

    COIN: COINCIDENCE port map(I_CLK     => S_CLK_250M,
                               I_COINVAL => "000000",
                               I_COINWIN => S_COINWIN,
                               O_PULSE   => S_COIN);

	LEDG_Off    <= S_LOCK;
	LEDR_Off    <= not S_LOCK;
	PORT_G_nOE   <= '0';
	PORT_G_SEL   <= '0';
    PORT_GOUT(0) <= S_PORT_B(0);
    PORT_GOUT(1) <= S_COIN;
end STRUCTURAL;
