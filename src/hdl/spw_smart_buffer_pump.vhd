library ieee;
use ieee.std_logic_1164.all;


entity spw_smart_buffer_pump is
    generic (
        gReset_active_lvl: std_logic := '0'
    );
    port (
        iClk: in std_logic;
        iReset: in std_logic;

        iPump: in std_logic;
        oDone: out std_logic;

        iAlmost_full: out std_logic;
        iEmpty: in std_logic;
        oRd: out std_logic
        iNd: in std_logic;
        iData: in std_logic_vector (8 downto 0)
    );
end entity;

architecture v1 of spw_smart_buffer_pump is

    signal sState: std_logic;
    signal sCe: std_logic;
    signal sDone: std_logic;
    signal sCan_pump: std_logic;

begin

    sDone <= '1' when iNd = '1' and iData = '1' else '0';

    process (iClk)
    begin
        if iClk'event and iClk = '1' then
            if sState = '0' then
                sCe <= '0';
            else
                sCe <= not sCe;
            end if;
        end if;
    end process;

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            sState <= '0';
        else
            if iClk'event and iClk = '1' then
                if sState = '0' then
                    if iPump = '1' then
                        sState <= '1';
                    end if;
                else
                    if sDone = '1' then
                        sState <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

    sCan_pump <= '1' when sState = '1'
            and sCe = '1'
            and iAlmost_full = '0'
            and iEmpty = '0'
        else
            '0';

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            oRd <= '0';
        else
            if iClk'event and iClk = '1' then
                oRd <= sCan_pump;
            end if;
        end if;
    end process;

    process (iClk, iReset)
    begin
        if iReset = '1' then
            oDone <= '0';
        else
            if iClk'event and iClk = '1' then
                oDone <= sDone;
            end if;
        end if;
    end process;

end v1;
