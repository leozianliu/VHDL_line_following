library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display_controller is
	port (	clk			: in	std_logic;	
		reset			: in	std_logic;

		display_data_mux_sel	: out	std_logic_vector (1 downto 0);
		display_enable		: out	std_logic_vector (3 downto 0)
	);
end entity display_controller;

architecture behavioural of display_controller is

	type	display_controller_state is (	prepare_disp_0_state, disp_0_state,
						prepare_disp_1_state, disp_1_state,
						prepare_disp_2_state, disp_2_state,
						prepare_disp_3_state, disp_3_state,
						reset_state);

	signal	state, new_state	: display_controller_state;

	-- Drive each display 1 ms. With 100 MHz clk freq this gives max_count of 100000
	constant max_count		: integer := 100000;

	signal	count, new_count	: unsigned (17 downto 0);
	signal	count_reset, count_done	: std_logic;
begin

	process (clk) is
	begin
		if (rising_edge (clk)) then
			if (reset = '1') then
				state	<= reset_state;
				count	<= (others => '0');
			else
				state	<= new_state;
				if (count_reset = '1') then
					count	<= (others => '0');
				else
					count	<= new_count;
				end if;
			end if;
		end if;
	end process;

	process (count) is
	begin
		if (count < max_count) then
			new_count	<= count + 1;
			count_done	<= '0';
		else
			new_count	<= count;
			count_done	<= '1';
		end if;
	end process;

	-- The displays have 4 common datalines. In order to show information on
	-- each of the displays, each display should be on for 25% of the total time
	-- In the prepare states, the controller puts the correct data on the datalines
	-- but turns off all displays. In the next state the enable signal of the
	-- required display is turned on. Each display is turned on for 50000 cycles

	process (state, count_done) is
	begin
		case state is
			when reset_state		=>
				display_data_mux_sel	<= "00";
				display_enable		<= "1111";
				count_reset		<= '1';

				new_state		<= prepare_disp_0_state;

			when prepare_disp_0_state	=>
				display_data_mux_sel	<= "00";
				display_enable		<= "1111";
				count_reset		<= '1';

				new_state		<= disp_0_state;

			when disp_0_state		=>
				display_data_mux_sel	<= "00";
				display_enable		<= "0111";
				count_reset		<= '0';

				if (count_done = '1') then
					new_state	<= prepare_disp_1_state;
				else
					new_state	<= disp_0_state;
				end if;

			when prepare_disp_1_state	=>
				display_data_mux_sel	<= "01";
				display_enable		<= "1111";
				count_reset		<= '1';

				new_state		<= disp_1_state;

			when disp_1_state		=>
				display_data_mux_sel	<= "01";
				display_enable		<= "1011";
				count_reset		<= '0';

				if (count_done = '1') then
					new_state	<= prepare_disp_2_state;
				else
					new_state	<= disp_1_state;
				end if;

			when prepare_disp_2_state	=>
				display_data_mux_sel	<= "10";
				display_enable		<= "1111";
				count_reset		<= '1';

				new_state		<= disp_2_state;

			when disp_2_state		=>
				display_data_mux_sel	<= "10";
				display_enable		<= "1101";
				count_reset		<= '0';

				if (count_done = '1') then
					new_state	<= prepare_disp_3_state;
				else
					new_state	<= disp_2_state;
				end if;

			when prepare_disp_3_state	=>
				display_data_mux_sel	<= "11";
				display_enable		<= "1111";
				count_reset		<= '1';

				new_state		<= disp_3_state;

			when disp_3_state		=>
				display_data_mux_sel	<= "11";
				display_enable		<= "1110";
				count_reset		<= '0';

				if (count_done = '1') then
					new_state	<= prepare_disp_0_state;
				else
					new_state	<= disp_3_state;
				end if;

			when others			=>
				display_data_mux_sel	<= "00";
				display_enable		<= "1111";
				count_reset		<= '1';

				new_state		<= prepare_disp_0_state;

		end case;
	end process;
end architecture behavioural;
