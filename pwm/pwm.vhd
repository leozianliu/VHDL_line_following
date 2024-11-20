library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_generator is
	port (clk: in std_logic;
		reset: in std_logic;
		direction: in std_logic;
		count_in: in std_logic_vector (20 downto 0);
		pwm: out std_logic);

end entity pwm_generator;

architecture behavioural of pwm_generator is

	signal T: unsigned (20 downto 0);
	signal wait_state: std_logic;
	signal reset_state: std_logic;

type state_type is (reset_state, wait_state);
signal next_state, current_state: state_type;


begin

	state_reg: process(clk)
begin
	if (rising_edge(clk)) then
		current_state <= next_state;
	end if;
end process;

comb_logic: process(current_state)
begin

	case current_state is

		when wait_state => pwm <= '1'
			if unsigned(count_in) < T then
			next_state <= wait_state;
			else next_state <= reset_state;
				end if;

		when reset_state => pwm <= '0';
			if reset='1' then
			next_state <= wait_state;
			else next_state <= reset_state;
			end if ;
	end case;

	process(wait_state)
	begin
    if direction = '1' then
        T <= resize(to_unsigned(2, T'length) * 100000, T'length);
    else
        T <= resize(to_unsigned(1, T'length) * 100000, T'length);
    end if;
	end process;
	
end architecture behavioural;
