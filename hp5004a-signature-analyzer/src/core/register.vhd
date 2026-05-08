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

entity buff_register is
    port (
    clk : in std_logic;
    rst_bar : in std_logic;
    enable : in std_logic;
    data_in : in std_logic_vector(15 downto 0);
    data_out : out std_logic_vector(15 downto 0)
    );
end entity;

architecture behavioral of buff_register is
    signal reg : std_logic_vector(15 downto 0);
begin
    main: process(clk)    
    begin
        if rising_edge(clk) then
            if rst_bar = '0' then
                reg <= (others => '0');
            elsif enable = '1' then
                reg <= data_in;
            end if;
        end if;
    end process;
    data_out <= reg;    
end architecture;