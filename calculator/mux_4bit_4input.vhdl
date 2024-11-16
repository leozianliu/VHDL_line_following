library IEEE;
use IEEE.std_logic_1164.all;


entity mux_4bit_4input is
	port (	input_0	: in	std_logic_vector (3 downto 0);
		input_1	: in	std_logic_vector (3 downto 0);
		input_2	: in	std_logic_vector (3 downto 0);
		input_3	: in	std_logic_vector (3 downto 0);
		sel	: in	std_logic_vector (1 downto 0);
		output	: out	std_logic_vector (3 downto 0)
	);
end entity mux_4bit_4input;

architecture behavioural of mux_4bit_4input is
begin

	process (input_0, input_1, input_2, input_3, sel)
	begin
		case sel is
			when "00"	=> output <= input_0;
			when "01"	=> output <= input_1;
			when "10"	=> output <= input_2;
			when "11"	=> output <= input_3;
			when others	=> output <= "0000";
		end case;
	end process;

end architecture behavioural;
