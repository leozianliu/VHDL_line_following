library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity line_finder_tb is
end entity line_finder_tb;

architecture structural of line_finder_tb is
	component your_boss is
		port (clk		: in	std_logic;
			sensor_in	: in	std_logic_vector(2 downto 0);
			reset		: in	std_logic;
	
			motor_r_pwm		: out	std_logic;
			motor_l_pwm		: out	std_logic;
			led            : out   std_logic;
			leds           : out std_logic_vector(3 downto 0)
		);
	end component;

signal clk, reset, motor_r_pwm, motor_l_pwm, led: std_logic;
signal sensor_in       : std_logic_vector(2 downto 0);
signal leds       : std_logic_vector(3 downto 0);

begin

clk <= '1' after 0 ns,
	'0' after 5 ns when clk /= '0' else '1' after 5 ns;

reset <= '0' after 0 ns, '1' after 10 ns,
	 '0' after 20 ns;

sensor_in <= "000" after 0 ns,
             "001" after 60 ns,
             "011" after 90 ns,
             "000" after 120 ns,
             "100" after 160 ns,
             "110" after 200 ns,
             "100" after 240 ns,
	     "010" after 260 ns;

lbl0: your_boss port map(
	clk => clk,
	sensor_in => sensor_in,
	reset => reset,

	motor_r_pwm => motor_r_pwm, -- out to servos
	motor_l_pwm => motor_l_pwm, -- out to servos
	led => led, -- finder done
	leds => leds -- dir1, reset1, dir2, reset2
);
end architecture structural;

	
