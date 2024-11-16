library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity divider is
	port (	input_0	: in	std_logic_vector (3 downto 0);
		input_1	: in	std_logic_vector (3 downto 0);
		output	: out	std_logic_vector (7 downto 0)
	);
end entity divider;

architecture behavioural of divider is
begin

	-- Calculate both quotient and remainder for input_0/input_1
	output(3 downto 0) <= std_logic_vector (unsigned (input_0) / unsigned(input_1));
	output(7 downto 4) <= std_logic_vector (unsigned (input_0) mod unsigned(input_1));

end architecture behavioural;
