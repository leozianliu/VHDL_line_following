library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm_controller is
	port (clk: in std_logic;
		reset: in std_logic;
                count_in: in std_logic_vector (20 downto 0);
                c0:in std_logic; 
                c1: in std_logic;
                c2: in std_logic;
		dir1: out std_logic;
                dir2: out std_logic;
		reset1: out std_logic;
                reset2: out std_logic);

end entity  fsm_controller;


architecture behavioural of fsm_controller is
signal T: unsigned (20 downto 0);

type state_type is (S0, L, R, F, SR, SL);
signal Nextstate, State: state_type;
signal Timeup: std_logic;

begin

process(Clk) is
begin
    if rising_edge(Clk) then
        if Timeup = '0' then
            State <= S0;
 
        else
            State <= NextState;
 
        end if;
    end if;
end process;
 
process(State, c0, c1, c2, Drive) is
begin
    NextState <= State;
 
    case State is
 
        when S0 => -- reset state (check sensors)
            reset1<='1';
            reset2<='1';

	    if (not(c0 = '1' and c1 = '1' and c2 = '1')) or
   (not(c0 = '1' and c2 = '1') and c1 = '1') or
   (c0 = '1' and c2 = '1' and not(c1 = '1')) or
   (c0 = '1' and c1 = '1' and c2 = '1') then
    NextState <= F;
elsif (not(c0 = '1' and c1 = '1') and c2 = '1') then
    NextState <= L;
elsif (not(c0 = '1') and c1 = '1' and c2 = '1') then
    NextState <= SL;
elsif (c0 = '1' and not(c2 = '1' and c1 = '1')) then
    NextState <= R;
elsif (c0 = '1' and c2 = '1' and not(c1 = '1')) then
    NextState <= SR;
end if;

       
		when F =>
		   dir1<='0';
                   reset1<='0';
                   dir2<='1';
                   reset2<='0';
		NextState <= S0;
		when L =>
		   dir1<='0';
                        reset1<='0';
                        reset2<='1';
		
		when R =>
		   reset1<='1';
                        dir2<='1';
                        reset2<='0';
		
		when SL =>
		   dir1<='0';
                        reset1<='0';
                        dir2<='0';
                        reset2<='0';
		
		when SR =>
		   dir1<='1';
                        reset1<='0';
                        dir2<='1';
                        reset2<='0';
 	end case;
    end case;
end process; 
end architecture behavioural;