library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity spw_smart_buffer_mem_cnt is
    generic (
        gReset_active_lvl: std_logic := '0'
    );
    port (
        iClk: in std_logic;
        iReset: in std_logic;

        iIn_nd: in std_logic;
        iIn_flag: in std_logic;
        iOut_nd: in std_logic;
        iOut_flag: in std_logic;

        oPkg_num: out std_logic_vector
    );
end entity;

architecture v1 of spw_smart_buffer_mem_cnt is

    constant cW: natural := oPkg_num'length;

    signal sInc: std_logic;
    signal sDec: std_logic;
    signal sCase: std_logic_vector (1 downto 0);
    signal sCnt: unsigned (cW-1 downto 0);

begin

    sInc <= '1' when iIn_nd = '1' and iIn_flag = '1' else '0';
    sDec <= '1' when iOut_nd = '1' and iOut_flag = '1' else '0';
    sCase <= sInc & sDec;

    oPkg_num <= std_logic_vector (sCnt);

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            sCnt <= (sCnt'range => '0');
        else
            if iClk'event and iClk = '1' then
                case sCase is
                    when "01" =>
                        sCnt <= sCnt-1;
                    when "10" =>
                        sCnt <= sCnt+1;
                    when others =>
                end case;
            end if;
        end if;
    end process;

end v1;
