library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2 is
    Port ( sel : in STD_LOGIC;
           a   : in STD_LOGIC_VECTOR(3 downto 0);
           b   : in STD_LOGIC_VECTOR(3 downto 0);
           y   : out STD_LOGIC_VECTOR(3 downto 0));
end entity mux2;

architecture Behavioral of mux2 is
begin
    process(sel, a, b)
    begin
        if sel = '0' then
            y <= a;
        else
            y <= b;
        end if;
    end process;
end Behavioral;
