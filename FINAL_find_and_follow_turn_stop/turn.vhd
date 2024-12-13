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
        previous_c0: in std_logic;
        previous_c1: in std_logic;
        previous_c2: in std_logic;
        dir1: out std_logic;
        dir2: out std_logic;
        reset1: out std_logic;
        reset2: out std_logic;
        detection_r_out: out std_logic;
        turning_r_out: out std_logic;
        detection_l_out: out std_logic;
        turning_l_out: out std_logic
    );
end entity line_follower;

architecture behavioural of line_follower is
    type state_type is (S0, L, R, F, SR, SL);
    signal Nextstate, State: state_type;
    signal detection_r, turning_r: std_logic := '0';
    signal detection_l, turning_l: std_logic := '0';
    signal end_line: std_logic := '0';

begin
    process(clk) is -- state transition logic
    begin
        if rising_edge(clk) then
            if reset = '1' then
                State <= S0;
            elsif turning_l = '1' then -- turn left!!!
                State <= SL;
            elsif turning_r = '1' then -- turn right!!!
                State <= SR;
            elsif end_line = '1' then -- end of line!!!
                State <= S0;
            elsif timeup = '1' then
                State <= S0;
            else
                State <= NextState;
            end if;
        end if;
    end process;

    process(clk) is -- when to turn? when to stop?
    begin
        if rising_edge(clk) then
            if detection_r = '1' then -- passed detection_r signal
                if ((previous_c0 = '0' and previous_c1 = '0' and previous_c2 = '0') and not(c0 = '0' and c1 = '0' and c2 = '0')) then -- sees bbb
                    detection_r <= '0';
                    turning_r <= '1';
                    detection_l <= '0';
                    turning_l <='0';
                elsif ((previous_c0 = '0' and previous_c1 = '1' and previous_c2 = '0') and not(c0 = '0' and c1 = '1' and c2 = '0')) then -- sees bwb turn signal, second detection
                    turning_r <='0';
                    turning_l <='0';
                    detection_r <= '0';
                    detection_l <= '1'; -- turn left now
                else -- keeps going
                    detection_r <= '1';
                    turning_r <='0';
                    detection_l <= '0';
                    turning_l <= '0';
                end if;

            elsif detection_l = '1' then -- passed detection_l signal
                if ((previous_c0 = '0' and previous_c1 = '0' and previous_c2 = '0') and not(c0 = '0' and c1 = '0' and c2 = '0')) then -- sees bbb
                    detection_r <= '0';
                    turning_r <='0';
                    detection_l <= '0';
                    turning_l <='1';
                else -- keeps going
                    detection_r <= '0';
                    turning_r <='0';
                    detection_l <= '1';
                    turning_l <='0';
                end if;
    
            elsif ((previous_c0 = '0' and previous_c1 = '1' and previous_c2 = '0') and not(c0 = '0' and c1 = '1' and c2 = '0')) then -- sees bwb turn signal
                if detection_r = '0' then -- first detection
                    turning_r <='0';
                    turning_l <='0';
                    detection_r <= '1'; -- turn right
                    detection_l <= '0';
--                else -- second detection
--                    turning_r <='0';
--                    turning_l <='0';
--                    detection_r <= '0';
--                    detection_l <= '1'; -- turn left now
                end if;
    
            elsif (turning_r = '1' and ((c0 = '1' and c1 = '1' and c2 = '0'))) then -- sees wwb or wbb, turn done
                    turning_r <='0';
                    turning_l <='0';
                    detection_r <= '0';
                    detection_l <= '0';

            elsif (turning_l = '1' and ((c0 = '0' and c1 = '1' and c2 = '1'))) then -- sees bww or bbw, turn done
                    turning_r <='0';
                    turning_l <='0';
                    detection_r <= '0';
                    detection_l <= '0';

            else
                    turning_r <= turning_r;
                    turning_l <= turning_l;
                    detection_r <= detection_r;
                    detection_l <= detection_l;
            end if;    

            if ((previous_c0 = '1' and previous_c1 = '0' and previous_c2 = '1') and (c0 = '1' and c1 = '1' and c2 = '1')) then -- end of line
                end_line <= '1'; -- never turn on the motors again
            else
                end_line <= '0';
            end if;
        end if;
    end process;

    process(State, c0, c1, c2, turning_r, turning_l) is
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

            when L =>
                dir1 <= '0';
                reset1 <= '1';
                dir2 <= '0'; -- dummy
                reset2 <= '0';
                NextState <= L;

            when R =>
                dir1 <= '0'; -- dummy
                reset1 <= '0';
                dir2 <= '1';
                reset2 <= '1';
                NextState <= R;

            when SL =>
                dir1 <= '0';
                reset1 <= '1';
                dir2 <= '0';
                reset2 <= '1';
                NextState <= SL;

--                if falling_edge(turning_l) then -- left turn done, go to S0
--                    NextState <= S0;
--                end if;

            when SR =>
                dir1 <= '1';
                reset1 <= '1';
                dir2 <= '1';
                reset2 <= '1';
                NextState <= SR;

--                if falling_edge(turning_r) then -- right turn done, go to S0
--                    NextState <= S0;
--                end if;
        end case;
    end process;

    detection_r_out <= detection_r;
    turning_r_out <= turning_r;
    detection_l_out <= detection_l;
    turning_l_out <= turning_l;
end architecture behavioural;

