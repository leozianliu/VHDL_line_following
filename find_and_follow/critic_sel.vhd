library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity critic_sel is
    Port ( 
        done : in STD_LOGIC;
        now_c   : in STD_LOGIC_VECTOR(2 downto 0);
        old_c0   : in STD_LOGIC;
        old_c1   : in STD_LOGIC;
        old_c2   : in STD_LOGIC;
        sel   : out STD_LOGIC;
        goto_pl_state : out STD_LOGIC);
end entity critic_sel;

architecture Behavioral of critic_sel is
begin
    process(done, now_c, old_c0, old_c1, old_c2)
    begin

        if done = '1' then
            if (now_c = "111" and ((old_c0 = '0' and old_c1 = '1' and old_c2 = '1') or (old_c0 = '1' and old_c1 = '1' and old_c2 = '0'))) then -- old_c should be wwb or bww to reach final state in finder fsm, can detect straying in follower
                sel <= '0'; -- activate finder
                goto_pl_state <= '1'; -- strayed away in follower, go to passline state in finder
            else -- still sees the line or 
                sel <= '1'; -- activate follower
                goto_pl_state <= '0'; -- don't go to passline state
            end if;
        else -- finder still running
            sel <= '0'; -- activate finder
            goto_pl_state <= '0'; -- don't go to passline state
        end if;
                
    end process;
end Behavioral;