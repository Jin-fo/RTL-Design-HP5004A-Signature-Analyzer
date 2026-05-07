library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detecter is
    port (
        clk         : in  std_logic;
        rst_bar     : in  std_logic;
        a           : in  std_logic;
        pos_neg     : in std_logic; -- '1' for positive edge, '0' for negative edge
        select_edge : out std_logic
    );
end entity;

architecture behavioral of edge_detecter is
    signal now_sig : std_logic;
    signal pre_sig : std_logic;
begin

    main: process(clk)
    begin
        if rising_edge(clk) then
            if rst_bar = '0' then
                now_sig <= '0';
                pre_sig <= '0';
            else
                pre_sig <= now_sig;
                now_sig <= a;
            end if;
        end if;
    end process;

    select_edge <= (now_sig and not pre_sig) when pos_neg = '1' else
                   (not now_sig and pre_sig) when pos_neg = '0' else
                   '0';
end architecture;