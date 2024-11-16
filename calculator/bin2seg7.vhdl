library IEEE;
use IEEE.std_logic_1164.all;

entity bin2seg7 is
	port (	bin	:	in	std_logic_vector (3 downto 0);
		seg7	:	out	std_logic_vector (7 downto 0)
	);
end entity bin2seg7;

architecture behavioural of bin2seg7 is

begin
	with bin select
		--  --A--           7-segment display         
		-- |     |
		-- F     B          Figure on the left shows
		-- |     |          conventional segment-
		--  --G--           numbering scheme.
		-- |     |          The segments are inverted,
		-- E     C          so a '1' means it's off
		-- |     |          while a '0' means it's on
		--  --D--  .H
		--
		--       HGFEDCBA
		seg7 <=	"11000000" when "0000",	-- 0
			"11111001" when "0001",	-- 1
			"10100100" when "0010",	-- 2
			"10110000" when "0011",	-- 3
			"10011001" when "0100",	-- 4
			"10010010" when "0101",	-- 5
			"10000010" when "0110",	-- 6
			"11111000" when "0111",	-- 7
			"10000000" when "1000",	-- 8
			"10010000" when "1001",	-- 9
			"10001000" when "1010",	-- A
			"10000011" when "1011",	-- B
			"11000110" when "1100",	-- C
			"10100001" when "1101",	-- D
			"10000110" when "1110",	-- E
			"10001110" when "1111",	-- F
			"11111111" when others;	-- Weird condition

end architecture behavioural;
