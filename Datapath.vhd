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
			 update_best_sad			 : in STD_LOGIC;
			 sel_center					 : in STD_LOGIC;
			 update_center				 : in STD_LOGIC;
			 update_best_vec			 : in STD_LOGIC;
			 stop_accum      			 : in STD_LOGIC;
			 out_center_x				 : out STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
			 out_center_y				 : out STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
			 out_best_vec_x			 : out STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
			 out_best_vec_y			 : out STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
			 out_best_sad				 : out STD_LOGIC_VECTOR(19 downto 0)
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
			 stop_accum      			 : in STD_LOGIC;
			 out_sad         			 : out STD_LOGIC_VECTOR(19 downto 0)
		);
	end component;
	
--		done_req			: in  STD_LOGIC; --FROM MEM/CACHE
--		best_SAD 			: in  STD_LOGIC; --Flag indicating best SAD
--		center_x			: in  STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
--		center_y			: in  STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
--		vec_x_req			: out STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
--		vec_y_req			: out STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
--		en_request			: out STD_LOGIC;
--		load_new_accum		: out STD_LOGIC;
--		en_next_accum		: out STD_LOGIC;
--		update_best_sad		: out STD_LOGIC;
--		sel_best_sad		: out STD_LOGIC;
--		update_center		: out STD_LOGIC;
--		sel_center			: out STD_LOGIC;
--		load_nr_accum		: out STD_LOGIC;
--		done				: out STD_LOGIC
		
signal best_sad, reg_best_sad: STD_LOGIC_VECTOR(19 downto 0);
signal center_x, center_y, reg_center_x, reg_center_y: STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
signal out_sad: STD_LOGIC_VECTOR(19 downto 0);
signal reg_best_vec_x, reg_best_vec_y: STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);

begin

	process(RST, CLK)
	begin
		if(RST='1') then
			reg_best_sad <= (OTHERS=>'1');
		elsif(CLK'event and CLK='1') then
			if(update_best_sad = '1') then
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
	
	process(RST,CLK)
	begin
		if(RST='1') then
			reg_best_vec_x <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			if(update_best_vec = '1') then
				reg_best_vec_x <= current_vec_x;
			else
				reg_best_vec_x <= reg_best_vec_x;
			end if;
		end if;
	end process;
	
	process(RST,CLK)
	begin
		if(RST='1') then
			reg_best_vec_y <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			if(update_best_vec = '1') then
				reg_best_vec_y <= current_vec_y;
			else
				reg_best_vec_y <= reg_best_vec_y;
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
			stop_accum => stop_accum,
			out_sad => out_sad
		);
		
	out_best_vec_x <= reg_best_vec_x;
	out_best_vec_y <= reg_best_vec_y;
	out_best_sad   <= reg_best_sad;
	out_center_x	<= reg_center_x;
	out_center_y	<= reg_center_y;

end Behavioral;