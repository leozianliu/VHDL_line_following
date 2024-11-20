library IEEE;
use IEEE.std_logic_1164.all;

entity buffer_tb is
end entity buffer_tb;

architecture structural of buffer_tb is

    component buffer_entity is
        port (
            clk: in std_logic;
            reset: in std_logic;
            d: in std_logic_vector(2 downto 0);
            q: out std_logic_vector(2 downto 0)
        );
    end component buffer_entity;

    signal clk: std_logic;
    signal reset: std_logic;
    signal d: std_logic_vector(2 downto 0);
    signal q: std_logic_vector(2 downto 0);

begin

    lbl0: buffer_entity
        port map (
            clk => clk,
            reset => reset,
            d => d,
            q => q
        );

    clk <= '0' after 0 ns,
           '1' after 5 ns when clk /= '1' else
           '0' after 5 ns;

    reset <= '1' after 0 ns,
             '0' after 40 ns,
             '1' after 95 ns;

    d <= "010" after 0 ns,
         "101" after 42 ns,
         "111" after 48 ns,
         "011" after 61 ns,
         "111" after 64 ns,
         "000" after 70 ns;

end architecture structural;