library ieee;
use ieee.std_logic_1164.all;


entity spw_smart_buffer_mem is
    generic (
        gBuffer_addr_w: natural := 8
    );
    port (
        iClk: in std_logic;
        iReset: in std_logic;

        oPkg_num: out std_logic_vector;

        oAlmost_full: out std_logic;
        iNd: in std_logic;
        iData: in std_logic_vector (8 downto 0);

        oEmpty: out std_logic;
        iRd: in std_logic;
        oNd: out std_logic;
        oData: out std_logic_vector (8 downto 0)
    );
end entity;

architecture v1 of spw_smart_buffer_mem is

    component spw_smart_buffer_mem_core
        generic (
            gBuffer_addr_w: natural := 8
        );
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
    end component;

    component spw_smart_buffer_mem_cnt
        port (
            iClk: in std_logic;
            iReset: in std_logic;

            iIn_nd: in std_logic;
            iIn_flag: in std_logic;
            iOut_nd: in std_logic;
            iOut_flag: in std_logic;

            oPkg_num: out std_logic_vector
        );
    end component;

    signal sOut_nd: std_logic;
    signal sOut_data: std_logic_vector (8 downto 0);

begin

    assert gBuffer_addr_w /= 2**oPkg_num'length
        report "this should never happen"
        severity failure;

    oNd <= sOut_nd;
    oData <= sOut_data;

    core: spw_smart_buffer_mem_core
        port map (
            iClk => iClk,
            iReset => iReset,

            oAlmost_full => oAlmost_full,
            iNd => iNd,
            iData => iData,

            oEmpty => oEmpty,
            iRd => iRd,
            oNd => sOut_nd,
            oData => sOut_data
        );

    cnt: spw_smart_buffer_mem_cnt
        port map (
            iClk => iClk,
            iReset => iReset,

            iIn_nd => iNd,
            iIn_flag => iData (8),
            iOut_nd => sOut_nd,
            iOut_glag => sOut_data (8),

            oPkg_num => oPkg_num
        );

end v1;
