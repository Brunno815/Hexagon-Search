library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.STD_SAD.all;

entity Datapath is
	Port(
			 RST                     : in STD_LOGIC;
			 CLK                     : in STD_LOGIC;
			 initial_center_x			 : in STD_LOGIC_VECTOR(MAX_BITS_X-1 downto 0);
			 initial_center_y			 : in STD_LOGIC_VECTOR(MAX_BITS_Y-1 downto 0);
			 initial_best_sad			 : in STD_LOGIC_VECTOR(19 downto 0);
			 current_vec_x				 : in STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
			 current_vec_y				 : in STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
			 ORG0                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG1                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG2                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG3                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG4                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG5                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG6                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG7                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF0                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF1                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF2                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF3                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF4                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF5                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF6                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF7                    : in STD_LOGIC_VECTOR(7 downto 0);
			 sel_best_sad				 : in STD_LOGIC;
			 sel_center					 : in STD_LOGIC;
			 update_center				 : in STD_LOGIC;
			 update_initial_sad		 : in STD_LOGIC;
			 load_current_global_vecs: in STD_LOGIC;
			 stop_ignoring				 : in STD_LOGIC;
			 stop_accum      			 : in STD_LOGIC;
			 zero_reg_best_SAD		 : in STD_LOGIC;
			 is_best_SAD				 : out STD_LOGIC;
			 out_center_x				 : out STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
			 out_center_y				 : out STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
			 out_best_vec_x			 : out STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
			 out_best_vec_y			 : out STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0)
	);
end Datapath;



architecture Behavioral of Datapath is

	component SAD
		Port(
			 RST                     : in STD_LOGIC;
			 CLK                     : in STD_LOGIC;
			 ORG0                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG1                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG2                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG3                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG4                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG5                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG6                    : in STD_LOGIC_VECTOR(7 downto 0);
			 ORG7                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF0                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF1                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF2                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF3                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF4                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF5                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF6                    : in STD_LOGIC_VECTOR(7 downto 0);
			 REF7                    : in STD_LOGIC_VECTOR(7 downto 0);
			 stop_ignoring				 : in STD_LOGIC;
			 stop_accum      			 : in STD_LOGIC;
			 out_sad         			 : out STD_LOGIC_VECTOR(19 downto 0)
		);
	end component;
		
signal best_sad, reg_best_sad: STD_LOGIC_VECTOR(19 downto 0);
signal center_x, center_y, reg_center_x, reg_center_y: STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
signal out_sad: STD_LOGIC_VECTOR(19 downto 0);
signal reg_best_vec_x, reg_best_vec_y: STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
signal reg_current_global_vec_x, reg_current_global_vec_y, reg_current_global_vec_x1, reg_current_global_vec_y1: STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
signal update_best_vec, better_SAD, reg_better_SAD: STD_LOGIC;
signal reg_is_best_SAD: STD_LOGIC;

begin

	process(RST, CLK)
	begin
		if(RST='1') then
			reg_best_sad <= (OTHERS=>'1');
		elsif(CLK'event and CLK='1') then
			if(update_best_vec = '1' or update_initial_sad = '1') then
				reg_best_sad <= best_sad;
			else
				reg_best_sad <= reg_best_sad;
			end if;
		end if;
	end process;
	
	process(RST, CLK)
	begin
		if(RST='1') then
			reg_center_x <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			if(update_center = '1') then
				reg_center_x <= center_x;
			else
				reg_center_x <= reg_center_x;
			end if;
		end if;
	end process;
	
	process(RST,CLK)
	begin
		if(RST='1') then
			reg_center_y <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			if(update_center = '1') then
				reg_center_y <= center_y;
			else
				reg_center_y <= reg_center_y;
			end if;
		end if;
	end process;
	
	process(RST,CLK,update_best_vec)
	begin
		if(RST='1') then
			reg_best_vec_x <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			if(update_best_vec = '1') then
				reg_best_vec_x <= reg_current_global_vec_x;
			else
				reg_best_vec_x <= reg_best_vec_x;
			end if;
		end if;
	end process;
	
	process(RST,CLK,update_best_vec)
	begin
		if(RST='1') then
			reg_best_vec_y <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			if(update_best_vec = '1') then
				reg_best_vec_y <= reg_current_global_vec_y;
			else
				reg_best_vec_y <= reg_best_vec_y;
			end if;
		end if;
	end process;
	
	process(RST,CLK,update_best_vec,zero_reg_best_SAD)
	begin
		if(RST='1') then
			reg_is_best_SAD <= '0';
		elsif(CLK'event and CLK='1') then
			if(update_best_vec = '1') then
				reg_is_best_SAD <= '1';
			else
				if(zero_reg_best_SAD = '1') then
					reg_is_best_SAD <= '0';
				else
					reg_is_best_SAD <= reg_is_best_SAD;
				end if;
			end if;
		end if;
	end process;
	
	with sel_best_sad select
		best_sad <= initial_best_sad when '1',
						out_sad when OTHERS;

	with sel_center select
		center_x <= initial_center_x when '1',
						reg_best_vec_x when OTHERS;
						 
	with sel_center select
		center_y <= initial_center_y when '1',
						reg_best_vec_y when OTHERS;


	process(out_sad, reg_best_sad, stop_accum)
	begin
		if((out_sad < reg_best_sad) and stop_accum = '1') then
			update_best_vec <= '1';
		else
			update_best_vec <= '0';
		end if;
	end process;

	process(RST,CLK,load_current_global_vecs)
	begin
		if(RST='1') then
			reg_current_global_vec_x1 <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			if(load_current_global_vecs = '1') then
				reg_current_global_vec_x1 <= current_vec_x;
			end if;
		end if;
	end process;
	
	process(RST,CLK,load_current_global_vecs)
	begin
		if(RST='1') then
			reg_current_global_vec_y1 <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			if(load_current_global_vecs = '1') then
				reg_current_global_vec_y1 <= current_vec_y;
			end if;
		end if;
	end process;



	process(RST,CLK)
	begin
		if(RST='1') then
			reg_current_global_vec_x <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			reg_current_global_vec_x <= reg_current_global_vec_x1;
		end if;
	end process;

	process(RST,CLK)
	begin
		if(RST='1') then
			reg_current_global_vec_y <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			reg_current_global_vec_y <= reg_current_global_vec_y1;
		end if;
	end process;

	inst_sad: SAD
		Port Map(
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
			stop_ignoring	=> stop_ignoring,
			stop_accum => stop_accum,
			out_sad => out_sad
		);
		
	out_best_vec_x <= reg_best_vec_x;
	out_best_vec_y <= reg_best_vec_y;
	out_center_x	<= reg_center_x;
	out_center_y	<= reg_center_y;
	is_best_SAD		<= reg_is_best_SAD;

end Behavioral;