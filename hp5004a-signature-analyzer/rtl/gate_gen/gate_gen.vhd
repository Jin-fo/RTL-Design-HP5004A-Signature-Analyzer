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

entity gate_gen is 
    port (
    clk : in std_logic;
    rst_bar : in std_logic;
    start   : in std_logic;
    stop    : in std_logic;
    gate_out : out std_logic;
    reg_en : out std_logic
    );
end entity;

architecture fsm of gate_gen is
    type state_type is (IDLE, GATE_H, GATE_L);
    signal state, next_state : state_type;
begin 

    state : process(clk)
    begin
        if rising_edge(clk) then
            state <= IDLE;
        else
            state <= next_state;
        end if;
    end process;

    transition : process(state, start, stop)
    begin
        case state is
            when IDLE =>
                if start = '1' then
                    next_state <= GATE_H;
                else
                    next_state <= IDLE;
                end if;
            when GATE_H =>
                if stop = '1' then
                    next_state <= GATE_L;
                else
                    next_state <= GATE_H;
                end if;
            when GATE_L =>
                next_state <= IDLE;
            when others =>
                next_state <= IDLE;
        end case;
    end process;

    output_logic : process(state)
    begin
        case state is
            when IDLE =>
                gate_out <= '0';
                reg_en <= '0';
            when GATE_H =>
                gate_out <= '1';
                reg_en <= '0';
            when GATE_L =>
                gate_out <= '0';
                reg_en <= '1';
            when others =>
                null;
        end case;
    end process;

end architecture;