library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity your_boss_tb is
end entity your_boss_tb;

architecture structural of your_boss_tb is
	component your_boss is
		port (clk		: in	std_logic;
			sensor_in	: in	std_logic_vector(2 downto 0);
			reset		: in	std_logic;
	
			motor_r_pwm		: out	std_logic;
			motor_l_pwm		: out	std_logic;
			mux_sel            : out   std_logic;
			leds           : out std_logic_vector(3 downto 0)
		);
	end component;

signal clk, reset, motor_r_pwm, motor_l_pwm, mux_sel: std_logic;
signal sensor_in       : std_logic_vector(2 downto 0);
signal leds       : std_logic_vector(3 downto 0);

begin

clk <= '1' after 0 ns,
	'0' after 5 ns when clk /= '0' else '1' after 5 ns;

reset <= '0' after 0 ns, '1' after 10 ns,
	 '0' after 20 ns;

sensor_in <= "111" after 0 ns, -- 1 is white, 0 is black
             "110" after 60 ns,
             "100" after 90 ns,
             "101" after 120 ns, -- wbw
             "111" after 160 ns, -- www
             "010" after 200 ns, -- bwb
             "101" after 240 ns, -- wbw
	     	"001" after 260 ns,
		 	"011" after 300 ns,
		 	"000" after 340 ns,
		 	"000" after 380 ns;

lbl0: your_boss port map(
	clk => clk,
	sensor_in => sensor_in,
	reset => reset,

	motor_r_pwm => motor_r_pwm, -- out to servos
	motor_l_pwm => motor_l_pwm, -- out to servos
	mux_sel => mux_sel, -- finder done
	leds => leds -- dir1, reset1, dir2, reset2
);
end architecture structural;

	
