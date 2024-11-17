library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is

port(count: in std_logic_vector (20 downto 0);
		     new_count: out std_logic_vector (20 downto 0));

end adder;

architecture behavioural of adder is

begin

new_count <= std_logic_vector(unsigned(count)+1);

end architecture behavioural;
