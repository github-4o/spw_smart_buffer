library ieee;
use ieee.std_logic_1164.all;


entity spw_smart_buffer_fsm is
    generic (
        gReset_active_lvl: std_logic := '0';
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
end entity;

architecture v1 of spw_smart_buffer_fsm is

    signal sCnt: unsigned (cW-1 downto 0);

    signal sState: std_logic;
    signal sStart: std_logic;

begin

    sStart <= '1' when iPkg_num /= (iPkg_num'range => '0') else iAlmost_full;

    process (iClk, iReset)
    begin
        if iReset = '1' then
            sState <= '0';
        else
            if iClk'event and iClk = '1' then
                if sState = '0' then
                    if sStart = '1' then
                        sState <= '1';
                    end if;
                else
                    if iDone = '1' then
                        sState <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

    process (iClk, iReset)
    begin
        if iReset = '1' then
            oPump <= '0';
        else
            if iClk'event and iClk = '1' then
                if sState = '0' and sStart = '1' then
                    oPump <= '1';
                else
                    oPump <= '0';
                end if;
            end if;
        end if;
    end process;

end v1;
