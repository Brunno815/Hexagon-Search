LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_sub IS
END tb_sub;

ARCHITECTURE behavior2 OF tb_sub IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT abs_ver
    PORT(
         a: IN std_logic_vector(7 downto 0);
         b: IN std_logic_vector(7 downto 0);
         c: OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
   signal a: std_logic_vector(7 downto 0);
   signal b: std_logic_vector(7 downto 0);

   signal c: std_logic_vector(7 downto 0);

   constant CLK_period : time := 10 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: abs_ver PORT MAP (
          a => a,
          b => b,
          c => c
        );


	teste: process
	begin
		a <= "10010011";
		b <= "01001010";
		wait for 30 ns;
		a <= "00000001";

		wait;
	end process;

END;

