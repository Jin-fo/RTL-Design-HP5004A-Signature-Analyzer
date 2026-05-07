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
use work.all;

entity Multiplexed_Display is
	port( 
	clk : in std_logic; 
	rst_bar : in std_logic;
    enable : in std_logic;
	signature : in std_logic_vector(15 downto 0);
	segs : out std_logic_vector(6 downto 0);
	digs : out std_logic_vector(3 downto 0)
	);							   

end entity;	

architecture structural of Multiplexed_Display is  
signal sel : std_logic_vector(1 downto 0);
signal out_vector : std_logic_vector(3 downto 0);
begin  	
	
    U0: entity work.mux_4_to_1
        port map( 
		s1 => sel(1),
		s0 => sel(0), 
        in_vector_0 => signature(3 downto 0),
        in_vector_1 => signature(7 downto 4),
        in_vector_2 => signature(11 downto 8),
        in_vector_3 => signature(15 downto 12),
		out_vector => out_vector
        );
		
    U1: entity work.funnyhex_seven
        port map(
        fhex => out_vector,
        segments => segs
        );	 
		
    U2: entity work.decoder_2_to_4
        port map(
		s1 => sel(1),	
		s0 => sel(0),
        digit_driver => digs
        );
		
	U3: entity work.digit_counter
        port map(
		rst_bar => rst_bar,
        enable => enable,
        clk => clk,
 		sel => sel
        );

end architecture; 
