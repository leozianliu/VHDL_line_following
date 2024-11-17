library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_tb is
end entity counter_tb;

architecture structural of counter_tb is

	component counter is 
		port(	clk:	in std_logic;
			reset:	in std_logic;
			count_out:   out std_logic_vector (20 downto 0)
);
	end component counter;
signal clk, reset : std_logic;
signal count_out: std_logic_vector (20 downto 0);

begin

clk <= '1' after 0 ns,
	'0' after 5 ns when clk /= '0' else '1' after 5 ns;

reset <= '1' after 0 ns,
	'0' after 100 ns,
	'1' after 400 ns,
	'0' after 500 ns;

lbl0: counter port map (clk => clk,
			reset => reset,
			count_out => count_out);

end architecture structural;