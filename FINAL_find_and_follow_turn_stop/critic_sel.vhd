library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity critic_sel is
    Port ( 
        done : in STD_LOGIC;
        now_c   : in STD_LOGIC_VECTOR(2 downto 0);
        old_c0   : in STD_LOGIC;
        old_c1   : in STD_LOGIC;
        old_c2   : in STD_LOGIC;
        sel   : out STD_LOGIC);
end entity critic_sel;

architecture Behavioral of critic_sel is
begin
    process(done, now_c, old_c0, old_c1, old_c2)
    begin

        if done = '1' then
            sel <= '1'; -- activate follower
        else -- finder still running
            sel <= '0'; -- activate finder
        end if;
                
    end process;
end Behavioral;