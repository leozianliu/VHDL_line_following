library IEEE;
use IEEE.std_logic_1164.all;

entity output_control is
	port (	input			: in	std_logic_vector (7 downto 0);
		buttons_valid		: in	std_logic;
		display_data_mux_sel	: in	std_logic_vector (1 downto 0);

		output			: out	std_logic_vector (7 downto 0)
	);
end entity output_control;

architecture behaviour of output_control is
begin

	-- Always enable the first two displays (show the input values), but only enable
	-- the other two displays (the result) if we have detected a valid buttoncombination

	process (input, buttons_valid, display_data_mux_sel)
	begin
		if (display_data_mux_sel = "00" or display_data_mux_sel = "01" or buttons_valid = '1') then
			output	<= input;
		else
			output	<= "11111111";
		end if;
	end process;
end architecture behaviour;
