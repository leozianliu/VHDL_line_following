library IEEE;
use IEEE.std_logic_1164.all;

entity calculator_tb is
end entity calculator_tb;

architecture structural of calculator_tb is

	component calculator is
		port (	clk		: in	std_logic;

			reset_button	: in	std_logic;
			buttons		: in	std_logic_vector (3 downto 0);
			switches	: in	std_logic_vector (7 downto 0);

			display_data	: out	std_logic_vector (7 downto 0);
			display_enable	: out	std_logic_vector (3 downto 0)
		);
	end component calculator;

	signal	clk			: std_logic;
	signal	reset_button		: std_logic;
	signal	buttons			: std_logic_vector (3 downto 0);
	signal	switches		: std_logic_vector (7 downto 0);
	signal	display_data		: std_logic_vector (7 downto 0);
	signal	display_enable		: std_logic_vector (3 downto 0);

begin

lbl0:	calculator	port map (	clk		=> clk,
					reset_button	=> reset_button,
					buttons		=> buttons,
					switches	=> switches,
					display_data	=> display_data,
					display_enable	=> display_enable
			);

	clk		<= 	'0' after 0 ns,
		   		'1' after 5 ns when clk /= '1' else
				'0' after 5 ns;

	reset_button	<=	'1' after 0 ns,
				'0' after 40 ns;

	switches	<=	"10100010" after 0 ns;

	buttons		<=	"0000" after  0 ns,
				"1000" after 40 ns,
				"0100" after 10 ms,
				"0010" after 20 ms,
				"0001" after 30 ms,
				"1001" after 40 ms;

end architecture structural;
