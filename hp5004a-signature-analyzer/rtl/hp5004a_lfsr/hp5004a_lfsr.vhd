----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 09:30:00 PM
-- Design Name: 
-- Module Name: hp5004a_lfsr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 16-bit Linear Feedback Shift Register (LFSR) with external data input
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

entity hp5004a_lfsr is 
	port (
	clk   	: in std_logic;
	rst_bar : in std_logic;
	gate   	: in std_logic;
	clear  : in std_logic;
	data    : in std_logic;
	sig_out : out std_logic_vector(15 downto 0)
	);
end entity; 

architecture behavioral of hp5004a_lfsr is
	signal lfsr_reg : std_logic_vector(15 downto 0);
begin 

	
	main : process(clk)
        variable feedback : std_logic;
    begin							 
        if rising_edge(clk) then
            if rst_bar = '0' or clear = '1' then
                lfsr_reg <= (others => '0');
				
            elsif gate = '1' then	  
				
				feedback := lfsr_reg(15) xor 
							lfsr_reg(11) xor 
							lfsr_reg(8) xor 
							lfsr_reg(6) xor 
							data_in;

                lfsr_reg <= lfsr_reg(14 downto 0) & feedback;              
 
            end if;
        end if;
    end process;
    
    sig_out <= lfsr_reg; 
end architecture;