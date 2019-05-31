library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity spw_smart_buffer_mem_core_block is
    generic (
        gReset_active_lvl: std_logic := '0'
    );
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
end entity;

architecture v1 of spw_smart_buffer_mem_core_block is

    type tMem is array (2**iWr_addr'length-1 downto 0)
        of std_logic_vector (8 downto 0);

    signal sMem: tMem;

begin

    assert iWr_addr'length = iRd_addr'length
        report "addr mismatch"
        severity failure;

    process (iClk)
    begin
        if iClk'event and iClk = '1' then
            if iWr = '1' then
                sMem (to_integer (unsigned (iWr_addr))) <= iWr_data;
            end if;

            oData <= sMem (to_integer (unsigned (iRd_addr)));
        end if;
    end process;

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            oNd <= '0';
        else
            if iClk'event and iClk = '1' then
                oNd <= iRd;
            end if;
        end if;
    end process;

end v1;
