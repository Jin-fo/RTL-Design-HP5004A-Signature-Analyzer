----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 09:30:00 PM
-- Design Name: 
-- Module Name: hp5004a_signature_analyzer - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.all;

entity hp5004a_SA_w_display is
    port (
        clk      : in  std_logic;                    
        rst_bar  : in  std_logic;                      
        start    : in std_logic;
        starte   : in std_logic;
        stop     : in std_logic; 
        stope    : in std_logic;
        clock    : in std_logic;
        clocke   : in std_logic;             
        data     : in  std_logic;                     
        segs     : out std_logic_vector(6 downto 0);   
        digs     : out std_logic_vector(3 downto 0)    
    );	   	

end entity;
 
architecture structural of hp5004a_SA_w_display is
	signal data_in, data_out : std_logic_vector(15 downto 0);
    signal stop_edge, start_edge, clock_edge : std_logic;
    signal gate, reg_en : std_logic;
	constant U : time :=10ns;
 
begin
 
    U0A: entity work.edge_selecter
        port map (
            clk         => clk,
            rst_bar     => rst_bar,
            a           => start,
            pos_neg     => starte,
            select_edge => start_edge
        );

    U0B: entity work.edge_selecter
        port map (
            clk         => clk,
            rst_bar     => rst_bar, 
            a           => stop,
            pos_neg     => stope,
            select_edge => stop_edge
        );
    U0: entity work.gate_gen
        port map (
            clk         => clk,
            rst_bar     => rst_bar,
            start       => start_edge,
            stop        => stop_edge,
            gate_out    => gate,
            reg_en      => reg_en
        );

    U1A: entity work.edge_selecter
        port map (
                clk         => clk,
                rst_bar     => rst_bar, 
                a           => clock,
                pos_neg     => clocke,
                select_edge => clock_edge
            );

    U1: entity work.hp5004a_lfsr
        port map (
            clk     => clock_edge,
            rst_bar => rst_bar,
            gate    => gate,
            clear   => reg_en,
            data    => data,

            sig_out => data_in
        );
 
    U2: entity work.register
        port map (
            clk         => clk,
            rst_bar     => rst_bar,
            enable      => reg_en,
            data_in     => data_in,
            data_out    => data_out
        );  

    U3A: entity work.prescalar
        port map (
            clk         => clk,
            rst_bar     => rst_bar,
            pout        => pout
        );

    U3: entity work.multiplexed_display
        port map (
            clk         => clk,
            rst_bar     => rst_bar,
            enable      => pout,  
            signature   => data_out,
            segs        => segs,
            digs        => digs
        );
 
end architecture;