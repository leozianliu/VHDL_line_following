library IEEE;
library work;

use work.controller;
use work.counter;
use work.input_buffer;
use work.pwm_generator;


entity your_boss is
	port (	clk		: in	std_logic;
		sensor_l_in	: in	std_logic;
		sensor_m_in	: in	std_logic;
		sensor_r_in	: in	std_logic;
		reset		: in	std_logic;

		pwm_l		: out	std_logic;
		pwm_r		: out	std_logic;
	);
end entity your_boss;

architecture structural of your_boss is
	component controller is
	port (	clk			: in	std_logic;
		reset			: in	std_logic;

		sensor_l		: in	std_logic;
		sensor_m		: in	std_logic;
		sensor_r		: in	std_logic;

		count_in		: in	std_logic_vector (?? downto 0);
		count_reset		: out	std_logic;

		motor_l_reset		: out	std_logic;
		motor_l_direction	: out	std_logic;

		motor_r_reset		: out	std_logic;
		motor_r_direction	: out	std_logic
	);
	end component controller;

	component counter is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;

		count_out	: out	std_logic_vector (?? downto 0)
	);
	end component counter;
			
	component input_buffer is
	port (	clk		: in	std_logic;

		sensor_l_in	: in	std_logic;
		sensor_m_in	: in	std_logic;
		sensor_r_in	: in	std_logic;

		sensor_l_out	: out	std_logic;
		sensor_m_out	: out	std_logic;
		sensor_r_out	: out	std_logic
	);
	end component input_buffer;

	component pwm_generator is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;
		direction	: in	std_logic;
		count_in	: in	std_logic_vector (?? downto 0);

		pwm		: out	std_logic
	);
	end component pwm_generator;

	signal sig_sensor_l : std_logic, sig_sensor_m : std_logic, sig_sensor_r : std_logic;
	signal sig_counter_out : std_logic_vector (?? downto 0), sig_count_reset : std_logic;
	signal sig_motor_r_reset : std_logic, sig_motor_l_reset : std_logic, sig_motor_r_direction : std_logic, sig_motor_l_direction : std_logic;

begin
	u1: input_buffer
	port map (
		clk => clk,

		sensor_l_in => sensor_l_in, -- in
		sensor_m_in => sensor_m_in, -- in
		sensor_r_in => sensor_r_in, -- in

		sensor_l_out => sig_sensor_l, -- out
		sensor_m_out => sig_sensor_m, -- out
		sensor_r_out => sig_sensor_r, -- out
		);

	u2: controller
	port map (	
		clk => clk,
		reset => reset,

		sensor_l => sig_sensor_l, -- in
		sensor_m => sig_sensor_m, -- in
		sensor_r => sig_sensor_r, -- in

		count_in => sig_counter_out, -- in from counter
		count_reset => sig_count_reset, -- out to counter

		motor_l_reset => sig_motor_l_reset, -- out
		motor_l_direction => sig_motor_l_direction, -- out

		motor_r_reset => sig_motor_r_reset, -- out
		motor_r_direction => sig_motor_r_direction -- out
	);

	u3: counter
	port map (
		clk => clk,
		reset => sig_count_reset,

		count_out => sig_counter_out; -- out
	);
	end component counter;

	u4: pwm_generator -- left servo
	port map (	
		clk => clk,
		reset => sig_motor_l_reset,
		direction => sig_motor_l_direction,
		count_in => sig_counter_out,

		pwm => pwm_l -- out
	);

	u5: pwm_generator -- right servo
	port map (	
		clk => clk,
		reset => sig_motor_r_reset,
		direction => sig_motor_r_direction,
		count_in => sig_counter_out,

		pwm => pwm_r -- out
	);

end structural;