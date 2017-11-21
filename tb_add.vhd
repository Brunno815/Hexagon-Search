--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:40:57 11/20/2017
-- Design Name:   
-- Module Name:   /home/brunno/TCC/Hexagon-Search/tb_add.vhd
-- Project Name:  Hexagon-Search
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: genericAdder
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_add IS
END tb_add;
 
ARCHITECTURE behavior OF tb_add IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT genericAdd
		generic(
			width : integer
		);
		port(
				a: in std_logic_vector(width-1 downto 0);
				b: in std_logic_vector(width-1 downto 0);
				c: out std_logic_vector(width downto 0)
		);
    END COMPONENT;
    
	 signal w: integer := 8;

   --Inputs
   signal a : std_logic_vector(w-1 downto 0) := (others => '0');
   signal b : std_logic_vector(w-1 downto 0) := (others => '0');

 	--Outputs
   signal c : std_logic_vector(w downto 0);

   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: genericAdd GENERIC MAP(
			width => 8
	)
	PORT MAP (
          a => a,
          b => b,
          c => c
        );

   stim_proc: process
   begin		
		a <= "00101001";
		b <= "00001001";
		wait for CLK_period*2;
		a <= "10001010";
		b <= "01111100";
      wait;
   end process;

END;
