library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity top is
	Port(
			RST				: in STD_LOGIC;
			CLK				: in STD_LOGIC;
			in_lines_a		: in line_cache;
			in_lines_b		: in line_cache;
			cache_ready		: in STD_LOGIC;
			pu					: in t_pu;
			initial_vec		: in m_vec;
			bestVec			: out m_vec;
			out_sad_test	: out STD_LOGIC_VECTOR(19 downto 0);
			addr_to_cache	: out STD_LOGIC_VECTOR(NR_BITS_ADDR-NR_BITS_ASSOC-1 downto 0);
			tag				: out STD_LOGIC_VECTOR(NR_BITS_TAG-1 downto 0);
			done				: out STD_LOGIC
	);
end top;



architecture Behavioral of genericSub is


signal sig_C, not_sig_C: STD_LOGIC_VECTOR(8 downto 0);


begin

sig_C <= ('0' & a) - ('0' & b);
not_sig_C <= ('0' & b) - ('0' & a);

with sig_c(8) select
	c <= sig_c(7 downto 0) when '0',
	     not_sig_c(7 downto 0) when OTHERS;

end Behavioral;