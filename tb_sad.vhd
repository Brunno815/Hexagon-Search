--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:18:51 11/20/2017
-- Design Name:   
-- Module Name:   /home/brunno/TCC/Hexagon-Search/tb_sad.vhd
-- Project Name:  Hexagon-Search
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SAD
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
 
ENTITY tb_sad IS
END tb_sad;
 
ARCHITECTURE behavior OF tb_sad IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SAD
    PORT(
         RST : IN  std_logic;
         CLK : IN  std_logic;
         ORG0 : IN  std_logic_vector(7 downto 0);
         ORG1 : IN  std_logic_vector(7 downto 0);
         ORG2 : IN  std_logic_vector(7 downto 0);
         ORG3 : IN  std_logic_vector(7 downto 0);
         ORG4 : IN  std_logic_vector(7 downto 0);
         ORG5 : IN  std_logic_vector(7 downto 0);
         ORG6 : IN  std_logic_vector(7 downto 0);
         ORG7 : IN  std_logic_vector(7 downto 0);
         REF0 : IN  std_logic_vector(7 downto 0);
         REF1 : IN  std_logic_vector(7 downto 0);
         REF2 : IN  std_logic_vector(7 downto 0);
         REF3 : IN  std_logic_vector(7 downto 0);
         REF4 : IN  std_logic_vector(7 downto 0);
         REF5 : IN  std_logic_vector(7 downto 0);
         REF6 : IN  std_logic_vector(7 downto 0);
         REF7 : IN  std_logic_vector(7 downto 0);
			stop_ignoring : IN std_logic;
         stop_accum : IN  std_logic;
         out_sad : OUT  std_logic_vector(19 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';
   signal ORG0 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG1 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG2 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG3 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG4 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG5 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG6 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG7 : std_logic_vector(7 downto 0) := (others => '0');
   signal REF0 : std_logic_vector(7 downto 0) := (others => '0');
   signal REF1 : std_logic_vector(7 downto 0) := (others => '0');
   signal REF2 : std_logic_vector(7 downto 0) := (others => '0');
   signal REF3 : std_logic_vector(7 downto 0) := (others => '0');
   signal REF4 : std_logic_vector(7 downto 0) := (others => '0');
   signal REF5 : std_logic_vector(7 downto 0) := (others => '0');
   signal REF6 : std_logic_vector(7 downto 0) := (others => '0');
   signal REF7 : std_logic_vector(7 downto 0) := (others => '0');
	signal stop_ignoring : std_logic := '1';
   signal stop_accum : std_logic := '0';

 	--Outputs
   signal out_sad : std_logic_vector(19 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SAD PORT MAP (
          RST => RST,
          CLK => CLK,
          ORG0 => ORG0,
          ORG1 => ORG1,
          ORG2 => ORG2,
          ORG3 => ORG3,
          ORG4 => ORG4,
          ORG5 => ORG5,
          ORG6 => ORG6,
          ORG7 => ORG7,
          REF0 => REF0,
          REF1 => REF1,
          REF2 => REF2,
          REF3 => REF3,
          REF4 => REF4,
          REF5 => REF5,
          REF6 => REF6,
          REF7 => REF7,
			 stop_ignoring => stop_ignoring,
          stop_accum => stop_accum,
          out_sad => out_sad
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		RST <= '1';
		wait for CLK_period*2;
		ORG1 <= "00101001";
		REF1 <= "10100000";
		RST <= '0';
		
		wait for CLK_period*10;
		
      wait;
   end process;

END;
