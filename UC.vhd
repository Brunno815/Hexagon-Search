library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.STD_SAD.ALL;


entity UC_Hexagon is
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
end UC_Hexagon;

architecture Behavioral of UC_Hexagon is

--type t_state is (idle, start, first_hex, sec_hex, third_hex, forth_hex, fifth_hex, sixth_hex, first_square, 
--sec_square, third_square, forth_square, fifth_square, sixth_square, seventh_square, eighth_square, state_done);
type t_state is (idle, first_cand_hex, sec_cand_hex, third_cand_hex, forth_cand_hex, fifth_cand_hex, sixth_cand_hex, 
first_cand_square, sec_cand_square, third_cand_square, forth_cand_square, fifth_cand_square, sixth_cand_square, seventh_cand_square, eighth_cand_square, 
did_best_change, done_ime);
signal state, next_state: t_state;

signal inc_x: STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
signal inc_y: STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
signal reg_nr_iter_x: STD_LOGIC_VECTOR(6 downto 0);
signal reg_nr_iter_y: STD_LOGIC_VECTOR(6 downto 0);
signal sel_cand_inc_x, sel_cand_inc_y: STD_LOGIC_VECTOR(2 downto 0);
signal inc_iter_x, inc_iter_y: STD_LOGIC;

signal RST_nr_iter_y: STD_LOGIC;

signal zero_inc_iter_y: STD_LOGIC;

signal reg_stop_accum1, reg_stop_accum2: STD_LOGIC;
signal stop_accum_s: STD_LOGIC;

signal reg_load_current_global_vecs1, load_current_global_vecs_s: STD_LOGIC;

