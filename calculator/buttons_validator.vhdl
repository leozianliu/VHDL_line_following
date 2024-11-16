library IEEE;
use IEEE.std_logic_1164.all;

entity buttons_validator is
	port (	buttons		: in	std_logic_vector (3 downto 0);
		buttons_valid	: out	std_logic
	);
end entity buttons_validator;

architecture behavioural of buttons_validator is
begin

	process (buttons)
	begin
		if (buttons = "0001" or buttons = "0010" or buttons = "0100" or buttons = "1000") then
			buttons_valid	<= '1';
		else
			buttons_valid	<= '0';
		end if;
	end process;

end architecture behavioural;
