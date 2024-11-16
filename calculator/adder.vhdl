library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is
	port (	input_0	: in	std_logic_vector (3 downto 0);
		input_1	: in	std_logic_vector (3 downto 0);
		output	: out	std_logic_vector (7 downto 0)
	);
end entity adder;

architecture behavioural of adder is
begin
	-- Addition is only defined for numbers, in this case unsigneds. The result should be an
	-- 8-bit number, so it has to be resized to 8-bit
	output	<= std_logic_vector (resize (unsigned (input_0), 8) + resize (unsigned (input_1), 8));

end architecture behavioural;
