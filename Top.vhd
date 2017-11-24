library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.STD_SAD.ALL;

entity top is
	Port(
			RST                     : in STD_LOGIC;
			CLK                     : in STD_LOGIC;
			done_req_mem				: in STD_LOGIC;
			initial_center_y			: in STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
			initial_center_x			: in STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
			initial_best_sad			: in STD_LOGIC_VECTOR(19 downto 0);
			PU_H							: in STD_LOGIC_VECTOR(6 downto 0);
			PU_W							: in STD_LOGIC_VECTOR(6 downto 0);
			ORG0                    : in STD_LOGIC_VECTOR(7 downto 0);
			ORG1                    : in STD_LOGIC_VECTOR(7 downto 0);
			ORG2                    : in STD_LOGIC_VECTOR(7 downto 0);
			ORG3                    : in STD_LOGIC_VECTOR(7 downto 0);
			ORG4                    : in STD_LOGIC_VECTOR(7 downto 0);
			ORG5                    : in STD_LOGIC_VECTOR(7 downto 0);
			ORG6                    : in STD_LOGIC_VECTOR(7 downto 0);
			ORG7                    : in STD_LOGIC_VECTOR(7 downto 0);
			IN_REF0                 : in STD_LOGIC_VECTOR(7 downto 0);
			IN_REF1                 : in STD_LOGIC_VECTOR(7 downto 0);
			IN_REF2                 : in STD_LOGIC_VECTOR(7 downto 0);
			IN_REF3                 : in STD_LOGIC_VECTOR(7 downto 0);
			IN_REF4                 : in STD_LOGIC_VECTOR(7 downto 0);
			IN_REF5                 : in STD_LOGIC_VECTOR(7 downto 0);
			IN_REF6                 : in STD_LOGIC_VECTOR(7 downto 0);
			IN_REF7                 : in STD_LOGIC_VECTOR(7 downto 0);
			IN_REF8						: in STD_LOGIC_VECTOR(7 downto 0);
			vec_x_req					: out STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
			vec_y_req					: out STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
			best_vec_x					: out STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
			best_vec_y					: out STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
			done							: out STD_LOGIC
	);
end top;



architecture Behavioral of top is

	component barrel_shifter
	Port(
		RST	: in STD_LOGIC;
		CLK	: in STD_LOGIC;
		A		: in STD_LOGIC_VECTOR(9*8-1 downto 0);
		sel	: in STD_LOGIC_VECTOR(0 downto 0);
		output: out STD_LOGIC_VECTOR(8*8-1 downto 0)
	);
	end component;

	component Datapath
	Port(
		RST                     : in STD_LOGIC;
		CLK                     : in STD_LOGIC;
		initial_center_x			: in STD_LOGIC_VECTOR(MAX_BITS_X-1 downto 0);
		initial_center_y			: in STD_LOGIC_VECTOR(MAX_BITS_Y-1 downto 0);
		initial_best_sad			: in STD_LOGIC_VECTOR(19 downto 0);
		current_vec_x				: in STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
		current_vec_y				: in STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
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
		sel_best_sad				: in STD_LOGIC;
		--update_best_sad			: in STD_LOGIC;
		sel_center					: in STD_LOGIC;
		update_center				: in STD_LOGIC;
		--update_best_vec			: in STD_LOGIC;
		load_current_global_vecs: in STD_LOGIC;
		stop_ignoring				: in STD_LOGIC;
		stop_accum      			: in STD_LOGIC;
		is_best_SAD					: out STD_LOGIC;
		out_center_x				: out STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
		out_center_y				: out STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
		out_best_vec_x			 	: out STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
		out_best_vec_y			 	: out STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0)
	);
	end component;
	
	component UC_Hexagon
	Port(
		RST					: in  STD_LOGIC;
		CLK					: in  STD_LOGIC;
		done_req				: in  STD_LOGIC; --FROM MEM/CACHE
		is_best_SAD 		: in  STD_LOGIC; --Flag indicating best SAD
		PU_H					: in  STD_LOGIC_VECTOR(6 downto 0);
		PU_W					: in  STD_LOGIC_VECTOR(6 downto 0);
		center_x				: in  STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
		center_y				: in  STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
		vec_x_req			: out STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
		vec_y_req			: out STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
		en_request			: out STD_LOGIC;
		load_new_accum		: out STD_LOGIC;
		en_next_accum		: out STD_LOGIC;
		--update_best_sad	: out STD_LOGIC;
		sel_best_sad		: out STD_LOGIC;
		update_center		: out STD_LOGIC;
		--update_best_vec	: out STD_LOGIC;
		sel_center			: out STD_LOGIC;
		load_nr_accum		: out STD_LOGIC;
		load_current_global_vecs: out STD_LOGIC;
		stop_ignoring		: out STD_LOGIC;
		stop_accum			: out STD_LOGIC;
		done					: out STD_LOGIC
	);
	end component;
	
