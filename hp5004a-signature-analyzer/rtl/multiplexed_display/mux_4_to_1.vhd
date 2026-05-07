----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 09:30:00 PM
-- Design Name: 
-- Module Name: mux_4_to_1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 4-to-1 multiplexer for 4-bit vectors
-- Dependencies: 
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

entity mux_4_to_1 is
	port ( 
	s1 : in std_logic;
	s0 : in std_logic;
	in_vector_0 : in std_logic_vector(3 downto 0);
	in_vector_1 : in std_logic_vector(3 downto 0);
	in_vector_2 : in std_logic_vector(3 downto 0);
	in_vector_3 : in std_logic_vector(3 downto 0);
	out_vector  : out std_logic_vector(3 downto 0));
end entity;

architecture dataflow of mux_4_to_1 is
begin
	
	out_vector <= 
		in_vector_0 when std_logic_vector'(s1 & s0) = "00" else
		in_vector_1 when std_logic_vector'(s1 & s0) = "01" else
		in_vector_2 when std_logic_vector'(s1 & s0) = "10" else
		in_vector_3 when std_logic_vector'(s1 & s0) = "11" else 
		"0000";							  
		
end architecture;