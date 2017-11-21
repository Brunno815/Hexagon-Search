LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.STD_SAD.ALL;
 
ENTITY tb_datapath IS
END tb_datapath;
 
ARCHITECTURE behavior OF tb_datapath IS 
 
    COMPONENT Datapath
    PORT(
         RST : IN  std_logic;
         CLK : IN  std_logic;
         initial_center_x : IN  std_logic_vector(MAX_BITS_X - 1 downto 0);
         initial_center_y : IN  std_logic_vector(MAX_BITS_Y - 1 downto 0);
         initial_best_sad : IN  std_logic_vector(19 downto 0);
         current_vec_x : IN  std_logic_vector(MAX_BITS_X - 1 downto 0);
         current_vec_y : IN  std_logic_vector(MAX_BITS_Y - 1 downto 0);
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
         sel_best_sad : IN  std_logic;
         update_best_sad : IN  std_logic;
         sel_center : IN  std_logic;
         update_center : IN  std_logic;
         update_best_vec : IN  std_logic;
         stop_accum : IN  std_logic;
         out_center_x : OUT  std_logic_vector(MAX_BITS_X - 1 downto 0);
         out_center_y : OUT  std_logic_vector(MAX_BITS_Y - 1 downto 0);
         out_best_vec_x : OUT  std_logic_vector(MAX_BITS_X - 1 downto 0);
         out_best_vec_y : OUT  std_logic_vector(MAX_BITS_Y - 1 downto 0);
         out_best_sad : OUT  std_logic_vector(19 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';
   signal initial_center_x : std_logic_vector(MAX_BITS_X - 1 downto 0) := (others => '0');
   signal initial_center_y : std_logic_vector(MAX_BITS_Y - 1 downto 0) := (others => '0');
   signal initial_best_sad : std_logic_vector(19 downto 0) := (others => '0');
   signal current_vec_x : std_logic_vector(MAX_BITS_X - 1 downto 0) := (others => '0');
   signal current_vec_y : std_logic_vector(MAX_BITS_Y - 1 downto 0) := (others => '0');
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
   signal sel_best_sad : std_logic := '0';
   signal update_best_sad : std_logic := '0';
   signal sel_center : std_logic := '0';
   signal update_center : std_logic := '0';
   signal update_best_vec : std_logic := '0';
   signal stop_accum : std_logic := '0';

 	--Outputs
   signal out_center_x : std_logic_vector(MAX_BITS_X - 1 downto 0);
   signal out_center_y : std_logic_vector(MAX_BITS_Y - 1 downto 0);
   signal out_best_vec_x : std_logic_vector(MAX_BITS_X - 1 downto 0);
   signal out_best_vec_y : std_logic_vector(MAX_BITS_Y - 1 downto 0);
   signal out_best_sad : std_logic_vector(19 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Datapath PORT MAP (
          RST => RST,
          CLK => CLK,
          initial_center_x => initial_center_x,
          initial_center_y => initial_center_y,
          initial_best_sad => initial_best_sad,
          current_vec_x => current_vec_x,
          current_vec_y => current_vec_y,
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
          sel_best_sad => sel_best_sad,
          update_best_sad => update_best_sad,
          sel_center => sel_center,
          update_center => update_center,
          update_best_vec => update_best_vec,
          stop_accum => stop_accum,
          out_center_x => out_center_x,
          out_center_y => out_center_y,
          out_best_vec_x => out_best_vec_x,
          out_best_vec_y => out_best_vec_y,
          out_best_sad => out_best_sad
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
      -- hold reset state for 100 ns.
      

      -- insert stimulus here 

      wait;
   end process;

END;