----------------------------------------------------	
signal barrel_A: STD_LOGIC_VECTOR(9*8 - 1 downto 0);
signal out_barrel: STD_LOGIC_VECTOR(8*8 - 1 downto 0);
signal sel_index: STD_LOGIC_VECTOR(0 downto 0);
------------------------------------------------------
signal is_best_SAD_s, en_request_s, load_new_accum_s, en_next_accum_s, update_best_sad_s, sel_best_sad_s, update_center_s, update_best_vec_s, 
sel_center_s, load_nr_accum_s, load_current_global_vecs_s, stop_ignoring_s, stop_accum_s: STD_LOGIC;
signal out_center_x, current_vec_x: STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
signal out_center_y, current_vec_y: STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
signal vec_x_req_s: STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
signal vec_y_req_s: STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
------------------------------------------------------
signal reg_PU_H, reg_PU_W: STD_LOGIC_VECTOR(6 downto 0);
signal REF0, REF1, REF2, REF3, REF4, REF5, REF6, REF7: STD_LOGIC_VECTOR(7 downto 0);
-----------------------------------------------------------------------------------

begin














----------------- BARREL --------------------
barrel_A(9*8-1 downto 8*8) <= IN_REF0;
barrel_A(8*8-1 downto 7*8) <= IN_REF1;
barrel_A(7*8-1 downto 6*8) <= IN_REF2;
barrel_A(6*8-1 downto 5*8) <= IN_REF3;
barrel_A(5*8-1 downto 4*8) <= IN_REF4;
barrel_A(4*8-1 downto 3*8) <= IN_REF5;
barrel_A(3*8-1 downto 2*8) <= IN_REF6;
barrel_A(2*8-1 downto 1*8) <= IN_REF7;
barrel_A(1*8-1 downto 0*8) <= IN_REF8;

REF0 <= out_barrel(8*8-1 downto 7*8);
REF1 <= out_barrel(7*8-1 downto 6*8);
REF2 <= out_barrel(6*8-1 downto 5*8);
REF3 <= out_barrel(5*8-1 downto 4*8);
REF4 <= out_barrel(4*8-1 downto 3*8);
REF5 <= out_barrel(3*8-1 downto 2*8);
REF6 <= out_barrel(2*8-1 downto 1*8);
REF7 <= out_barrel(1*8-1 downto 0*8);

-- sel_index(0) <= vec_y_req_s(0);
sel_index(0) <= vec_x_req_s(0);
---------------------------------------------

vec_x_req <= vec_x_req_s;
vec_y_req <= vec_y_req_s;

	process(RST, CLK)
	begin
		if(RST='1') then
			reg_PU_H <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			reg_PU_H <= PU_H;
		end if;
	end process;

	process(RST, CLK)
	begin
		if(RST='1') then
			reg_PU_W <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			reg_PU_W <= PU_W;
		end if;
	end process;
	

	inst_barrel: barrel_shifter
	Port Map(
		RST 		=> RST,
		CLK 		=> CLK,
		A 			=> barrel_A,
		sel 		=> sel_index,
		output 	=> out_barrel
	);
	
	inst_datapath: Datapath
	Port Map(
		RST 					=> RST,
		CLK 					=> CLK,
		initial_center_x 	=> initial_center_x,
		initial_center_y 	=> initial_center_y,
		initial_best_sad 	=> initial_best_sad,
		current_vec_x		=> vec_x_req_s,
		current_vec_y		=> vec_y_req_s,
		ORG0 					=> ORG0,
		ORG1 					=> ORG1,
		ORG2 					=> ORG2,
		ORG3 					=> ORG3,
		ORG4 					=> ORG4,
		ORG5 					=> ORG5,
		ORG6 					=> ORG6,
		ORG7 					=> ORG7,
		REF0 					=> REF0,
		REF1 					=> REF1,
		REF2 					=> REF2,
		REF3 					=> REF3,
		REF4 					=> REF4,
		REF5 					=> REF5,
		REF6 					=> REF6,
		REF7 					=> REF7,
		sel_best_sad 		=> sel_best_sad_s,
		--update_best_sad 	=> update_best_sad_s,
		sel_center 			=> sel_center_s,
		update_center 		=> update_center_s,
		--update_best_vec 	=> update_best_vec_s,
		load_current_global_vecs => load_current_global_vecs_s,
		stop_ignoring		=> stop_ignoring_s,
		stop_accum			=> stop_accum_s,
		is_best_SAD			=> is_best_SAD_s,
		out_center_x		=> out_center_x,
		out_center_y		=> out_center_y,
		out_best_vec_x		=> best_vec_x,
		out_best_vec_y		=> best_vec_y
	);
	
	inst_uc: UC_Hexagon
	Port Map(
		RST 					=> RST,
		CLK 					=> CLK,
		done_req 			=> done_req_mem,
		is_best_SAD			=> is_best_SAD_s,
		PU_H					=> PU_H,
		PU_W					=> PU_W,
		center_x				=> out_center_x,
		center_y 			=> out_center_y,
		vec_x_req 			=> vec_x_req_s,
		vec_y_req 			=> vec_y_req_s,
		en_request 			=> en_request_s,
		load_new_accum 	=> load_new_accum_s,
		en_next_accum 		=> en_next_accum_s,
		--update_best_sad 	=> update_best_sad_s,
		sel_best_sad		=> sel_best_sad_s,
		update_center		=> update_center_s,
		--update_best_vec	=> update_best_vec_s,
		sel_center			=> sel_center_s,
		load_nr_accum		=> load_nr_accum_s,
		load_current_global_vecs => load_current_global_vecs_s,
		stop_ignoring		=> stop_ignoring_s,
		stop_accum			=> stop_accum_s,
		done					=> done
	);


end Behavioral;