begin

	process(RST, CLK)
	begin
		if(RST='1') then
			state <= idle;
		elsif(CLK'event and CLK='1') then
			state <= next_state;
		end if;
	end process;

	process(RST, CLK, inc_iter_x)
	begin
		if(RST='1') then
			reg_nr_iter_x <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			if(inc_iter_x = '1') then
				reg_nr_iter_x <= reg_nr_iter_x + "0001000";
			else
				reg_nr_iter_x <= reg_nr_iter_x;
			end if;
		end if;
	end process;
	
	process(RST, CLK, inc_iter_y, zero_inc_iter_y)
	begin
		if(RST='1') then
			reg_nr_iter_y <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			if(inc_iter_y = '1') then
				reg_nr_iter_y <= reg_nr_iter_y + 1;
			else
				if(zero_inc_iter_y = '1') then
					reg_nr_iter_y <= (OTHERS=>'0');
				else
					reg_nr_iter_y <= reg_nr_iter_y;
				end if;
			end if;
		end if;
	end process;
	
	with sel_cand_inc_x select
		inc_x <= "00000000000" when "000",
					"00000000001" when "001",
					"00000000010" when "010",
					"11111111111" when "011",
					"11111111110" when OTHERS;
					
	with sel_cand_inc_y select
		inc_y <= "00000000000" when "000",
					"00000000001" when "001",
					"00000000010" when "010",
					"11111111111" when "011",
					"11111111110" when OTHERS;
	
	vec_x_req <= center_x + inc_x + reg_nr_iter_x;
	vec_y_req <= center_y + inc_y + reg_nr_iter_y;
	
	process(state,reg_nr_iter_y,is_best_SAD)
	begin
		
		case state is
			when idle =>
				load_current_global_vecs_s <= '1';
				zero_inc_iter_y	<= '0';
				sel_cand_inc_x		<= "100";
				sel_cand_inc_y		<= "000";
				inc_iter_x			<= '0';
				inc_iter_y			<= '0';
				en_request 			<= '0';
				load_new_accum 	<= '0';
				en_next_accum		<= '0';
				sel_best_sad		<= '1';
				update_center  	<= '1';
				sel_center 			<= '1';
				load_nr_accum 		<= '0';
				stop_ignoring		<= '1';
				stop_accum_s			<= '0';
				done 					<= '0';
				next_state 			<= first_cand_hex;
			
			when first_cand_hex =>
				if(reg_nr_iter_y = PU_H-1) then
					load_current_global_vecs_s <= '1';
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "100";
					sel_cand_inc_y		<= "000";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					stop_ignoring		<= '1';
					stop_accum_s		<= '1';
					done 					<= '0';
					next_state 			<= sec_cand_hex;
				else
					load_current_global_vecs_s <= '0';
					zero_inc_iter_y	<= '0';
					sel_cand_inc_x		<= "100";
					sel_cand_inc_y		<= "000";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					stop_ignoring		<= '1';
					stop_accum_s			<= '0';
					done 					<= '0';
					next_state 			<= first_cand_hex;
				end if;
				
			when sec_cand_hex =>
				if(reg_nr_iter_y = PU_H-1) then
					load_current_global_vecs_s <= '1';
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "010";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					stop_ignoring		<= '1';
					stop_accum_s			<= '0';
					done 					<= '0';
					next_state 			<= third_cand_hex;
				else
					load_current_global_vecs_s <= '0';
					zero_inc_iter_y	<= '0';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "010";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					stop_ignoring		<= '1';
					stop_accum_s			<= '0';
					done 					<= '0';
					next_state 			<= sec_cand_hex;
				end if;
				
			when third_cand_hex =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "001";
					sel_cand_inc_y		<= "010";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= forth_cand_hex;
				else
					zero_inc_iter_y		<= '0';
					sel_cand_inc_x		<= "001";
					sel_cand_inc_y		<= "010";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= third_cand_hex;
				end if;
				
			when forth_cand_hex =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "010";
					sel_cand_inc_y		<= "000";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= fifth_cand_hex;
				else
					zero_inc_iter_y		<= '0';
					sel_cand_inc_x		<= "010";
					sel_cand_inc_y		<= "000";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= forth_cand_hex;
				end if;
				
			when fifth_cand_hex =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "001";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= sixth_cand_hex;
				else
					zero_inc_iter_y		<= '0';
					sel_cand_inc_x		<= "001";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= fifth_cand_hex;
				end if;
				
			when sixth_cand_hex =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= did_best_change;
				else
					zero_inc_iter_y	<= '0';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= sec_cand_hex;
				end if;

			when first_cand_square =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= sec_cand_square;
				else
					zero_inc_iter_y	<= '0';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= first_cand_square;
				end if;
				
			when sec_cand_square =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= third_cand_square;
				else
					zero_inc_iter_y	<= '0';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= sec_cand_square;
				end if;
				
			when third_cand_square =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= forth_cand_square;
				else
					zero_inc_iter_y	<= '0';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= third_cand_square;
				end if;
				
			when forth_cand_square =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= fifth_cand_square;
				else
					zero_inc_iter_y	<= '0';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= forth_cand_square;
				end if;
				
			when fifth_cand_square =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= sixth_cand_square;
				else
					zero_inc_iter_y	<= '0';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= fifth_cand_square;
				end if;
				
			when sixth_cand_square =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= seventh_cand_square;
				else
					zero_inc_iter_y	<= '0';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= sixth_cand_square;
				end if;
				
			when seventh_cand_square =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= eighth_cand_square;
				else
					zero_inc_iter_y	<= '0';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= seventh_cand_square;
				end if;
				
			when eighth_cand_square =>
				if(reg_nr_iter_y = PU_H-1) then
					zero_inc_iter_y	<= '1';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '0';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= done_ime;
				else
					zero_inc_iter_y	<= '0';
					sel_cand_inc_x		<= "011";
					sel_cand_inc_y		<= "100";
					inc_iter_x			<= '0';
					inc_iter_y			<= '1';
					en_request 			<= '0';
					load_new_accum 	<= '0';
					en_next_accum		<= '0';
					
					sel_best_sad		<= '0';
					update_center  	<= '0';
					sel_center 			<= '0';
					load_nr_accum 		<= '0';
					done 					<= '0';
					next_state 			<= eighth_cand_square;
				end if;

			when did_best_change =>
				if(is_best_SAD = '1') then
					next_state <= first_cand_hex;
				else
					next_state <= first_cand_square;
				end if;
				zero_inc_iter_y	<= '0';
				sel_cand_inc_x		<= "011";
				sel_cand_inc_y		<= "100";
				inc_iter_x			<= '0';
				inc_iter_y			<= '1';
				en_request 			<= '0';
				load_new_accum 	<= '0';
				en_next_accum		<= '0';
				
				sel_best_sad		<= '0';
				update_center  	<= '0';
				sel_center 			<= '0';
				load_nr_accum 		<= '0';
				done 					<= '0';
				next_state 			<= sec_cand_hex;
				
			when done_ime =>
				zero_inc_iter_y	<= '0';
				sel_cand_inc_x		<= "000";
				sel_cand_inc_y		<= "000";
				inc_iter_x			<= '0';
				inc_iter_y			<= '1';
				en_request 			<= '0';
				load_new_accum 	<= '0';
				en_next_accum		<= '0';
				
				sel_best_sad		<= '0';
				update_center  	<= '0';
				sel_center 			<= '0';
				load_nr_accum 		<= '0';
				done 					<= '1';
				next_state 			<= sec_cand_hex;
				
		end case;
		
	end process;
	
	process(RST,CLK)
	begin
		if(RST='1') then
			reg_stop_accum1 <= '0';
		elsif(CLK'event and CLK='1') then
			reg_stop_accum1 <= stop_accum_s;
		end if;
	end process;
	
	process(RST,CLK)
	begin
		if(RST='1') then
			reg_stop_accum2 <= '0';
		elsif(CLK'event and CLK='1') then
			reg_stop_accum2 <= reg_stop_accum1;
		end if;
	end process;

	stop_accum <= reg_stop_accum2;
	
	process(RST,CLK)
	begin
		if(RST='1') then
			reg_load_current_global_vecs1 <= '0';
		elsif(CLK'event and CLK='1') then
			reg_load_current_global_vecs1 <= load_current_global_vecs_s;
		end if;
	end process;
	
	load_current_global_vecs <= reg_load_current_global_vecs1;
	

end Behavioral;

