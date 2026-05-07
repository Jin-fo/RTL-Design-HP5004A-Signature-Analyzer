----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 09:30:00 PM
-- Design Name: 
-- Module Name: prescalar - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Take the input clock of 4 MHz and divide it by 10,000 to generate a 400 Hz 
-- clock signal for display multiplexing
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity prescalar is
    port (
    clk : in std_logic;
    rst_bar : in std_logic;
    pout : out std_logic
    );
end entity;

architecture behavioral of prescalar is
    signal count : unsigned(13 downto 0);  
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst_bar = '0' then
                count <= (others => '0');
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    
    pout <= count(13) and 
            not count(12) and 
            not count(11) and 
            count(10) and 
            count(9) and 
            count(8) and 
            not count(7) and 
            not count(6) and 
            not count(5) and 
            not count(4) and 
            count(3) and 
            count(2) and 
            count(1) and 
            count(0); -- Output the at 10,000th clock cycle (when count = 9999)
    
end architecture;