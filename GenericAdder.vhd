library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity genericAdd is
	generic(
				width : integer
	);
	port(
			a: in std_logic_vector(width-1 downto 0);
			b: in std_logic_vector(width-1 downto 0);
			c: out std_logic_vector(width downto 0)
	);
end genericAdd;

architecture Behavioral of genericAdd is


begin
	
	c <= ('0' & a) + ('0' & b);

end Behavioral;