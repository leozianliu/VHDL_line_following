----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2024 11:25:47 AM
-- Design Name: 
-- Module Name: xor_xnor - Behavioral
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

entity xor_xnor is
    port (	input_0			: in	std_logic_vector (3 downto 0);
                    input_1			: in	std_logic_vector (3 downto 0);
                    output_0			: out	std_logic_vector (3 downto 0);
                    output_1			: out	std_logic_vector (3 downto 0)
                );
end xor_xnor;

architecture Behavioral of xor_xnor is

begin

    output_0 <= input_0 xor input_1;
    output_1 <= input_0 xnor input_1;
    
end Behavioral;
