library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplier is
	port (	input_0	: in	std_logic_vector (3 downto 0);
		input_1	: in	std_logic_vector (3 downto 0);
		output	: out	std_logic_vector (7 downto 0)
	);
end entity multiplier;

architecture behavioural of multiplier is
begin

	-- Multiplication is only defined for numbers, in this case unsigneds
	output	<= std_logic_vector (unsigned (input_0) * unsigned (input_1));

end architecture behavioural;
