library ieee;
use ieee.std_logic_1164.all;

entity spw_smart_buffer is
    generic (
        gBuffer_addr_w: natural := 8
    );
    port (
        iClk: in std_logic;
        iReset: in std_logic;

        -- higher lvl
        oAlmost_full: out std_logic;
        iNd: in std_logic;
        iData: in std_logic_vector (8 downto 0);

        iAlmost_full: out std_logic;
        oNd: out std_logic;
        oData: out std_logic_vector (8 downto 0)
    );
end entity;

architecture v1 of spw_smart_buffer is

    function log2 (v: natural) return is
    begin
        if v = 8 then
            return 3;
        else
            assert false
                report "not implemented"
                severity failure;
            return -1;
        end if;
    end function;

    constant cPkg_cnt_w: natural := log2(gBuffer_addr_w);

    component spw_smart_buffer_fsm
        generic (
            gBuffer_addr_w: natural := 8
        );
        port (
            iClk: in std_logic;
            iReset: in std_logic;

            iAlmost_full: out std_logic;
            iPkg_num: in std_logic_vector;

            oPump: out std_logic;
            iDone: in std_logic
        );
    end component;

    component spw_smart_buffer_mem
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
    end component;

    component spw_smart_buffer_pump
        port (
            iClk: in std_logic;
            iReset: in std_logic;

            iPump: in std_logic;
            oDone: out std_logic;

            iAlmost_full: out std_logic;
            iEmpty: in std_logic;
            oRd: out std_logic;
            iNd: in std_logic;
            iData: in std_logic_vector (8 downto 0)
        );
    end component;

    signal sAlmost_full: std_logic;
    signal sPump: std_logic;
    signal sDone: std_logic;
    signal sEmpty: std_logic;
    signal sRd: std_logic;
    signal sNd: std_logic;
    signal sData: std_logic_vector (8 downto 0);

begin

    oAlmost_full <= sAlmost_full;
    oNd <= sNd;
    oData <= sData;

    fsm: spw_smart_buffer_fsm
        generic map (
            gBuffer_addr_w => gBuffer_addr_w
        )
        port map (
            iClk => iClk,
            iReset => iReset,

            iAlmost_full => sAlmost_full,

            iNd => iNd,
            iData => iData,

            oPump => sPump,
            iDone => sDone
        );

    mem: spw_smart_buffer_mem
        generic map (
            gBuffer_addr_w => gBuffer_addr_w
        )
        port map (
            iClk => iClk,
            iReset => iReset,

            oAlmost_full => sAlmost_full,
            iNd => iNd,
            iData => iData,

            oEmpty => sEmpty,
            iRd => sRd,
            oNd => sNd,
            oData => sData
        );

    pump: spw_smart_buffer_pump
        port map (
            iClk => iClk,
            iReset => iReset,

            iPump => sPump,
            oDone => sDone,

            iAlmost_full => iAlmost_full,
            iEmpty => sEmpty,
            oRd => sRd,
            iNd => iNd,
            iData => iData
        );

end v1;
