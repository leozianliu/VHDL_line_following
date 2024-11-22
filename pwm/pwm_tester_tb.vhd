library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_tester_tb is
end entity pwm_tester_tb;

architecture structural of pwm_tester_tb is

    component pwm_tester is
        port (	clk		: in	std_logic;
    
            reset_but	: in	std_logic;
            dir		: in	std_logic;
    
            motor_r_pwm	: out	std_logic;
            motor_l_pwm	: out	std_logic
        );
    end component pwm_tester;

signal clk, reset_but, dir: std_logic;
signal motor_r_pwm, motor_l_pwm: std_logic;

begin

clk <= '1' after 0 ns,
	'0' after 5 ns when clk /= '0' else '1' after 5 ns;

reset_but <= '1' after 0 ns,
	'0' after 20 ns,
	'1' after 200000000 ns,
	'0' after 200000020 ns;

dir <= '1' after 0 ns,
    '0' after 5000000 ns;

lbl0: pwm_tester   port map (
    	clk => clk,
        reset_but => reset_but,
        dir => dir,

        motor_r_pwm => motor_r_pwm,
        motor_l_pwm	=> motor_l_pwm
        );

-- Observation Process
observation_process: process (clk)
begin
    --wait until rising_edge(clk);
    report "motor_r_pwm: " & std_logic'image(motor_r_pwm);
    report "motor_l_pwm: " & std_logic'image(motor_l_pwm);
end process;

end architecture structural;
