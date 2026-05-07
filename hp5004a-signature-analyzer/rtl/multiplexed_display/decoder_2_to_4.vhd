----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 09:30:00 PM
-- Design Name: 
-- Module Name: decoder_2_to_4 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 2-to-4 decoder for digit selection in multiplexed display
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

entity decoder_2_to_4 is
    port ( 
    s1 : in std_logic;
    s0 : in std_logic;
    digit_driver  : out std_logic_vector(3 downto 0));
end entity;

architecture dataflow of decoder_2_to_4 is  
begin  
	
	digit_driver <=
	    not "0001" when std_logic_vector'(s1 & s0) = "00" else
	    not "0010" when std_logic_vector'(s1 & s0) = "01" else
	    not "0100" when std_logic_vector'(s1 & s0) = "10" else
	    not "1000" when std_logic_vector'(s1 & s0) = "11" else
	    not "0000";
	
end architecture;