library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity subtractor is
	port (	input_0	: in	std_logic_vector (3 downto 0);
		input_1	: in	std_logic_vector (3 downto 0);
		output	: out	std_logic_vector (7 downto 0)
	);
end entity subtractor;

architecture behavioural of subtractor is
begin

	-- Subtraction is only defined for numbers, in this case unsigneds. The result is an
	-- 8-bit number, so it is resized to 8-bit.
	output	<= std_logic_vector (resize (unsigned (input_0), 8) - resize (unsigned (input_1), 8));

end architecture behavioural;
