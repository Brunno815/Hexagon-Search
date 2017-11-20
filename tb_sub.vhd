LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_sub IS
END tb_sub;

ARCHITECTURE behavior2 OF tb_sub IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT genericSub
    PORT(
         a: IN std_logic_vector(7 downto 0);
         b: IN std_logic_vector(7 downto 0);
         c: OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal a: std_logic_vector(7 downto 0);
   signal b: std_logic_vector(7 downto 0);

 	--Outputs
   signal c: std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: genericSub PORT MAP (
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

