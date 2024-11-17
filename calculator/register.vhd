library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg is

port(	clk:	in std_logic;
	reset:	in std_logic;
	new_count:   in std_logic_vector (20 downto 0);
	count:  out std_logic_vector (20 downto 0)
);

end reg;

architecture behavioural of reg is

begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				count <= (others => '0');
			else
				count <= new_count;
			end if;
		end if;


	end process;


end architecture behavioural;
