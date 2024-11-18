library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is

port(	clk:	in std_logic;
	reset:	in std_logic;
	count_out:   out std_logic_vector (20 downto 0)
);

end counter;

architecture structural of counter is

	component adder is
		port(count: in std_logic_vector (20 downto 0);
		     new_count: out std_logic_vector (20 downto 0));
	end component adder;

	component reg is
		port(clk: in std_logic;
		     reset: in std_logic;
		     new_count: in std_logic_vector (20 downto 0);
		     count: out std_logic_vector (20 downto 0));
	end component reg;

signal int_count, output: std_logic_vector (20 downto 0);

begin

lbl0: reg port map (clk => clk,
		    reset => reset,
		    new_count => int_count,
		    count => output);

lbl1: adder port map(count => output,
		     new_count => int_count);

count_out <= output;


end architecture structural;