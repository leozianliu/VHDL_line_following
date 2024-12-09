library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity your_boss is
	port (	clk		: in	std_logic;
		sensor_in	: in	std_logic_vector(2 downto 0);
		reset		: in	std_logic;

		motor_r_pwm		: out	std_logic;
		motor_l_pwm		: out	std_logic;
		mux_sel            : out   std_logic
	--	leds           : out std_logic_vector(3 downto 0)
	);
end entity your_boss;

architecture structural of your_boss is
	component line_finder is
		port (	clk		: in	std_logic;
		sensor_in	: in	std_logic_vector(2 downto 0);
		reset		: in	std_logic;
		goto_pl_state	: in	std_logic;
--		timeup          : in    std_logic;

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

	component turn is
		port (
			clk: in std_logic;
			reset: in std_logic;
			timeup: in std_logic;
			c0: in std_logic; 
			c1: in std_logic;
			c2: in std_logic;
			dir1: out std_logic;
			dir2: out std_logic;
			reset1: out std_logic;
			reset2: out std_logic
		);
	end component turn;

	component passline_sel is
		Port ( 
			done : in STD_LOGIC;
			now_c   : in STD_LOGIC_VECTOR(2 downto 0);
			old_c0   : in STD_LOGIC;
			old_c1   : in STD_LOGIC;
			old_c2   : in STD_LOGIC;
			sel   : out STD_LOGIC;
			goto_pl_state : out STD_LOGIC
		);
	end component passline_sel;

	component mux2 is
		Port ( sel : in STD_LOGIC;
			   a   : in STD_LOGIC_VECTOR(3 downto 0);
			   b   : in STD_LOGIC_VECTOR(3 downto 0);
			   y   : out STD_LOGIC_VECTOR(3 downto 0)
		);
	end component mux2;
	
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
	signal sig_motor_r_direction0, sig_motor_l_direction0, sig_motor_r_reset0, sig_motor_l_reset0 : std_logic;
	signal sig_motor_r_direction1, sig_motor_l_direction1, sig_motor_r_reset1, sig_motor_l_reset1 : std_logic;
	signal finder_output_vec, follower_output_vec, sig_motor_out : std_logic_vector(3 downto 0);
	signal sig_motor_r_reset_out, sig_motor_l_reset_out, sig_motor_r_direction_out, sig_motor_l_direction_out : std_logic := '0';
	signal find_done_sig, mux_sel_sig, goto_pl_state_sig : std_logic := '0';

begin

   -- leds <= sig_motor_r_direction_out & sig_motor_r_reset_out & sig_motor_l_direction_out & sig_motor_l_reset_out;

	 u1: buffer_entity
	 port map (
	 	clk => clk,
	 	reset => reset,
	 	d => sensor_in, -- in

	 	q => sig_sensor -- out
	 	);

	u21: line_finder
	port map (	
		clk => clk,
		sensor_in => sig_sensor,
		reset => reset, -- in
		goto_pl_state => goto_pl_state_sig, -- in
--		timeup => timeup,

		dir1 => sig_motor_r_direction0, -- out
		dir2 => sig_motor_l_direction0, -- out

		reset1 => sig_motor_r_reset0, -- out
		reset2 => sig_motor_l_reset0, -- out
		previous_c0	=> previous_c0, -- out
		previous_c1 => previous_c1, -- out
		previous_c2	=> previous_c2, -- out
		line_finder_done => find_done_sig -- out
	);

	u22: line_follower
	port map (
		clk => clk,
		reset => reset,
		timeup => timeup,
		c0 => sig_sensor(2), -- in
		c1 => sig_sensor(1), -- in
		c2 => sig_sensor(0), -- in
		dir1 => sig_motor_r_direction1, -- out
		dir2 => sig_motor_l_direction1, -- out
		reset1 => sig_motor_r_reset1, -- out
		reset2 => sig_motor_l_reset1 -- out
	);

	u3: passline_sel
	port map (
		done => find_done_sig,
		now_c => sig_sensor,
		old_c0 => previous_c0, -- in
		old_c1 => previous_c1, -- in
		old_c2 => previous_c2, -- in
		sel => mux_sel_sig, -- out
		goto_pl_state => goto_pl_state_sig -- out
	);
	
	-- pack to vector
	finder_output_vec <= sig_motor_r_direction0 & sig_motor_r_reset0 & sig_motor_l_direction0 & sig_motor_l_reset0;
	follower_output_vec <= sig_motor_r_direction1 & sig_motor_r_reset1 & sig_motor_l_direction1 & sig_motor_l_reset1;
	
	u4: mux2
	port map (
		sel => mux_sel_sig,
		a => finder_output_vec,
		b => follower_output_vec,
		y => sig_motor_out
	);

	-- unpack vector
	sig_motor_r_direction_out <= sig_motor_out(3);
	sig_motor_l_direction_out <= sig_motor_out(1);
	
	process(reset, sig_motor_out)
        begin
        if reset = '1' then -- when reset is on turn off the motors
            sig_motor_r_reset_out <= '0';
            sig_motor_l_reset_out <= '0';
        else
            sig_motor_r_reset_out <= sig_motor_out(2);
            sig_motor_l_reset_out <= sig_motor_out(0);
        end if;
	end process;

	u5: pwm_middleman -- left servo
	port map (	
		clk => clk,
		reset1 => sig_motor_r_reset_out,
		reset2 => sig_motor_l_reset_out,
		dir1 => sig_motor_r_direction_out,
		dir2 => sig_motor_l_direction_out,

		motor_r_pwm => motor_r_pwm, -- out to servos
		motor_l_pwm => motor_l_pwm, -- out to servos
		timeup_fsm => timeup -- out to fsm_controller
	);

	mux_sel <= mux_sel_sig;
end structural;