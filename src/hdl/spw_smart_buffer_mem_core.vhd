library ieee;
use ieee.std_logic_1164.all;


entity spw_smart_buffer_mem_core is
    port (
        iClk: in std_logic;
        iReset: in std_logic;

        oAlmost_full: out std_logic;
        iNd: in std_logic;
        iData: in std_logic_vector (8 downto 0);

        oEmpty: out std_logic;
        iRd: in std_logic;
        oNd: out std_logic;
        oData: out std_logic_vector (8 downto 0)
    );
end entity;

architecture v1 of spw_smart_buffer_mem_core is

    component spw_smart_buffer_mem_core_cnts
        port (
            iClk: in std_logic;
            iReset: in std_logic;

            iNd: in std_logic;
            iRd: in std_logic;

            oWr_addr: out std_logic_vector;
            oRd_addr: out std_logic_vector;

            oAlmost_full: out std_logic;
            oEmpty: out std_logic
        );
    end component;

    component spw_smart_buffer_mem_core_block
        port (
            iClk: in std_logic;
            iReset: in std_logic;

            iWr: in std_logic;
            iWr_addr: in std_logic_vector;
            iWr_data: in std_logic_vector (8 downto 0);

            iRd: in std_logic;
            iRd_addr: in std_logic_vector;
            oNd: out std_logic;
            oData: out std_logic_vector (8 downto 0)
        );
    end component;

    signal sRd_addr: std_logic_vector (gBuffer_addr_w-1 downto 0);
    signal sWr_addr: std_logic_vector (gBuffer_addr_w-1 downto 0);

begin

    cnts: spw_smart_buffer_mem_core_cnts
        port map (
            iClk => iClk,
            iReset => iReset,

            iNd => iNd,
            iRd => iRd,

            oWr_addr => sRd_addr,
            oRd_addr => sWr_addr,

            oAlmost_full => oAlmost_full,
            oEmpty => oEmpty
        );

    mem_block: spw_smart_buffer_mem_core_block
        port map (
            iClk => iClk,
            iReset => iReset,

            iWr => iNd,
            iWr_addr => sWr_addr,
            iWr_data => iData,

            iRd => iRd,
            iRd_addr => sRd_addr,
            oNd => oNd,
            oData => oData
        );

end v1;
