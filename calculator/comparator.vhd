----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2024 11:25:47 AM
-- Design Name: 
-- Module Name: comparator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparator is
    port (	input_0			: in	std_logic_vector (3 downto 0);
                input_1			: in	std_logic_vector (3 downto 0);
                output			: out	std_logic_vector (7 downto 0)
            );
end comparator;

architecture Behavioral of comparator is

begin

    if (input_0 < input_1) then
        output <= '11111111';
    elsif (input_0 = input_1) then
        output <= '00000000';
    elsif (input_0 > input_1) then
        output <= '00010001';

end Behavioral;
