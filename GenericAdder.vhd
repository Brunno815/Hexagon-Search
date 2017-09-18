library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity genericAdder is
	generic(
				widthX : integer
	);
	port(
			a: in std_logic_vector(widthX-1 downto 0);
			b: in std_logic_vector(widthX-1 downto 0);
			c: out std_logic_vector(widthX downto 0)
	);
end genericAdder;

architecture Behavioral of genericAdder is


begin
	
	c <= ('0' & a) + ('0' & b);

end Behavioral;