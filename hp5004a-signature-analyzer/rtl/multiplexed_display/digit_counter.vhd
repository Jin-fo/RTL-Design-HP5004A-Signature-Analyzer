----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 09:30:00 PM
-- Design Name: 
-- Module Name: multiplexed_display - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digit_counter is 
	port (
	rst_bar : in std_logic;
	clk 	: in std_logic;
    enable  : in std_logic;
	sel     : out std_logic_vector(1 downto 0));
end entity;

architecture behavioral of digit_counter is 
	signal count : unsigned(1 downto 0);
begin 									   
	
    main: process(clk)
    begin
        if rising_edge(clk) then
            if rst_bar = '0' then
                count <= "00";
            elsif enable = '1' then
                count <= count + 1;
            end if;
        end if;
    end process;

    sel <= std_logic_vector(count);
	
end architecture; 