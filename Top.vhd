library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity top is
	Port(
			RST: in STD_LOGIC;
			CLK: in STD_LOGIC;
			input_vec_x: in STD_LOGIC_VECTOR((LINE_SIZE_CACHE - 1)
	);
end top;



architecture Behavioral of top is


signal sig_C, not_sig_C: STD_LOGIC_VECTOR(8 downto 0);


begin

sig_C <= ('0' & a) - ('0' & b);
not_sig_C <= ('0' & b) - ('0' & a);

with sig_c(8) select
	c <= sig_c(7 downto 0) when '0',
	     not_sig_c(7 downto 0) when OTHERS;

end Behavioral;