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
			led_detect_r           : out std_logic;
			led_turn_r             : out std_logic;
			led_detect_l           : out std_logic;
			led_turn_l             : out std_logic
		);
	end component;

signal clk, reset, motor_r_pwm, motor_l_pwm, mux_sel: std_logic;
signal sensor_in       : std_logic_vector(2 downto 0);
signal led_detect_r, led_turn_r, led_detect_l, led_turn_l : std_logic;

begin

clk <= '1' after 0 ns,
	'0' after 5 ns when clk /= '0' else '1' after 5 ns;

reset <= '0' after 0 ns, '1' after 10 ns,
	 '0' after 20 ns;

sensor_in <="111" after 0 ns,
            "110" after 60 ns,
            "100" after 90 ns,
            "000" after 120 ns,
            "001" after 160 ns,
            "011" after 200 ns,
            "111" after 240 ns,
	     	"011" after 280 ns,

			"101" after 300 ns, -- 1 is white, 0 is black
            "101" after 360 ns,
            "010" after 390 ns,
            "111" after 420 ns, 
            "101" after 460 ns, 
            "000" after 480 ns, -- RIGHT
			"110" after 510 ns, -- Right turn done
            "101" after 530 ns, -- Found line again

	     	"010" after 560 ns, -- First signal
		 	"111" after 600 ns,
		 	"101" after 640 ns,
		 	"010" after 680 ns, -- Second signal
			"111" after 720 ns,
			"101" after 760 ns,
			"000" after 800 ns, -- LEFT
			"110" after 850 ns, -- LEFT
			"111" after 860 ns,
			"011" after 900 ns, -- Left turn done
			"101" after 920 ns, -- Found line again
			"111" after 1100 ns; -- STOP


lbl0: your_boss port map(
	clk => clk,
	sensor_in => sensor_in,
	reset => reset,

	motor_r_pwm => motor_r_pwm, -- out to servos
	motor_l_pwm => motor_l_pwm, -- out to servos
	mux_sel => mux_sel, -- finder done
	led_detect_r => led_detect_r,
	led_turn_r => led_turn_r,
	led_detect_l => led_detect_l,
	led_turn_l => led_turn_l
);
end architecture structural;

	
