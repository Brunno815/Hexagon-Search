LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.STD_SAD.ALL;

ENTITY tb_top IS
END tb_top;
 
ARCHITECTURE behavior OF tb_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         RST : IN  std_logic;
         CLK : IN  std_logic;
         done_req_mem : IN  std_logic;
         initial_center_x : IN  std_logic_vector(MAX_BITS_X - 1 downto 0);
         initial_center_y : IN  std_logic_vector(MAX_BITS_Y - 1 downto 0);
         initial_best_sad : IN  std_logic_vector(19 downto 0);
			PU_H : IN  std_logic_vector(6 downto 0);
			PU_W : IN  std_logic_vector(6 downto 0);
         ORG0 : IN  std_logic_vector(7 downto 0);
         ORG1 : IN  std_logic_vector(7 downto 0);
         ORG2 : IN  std_logic_vector(7 downto 0);
         ORG3 : IN  std_logic_vector(7 downto 0);
         ORG4 : IN  std_logic_vector(7 downto 0);
         ORG5 : IN  std_logic_vector(7 downto 0);
         ORG6 : IN  std_logic_vector(7 downto 0);
         ORG7 : IN  std_logic_vector(7 downto 0);
         IN_REF0 : IN  std_logic_vector(7 downto 0);
         IN_REF1 : IN  std_logic_vector(7 downto 0);
         IN_REF2 : IN  std_logic_vector(7 downto 0);
         IN_REF3 : IN  std_logic_vector(7 downto 0);
         IN_REF4 : IN  std_logic_vector(7 downto 0);
         IN_REF5 : IN  std_logic_vector(7 downto 0);
         IN_REF6 : IN  std_logic_vector(7 downto 0);
         IN_REF7 : IN  std_logic_vector(7 downto 0);
         IN_REF8 : IN  std_logic_vector(7 downto 0);
         vec_x_req : OUT  std_logic_vector(MAX_BITS_X - 1 downto 0);
         vec_y_req : OUT  std_logic_vector(MAX_BITS_Y - 1 downto 0);
         best_vec_x : OUT  std_logic_vector(MAX_BITS_X - 1 downto 0);
         best_vec_y : OUT  std_logic_vector(MAX_BITS_Y - 1 downto 0);
         done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';
   signal done_req_mem : std_logic := '0';
   signal initial_center_x : std_logic_vector(MAX_BITS_X - 1 downto 0) := (others => '0');
   signal initial_center_y : std_logic_vector(MAX_BITS_Y - 1 downto 0) := (others => '0');
   signal initial_best_sad : std_logic_vector(19 downto 0) := (others => '0');
	signal PU_H : std_logic_vector(6 downto 0) := (others => '0');
	signal PU_W : std_logic_vector(6 downto 0) := (others => '0');
   signal ORG0 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG1 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG2 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG3 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG4 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG5 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG6 : std_logic_vector(7 downto 0) := (others => '0');
   signal ORG7 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_REF0 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_REF1 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_REF2 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_REF3 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_REF4 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_REF5 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_REF6 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_REF7 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_REF8 : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal vec_x_req : std_logic_vector(MAX_BITS_X - 1 downto 0);
   signal vec_y_req : std_logic_vector(MAX_BITS_Y - 1 downto 0);
   signal best_vec_x : std_logic_vector(MAX_BITS_X - 1 downto 0);
   signal best_vec_y : std_logic_vector(MAX_BITS_Y - 1 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          RST => RST,
          CLK => CLK,
          done_req_mem => done_req_mem,
          initial_center_x => initial_center_x,
          initial_center_y => initial_center_y,
          initial_best_sad => initial_best_sad,
			 PU_H => PU_H,
			 PU_W => PU_W,
          ORG0 => ORG0,
          ORG1 => ORG1,
          ORG2 => ORG2,
          ORG3 => ORG3,
          ORG4 => ORG4,
          ORG5 => ORG5,
          ORG6 => ORG6,
          ORG7 => ORG7,
          IN_REF0 => IN_REF0,
          IN_REF1 => IN_REF1,
          IN_REF2 => IN_REF2,
          IN_REF3 => IN_REF3,
          IN_REF4 => IN_REF4,
          IN_REF5 => IN_REF5,
          IN_REF6 => IN_REF6,
          IN_REF7 => IN_REF7,
          IN_REF8 => IN_REF8,
          vec_x_req => vec_x_req,
          vec_y_req => vec_y_req,
          best_vec_x => best_vec_x,
          best_vec_y => best_vec_y,
          done => done
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
		RST <= '0';
		PU_H <= "0100000";
		PU_W <= "0100000";
		initial_center_x <= (10=>'1', OTHERS=>'0');
		initial_center_y <= (10=>'1', OTHERS=>'0');
      initial_best_sad <= "01010001000001000001";
		wait for CLK_period;

      wait;
   end process;

END;
