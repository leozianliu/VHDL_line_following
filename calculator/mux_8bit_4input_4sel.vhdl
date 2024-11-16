library IEEE;
use IEEE.std_logic_1164.all;


entity mux_8bit_4input_4sel is
	port (	input_0	: in	std_logic_vector (7 downto 0);
		input_1	: in	std_logic_vector (7 downto 0);
		input_2	: in	std_logic_vector (7 downto 0);
		input_3	: in	std_logic_vector (7 downto 0);
		input_4	: in	std_logic_vector (7 downto 0);
		input_5	: in	std_logic_vector (7 downto 0);
		input_6	: in	std_logic_vector (7 downto 0);
		input_7	: in	std_logic_vector (7 downto 0);
		sel	: in	std_logic_vector (4 downto 0);
		output	: out	std_logic_vector (7 downto 0)
	);
end entity mux_8bit_4input_4sel;

architecture behavioural of mux_8bit_4input_4sel is
begin

	process (input_0, input_1, input_2, input_3, sel)
	begin
		case sel is
			when "01000"	=> output <= input_0;
			when "00100"	=> output <= input_1;
			when "00010"	=> output <= input_2;
			when "00001"	=> output <= input_3;
			when "11000"	=> output <= input_4;
			when "10100"	=> output <= input_5;
			when "10010"	=> output <= input_6;
			when "10001"	=> output <= input_7;
			when others	=> output <= "00000000";
		end case;
	end process;

end architecture behavioural;
