library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity your_boss is
	port (	clk		: in	std_logic;
		sensor_in	: in	std_logic_vector(2 downto 0);
		reset		: in	std_logic;

		motor_r_pwm		: out	std_logic;
		motor_l_pwm		: out	std_logic;
		led            : out   std_logic;
		leds           : out std_logic_vector(3 downto 0)
	);
end entity your_boss;

architecture structural of your_boss is
	component line_finder is
		port (	clk		: in	std_logic;
		sensor_in	: in	std_logic_vector(2 downto 0);
		reset		: in	std_logic;

		dir1			: out	std_logic;
		dir2			: out	std_logic;
		reset1			: out	std_logic;
		reset2			: out	std_logic;
		previous_c0		: out	std_logic;
		previous_c1		: out	std_logic;
		previous_c2		: out	std_logic;
		line_finder_done	: out   std_logic
		);
	end component line_finder;

	-- component counter is
	-- port (	clk		: in	std_logic;
	-- 	reset		: in	std_logic;

	-- 	count_out	: out	std_logic_vector (?? downto 0)
	-- );
	-- end component counter;
			
	 component buffer_entity is
	 port (	clk			: in	std_logic;
	 		reset		: in	std_logic;
	 		d			: in std_logic_vector(2 downto 0);
	 		q			: out std_logic_vector(2 downto 0)
	 );
	 end component buffer_entity;

	component pwm_middleman is
	port (	clk			: in	std_logic;

        	reset1		: in	std_logic;
			reset2		: in	std_logic;
			dir1		: in	std_logic;
			dir2        : in    std_logic;

			motor_r_pwm	: out	std_logic;
			motor_l_pwm	: out	std_logic;
			timeup_fsm  : out std_logic
    );
	end component pwm_middleman;

    signal sig_sensor : std_logic_vector (2 downto 0); 
    signal previous_c0, previous_c1, previous_c2 : std_logic;
	signal timeup : std_logic; -- fsm state trans signal
	signal sig_motor_r_reset, sig_motor_l_reset, sig_motor_r_direction ,sig_motor_l_direction : std_logic;

begin
--	process(clk) is
--    begin
----		sig_sensor_l <= sig_sensor(0);
----		sig_sensor_m <= sig_sensor(1);
----		sig_sensor_r <= sig_sensor(2);
--    leds <= sig_sensor;
--	end process;

    leds <= sig_motor_r_direction & sig_motor_r_reset & sig_motor_l_direction & sig_motor_l_reset;

	 u1: buffer_entity
	 port map (
	 	clk => clk,
	 	reset => '0',
	 	d => sensor_in, -- in

	 	q => sig_sensor -- out
	 	);

	u2: line_finder
	port map (	
		clk => clk,
		sensor_in => sig_sensor,
		reset => reset, -- in from pwm_middleman

		dir1 => sig_motor_r_direction, -- out
		dir2 => sig_motor_l_direction, -- out

		reset1 => sig_motor_r_reset, -- out
		reset2 => sig_motor_l_reset, -- out
		previous_c0	=> previous_c0, -- out
		previous_c1 => previous_c1, -- out
		previous_c2	=> previous_c2, -- out
		line_finder_done => led -- out
	   );

	-- u3: counter
	-- port map (
	-- 	clk => clk,
	-- 	reset => sig_count_reset,

	-- 	count_out => sig_counter_out; -- out
	-- );
	-- end component counter;

	u3: pwm_middleman -- left servo
	port map (	
		clk => clk,
		reset1 => sig_motor_r_reset,
		reset2 => sig_motor_l_reset,
		dir1 => sig_motor_r_direction,
		dir2 => sig_motor_l_direction,

		motor_r_pwm => motor_r_pwm, -- out to servos
		motor_l_pwm => motor_l_pwm, -- out to servos
		timeup_fsm => timeup -- out to fsm_controller
	);

end structural;