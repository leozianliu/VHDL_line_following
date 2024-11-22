library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_tester is
    port (	clk		: in	std_logic;

        reset_but	: in	std_logic;
        dir		: in	std_logic;

        motor_r_pwm	: out	std_logic;
        motor_l_pwm	: out	std_logic
    );
end entity pwm_tester;

architecture structural of pwm_tester is

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

signal reset, direction, output: std_logic;
signal count: std_logic_vector (20 downto 0);
signal motor_r_pwm_sig, motor_l_pwm_sig: std_logic;

begin

direction <= dir;

process(clk, reset_but)
begin
	if rising_edge(clk) then
		if unsigned(count) >= to_unsigned(2000000, 21) then
			reset <= '1';
        elsif reset_but = '1' then
            reset <= '1';
        else
			reset <= '0';
		end if;
	end if;
end process;

lbl0: counter port map (clk => clk,
			reset => reset,
			count_out => count);

lbl1: pwm_generator port map (clk => clk,
			reset => reset,
			direction => direction,
			count_in => count,
			pwm => motor_r_pwm_sig);

lbl2: pwm_generator port map (clk => clk,
			reset => reset,
			direction => direction,
			count_in => count,
			pwm => motor_l_pwm_sig);

motor_r_pwm <= motor_r_pwm_sig;
motor_l_pwm <= motor_l_pwm_sig;

end architecture structural;
