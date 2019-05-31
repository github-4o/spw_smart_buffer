library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity spw_smart_buffer_mem_core_cnts is
    generic (
        gReset_active_lvl: std_logic := '0'
    );
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
end entity;

architecture v1 of spw_smart_buffer_mem_core_cnts is

    signal sRd_addr: unsgiend (oRd_addr'length-1 downto 0);
    signal sWr_addr: unsgiend (oWr_addr'length-1 downto 0);
    signal sCnt: unsigned (oRd_addr'length downto 0);

    signal sCase: std_logic_vector (1 downto 0);

begin

    assert oRd_addr'length = oWr_addr'length
        report "width mismatch"
        severity failure;

    oRd_addr <= std_logic_vector (sRd_addr);
    oWr_addr <= std_logic_vector (sWr_addr);

    oEmpty <= '1' when sCnt = (sCnt'range => '0') else '0';
    oAlmost_full <= '1' when sCnt (sCnt'length-1) = '1' or
            sCnt (sCnt'length-2 downto 1) = (sCnt'length-2 downto 1 => '1')
        else
            '0';

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            sRd_addr <= (sRd_addr'range => '0');
        else
            if iClk'event and iClk = '1' then
                if iRd = '1' then
                    sRd_addr <= sRd_addr + 1;
                else
                    sRd_addr <= sRd_addr;
                end if;
            end if;
        end if;
    end process;

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            sWr_addr <= (sWr_addr'range => '0');
        else
            if iClk'event and iClk = '1' then
                if iNd = '1' then
                    sWr_addr <= sWr_addr + 1;
                else
                    sWr_addr <= sWr_addr;
                end if;
            end if;
        end if;
    end process;

    sCase <= iNd & iRd;

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            sCnt <= (sCnt'range => '0');
        else
            if iClk'event and iClk = '1' then
                case sCase is
                    when "01" =>
                        sCnt <= sCnt - 1;
                    when "10" =>
                        sCnt <= sCnt + 1;
                    when others =>
                end case;
            end if;
        end if;
    end process;

end v1;
