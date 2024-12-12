library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity line_follower is
    port (
        clk: in std_logic;
        reset: in std_logic;
        timeup: in std_logic;
        c0: in std_logic; 
        c1: in std_logic;
        c2: in std_logic;
        dir1: out std_logic;
        dir2: out std_logic;
        reset1: out std_logic;
        reset2: out std_logic;
        detection_out: out std_logic;
        turning_out: out std_logic
    );
end entity line_follower;

architecture behavioural of line_follower is
    type state_type is (S0, L, R, F, SR, SL);
    signal Nextstate, State: state_type;
    signal detection, turning: std_logic := '0';

begin
    process(clk) is
    begin
        if rising_edge(clk) then
	    detection_out <= detection;
    	    turning_out <= turning;
            if reset = '1' then
                State <= S0;
            elsif timeup = '1' then
                State <= S0;
            else
                State <= NextState;
            end if;
        end if;
    end process;

    process(State, c0, c1, c2) is
    begin
        
        case State is
            when S0 => -- reset state (check sensors)
                reset1 <= '0';
                reset2 <= '0';
                dir1 <= '0'; -- dummy
                dir2 <= '0'; -- dummy

                if (c0 = '0' and c1 = '0' and c2 = '1') then
                    NextState <= L;
                elsif (c0 = '0' and c1 = '1' and c2 = '1') then
                    NextState <= SL;
                elsif (c0 = '1' and c2 = '0' and c1 = '0') then
                    NextState <= R;
                elsif (c0 = '1' and c1 = '1' and c2 = '0') then
                    NextState <= SR;
                else
                    NextState <= F;
                end if;
		if turning = '1' then
			NextState <= SR;
		end if;

            when F =>
                dir1 <= '0';
                reset1 <= '1';
                dir2 <= '1';
                reset2 <= '1';
		if (c0 = '0' and c1 = '0' and c2 = '1') then
                    NextState <= L;
                elsif (c0 = '0' and c1 = '1' and c2 = '1') then
                    NextState <= SL;
                elsif (c0 = '1' and c2 = '0' and c1 = '0') then
                    NextState <= R;
                elsif (c0 = '1' and c1 = '1' and c2 = '0') then
                    NextState <= SR;
                else
                    NextState <= F;
                end if;
		if turning = '1' then
			NextState <= SR;
		end if;

            when L =>
                dir1 <= '0';
                reset1 <= '1';
                dir2 <= '0'; -- dummy
                reset2 <= '0';

            when R =>
                dir1 <= '0'; -- dummy
                reset1 <= '0';
                dir2 <= '1';
                reset2 <= '1';

            when SL =>
                dir1 <= '0';
                reset1 <= '1';
                dir2 <= '0';
                reset2 <= '1';

            when SR =>
                dir1 <= '1';
                reset1 <= '1';
                dir2 <= '1';
                reset2 <= '1';
		if turning = '0' then
			NextState <= S0;
		end if;
        end case;
        
        if (c0 = '0' and c1 = '1' and c2 = '0') then
                    detection <= '1';
        end if;

	if detection = '1' then
		if (c0 = '0' and c1 = '0' and c2 = '0') then
                	detection <= '0';
		        turning <='1';
		else
		        detection <= '1';
		        turning <='0';
		end if;
	end if;

	if ((turning='1' and c0 = '1' and c1 = '1' and c2 = '0')) then
			turning <='0';
	end if;

    
    end process;
end architecture behavioural;

