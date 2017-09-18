library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity genericSub is
	Port(
			a: in std_logic_vector(7 downto 0);
			b: in std_logic_vector (7 downto 0);
			c: out std_logic_vector (7 downto 0)
	);
end genericSub;



architecture Behavioral of genericSub is


signal sig_C, not_sig_C: STD_LOGIC_VECTOR(8 downto 0);


begin

sig_C <= ('0' & a) - ('0' & b);
not_sig_C <= ('0' & b) - ('0' & a);

with sig_c(8) select
	c <= sig_c(7 downto 0) when '0',
	     not_sig_c(7 downto 0) when OTHERS;

end Behavioral;