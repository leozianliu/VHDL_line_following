library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_tb is
end entity pwm_tb;

architecture structural of pwm_tb is

	component pwm_generator is 
		port(	clk:	in std_logic;
			reset:	in std_logic;
			direction: in std_logic;
			count_in:   in std_logic_vector (20 downto 0);
			pwm: out std_logic
);
	end component pwm_generator;

	component counter is 
		port(	clk:	in std_logic;
			reset:	in std_logic;
			count_out:   out std_logic_vector (20 downto 0));
	end component counter;

signal clk, reset, direction, output: std_logic;
signal count: std_logic_vector (20 downto 0);

begin

clk <= '1' after 0 ns,
	'0' after 5 ns when clk /= '0' else '1' after 5 ns;

reset <= '1' after 0 ns,
	'0' after 100 ns,
	'1' after 1000 ns,
	'0' after 1500 ns;

direction <= '0' after 0 ns;

lbl0: counter port map (clk => clk,
			reset => reset,
			count_out => count);

lbl1: pwm_generator port map (clk => clk,
			reset => reset,
			direction => direction,
			count_in => count,
			pwm => output);

end architecture structural;
