library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- important!!!
-- reset1/2 = 0 is stopping pwm generation

entity pwm_middleman is
    port (	clk		: in	std_logic;

        reset1	: in	std_logic;
		reset2	: in	std_logic;
        dir1		: in	std_logic;
		dir2        : in    std_logic;

        motor_r_pwm	: out	std_logic;
        motor_l_pwm	: out	std_logic;
		timeup_fsm  : out std_logic
    );
end entity pwm_middleman;

architecture structural of pwm_middleman is

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

signal reset_count, direction1, direction2: std_logic;
signal count: std_logic_vector (20 downto 0);
signal motor_r_pwm_sig, motor_l_pwm_sig: std_logic;

begin

direction1 <= dir1; -- right motor
direction2 <= dir2; -- sign fix for the left motor

process(clk)
begin
	if rising_edge(clk) then
		if unsigned(count) >= to_unsigned(2000000, 21) then
			reset_count <= '1';
		else
			reset_count <= '0';
		end if;
	end if;
end process;

lbl0: counter port map (clk => clk,
			reset => reset_count,
			count_out => count);

lbl1: pwm_generator port map (clk => clk,
			reset => reset1,
			direction => direction1,
			count_in => count,
			pwm => motor_r_pwm_sig);

lbl2: pwm_generator port map (clk => clk,
			reset => reset2,
			direction => direction2,
			count_in => count,
			pwm => motor_l_pwm_sig);

motor_r_pwm <= motor_r_pwm_sig;
motor_l_pwm <= motor_l_pwm_sig;

timeup_fsm <= reset_count;
end architecture structural;
