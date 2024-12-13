library IEEE;
use IEEE.std_logic_1164.all;

entity bit3_register is
    port (
        clk: in std_logic;
        reset: in std_logic;
        d: in std_logic_vector(2 downto 0);
        q: out std_logic_vector(2 downto 0)
    );
end bit3_register;

architecture behavioral of bit3_register is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q <= (others => '0'); -- reset to 1 which is white, so line finder doesn't get confused
        elsif clk'event and clk = '1' then
            q <= d; -- invert because initialization is fucked
        end if;
    end process;
end behavioral;
