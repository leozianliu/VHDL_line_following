library IEEE;
use IEEE.std_logic_1164.all;

entity line_finder is
	port (	clk		: in	std_logic;
		sensor_in	: in	std_logic_vector(2 downto 0);
		reset		: in	std_logic;
		goto_pl_state	: in	std_logic;

		dir1			: out	std_logic;
		dir2			: out	std_logic;
		reset1			: out	std_logic;
		reset2			: out	std_logic;
		previous_c0		: out	std_logic;
		previous_c1		: out	std_logic;
		previous_c2		: out	std_logic;
		line_finder_done	: out   std_logic
	);
end entity line_finder;


architecture behavioural of line_finder is 
	type state_type is (FL, PL, SL, SR, LF);
	signal NextState, State: state_type;
	signal old_c0, old_c1, old_c2, c0, c1, c2, done, motor_r, motor_l, reset_r, reset_l: std_logic := '0';

begin 
	process(clk) is
	begin
		if (rising_edge(clk)) then
			c0 <= sensor_in(0);
			c1 <= sensor_in(1);
			c2 <= sensor_in(2);

			dir1 <= motor_r;
			dir2 <= motor_l;
			
			previous_c0 <= old_c0;
			previous_c1 <= old_c1;
			previous_c2 <= old_c2;

			line_finder_done <= done;

			reset1 <= reset_r;
			reset2 <= reset_l;

			State <= NextState;
		end if;
	end process;

	process(State, c0, c1, c2, goto_pl_state, reset) is 
	begin
		case State is 
			when FL =>
				motor_r <= '0';
               	reset_r <= '1';
                motor_l <= '1';
                reset_l <= '1';
				done <= '0';

				if (reset = '1') then
					NextState <= FL;
				elsif goto_pl_state = '1' then -- has higher priority
					NextState <= PL;
				elsif (c0 = '0' and c1 = '1' and c2 = '0') then
					NextState <= LF;
				elsif (c0 = '0' and c1 = '0' and c2 = '0') then
					NextState <= FL;
				else
					NextState <= PL;
				end if;

			when PL =>
				reset_r <= '0';
                reset_l <= '0';
				done <= '0';

				if (reset = '1') then
					NextState <= FL;
				elsif goto_pl_state = '1' then -- has higher priority
					NextState <= PL;
				elsif not(c0 = '0' and c1 = '0' and c2 = '0') then
					NextState <= PL;
				else
					if ((old_c0 = '0' and old_c1 = '0' and old_c2 = '1') or (old_c0 = '0' and old_c1 = '1' and old_c2 = '1')) then
						NextState <= SR;
					else
						NextState <= SL;	
					end if;
				end if;

			when SR =>
				motor_r <= '1';
                reset_r <= '1';
                motor_l <= '1';
                reset_l <= '1';
				done <= '0';
				if (reset = '1') then
					NextState <= FL;
				elsif goto_pl_state = '1' then -- has higher priority
					NextState <= PL;
				elsif (c0 = '0' and c1 = '0' and c2 = '0') then
					NextState <= SR;
				else
					NextState <= LF;
				end if;

			when SL =>

				motor_r <= '0';
                reset_r <= '1';
                motor_l <= '0';
                reset_l <= '1';
				done <= '0';
				if (reset = '1') then
					NextState <= FL;
				elsif goto_pl_state = '1' then -- has higher priority
					NextState <= PL;
				elsif (c0 = '0' and c1 = '0' and c2 = '0') then
					NextState <= SL;
				else
					NextState <= LF;
				end if;
			when LF =>
				done <= '1';
				reset_r <= '0'; -- off
                reset_l <= '0'; -- off
				motor_r <= '0'; -- not care
				motor_l <= '0'; -- not care
				if (reset = '1') then
					NextState <= FL;
				elsif goto_pl_state = '1' then -- has higher priority
					NextState <= PL;
				else
					NextState <= LF;
				end if;
			end case;

		if not(c0 = '0' and c1 = '0' and c2 = '0') then
			old_c0 <= c0;
			old_c1 <= c1;
			old_c2 <= c2;
		end if;

	end process;
end architecture behavioural;