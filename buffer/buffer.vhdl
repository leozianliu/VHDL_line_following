library IEEE;
use IEEE.std_logic_1164.all;

entity buffer_entity is
    port (
        clk: in std_logic;
        reset: in std_logic;
        d: in std_logic_vector(2 downto 0);
        q: out std_logic_vector(2 downto 0)
    );
end buffer_entity;

architecture structural of buffer_entity is
    component bit3_register is
        port (
            clk: in std_logic;
            reset: in std_logic;
            d: in std_logic_vector(2 downto 0);
            q: out std_logic_vector(2 downto 0)
        );
    end component;
    
    signal q1: std_logic_vector(2 downto 0);

begin
    p1 : bit3_register port map (clk => clk, reset => reset, d => d, q => q1);
    p2 : bit3_register port map (clk => clk, reset => reset, d => q1, q => q);
end structural;