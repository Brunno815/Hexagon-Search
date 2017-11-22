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
		update_best_sad	: out STD_LOGIC;
		sel_best_sad		: out STD_LOGIC;
		update_center		: out STD_LOGIC;
		update_best_vec	: out STD_LOGIC;
		sel_center			: out STD_LOGIC;
		load_nr_accum		: out STD_LOGIC;
		stop_accum			: out STD_LOGIC;
		done					: out STD_LOGIC
	);
end UC_Hexagon;

architecture Behavioral of UC_Hexagon is

--type t_state is (idle, start, first_hex, sec_hex, third_hex, forth_hex, fifth_hex, sixth_hex, first_square, 
--sec_square, third_square, forth_square, fifth_square, sixth_square, seventh_square, eighth_square, state_done);
type t_state is (idle, first_cand_hex);
signal state, next_state: t_state;

signal inc_x: STD_LOGIC_VECTOR(MAX_BITS_X - 1 downto 0);
signal inc_y: STD_LOGIC_VECTOR(MAX_BITS_Y - 1 downto 0);
signal reg_nr_iter_x: STD_LOGIC_VECTOR(6 downto 0);
signal reg_nr_iter_y: STD_LOGIC_VECTOR(6 downto 0);
signal sel_cand_inc_x, sel_cand_inc_y: STD_LOGIC_VECTOR(1 downto 0);
signal inc_iter_x, inc_iter_y: STD_LOGIC;

begin

	process(RST, CLK)
	begin
		if(RST='1') then
			state <= idle;
		elsif(CLK'event and CLK='1') then
			state <= next_state;
		end if;
	end process;

--	process(RST, CLK)
--	begin
--		if(RST='1') then
--			reg_inc_x <= (OTHERS=>'0');
--			reg_inc_y <= (OTHERS=>'0');
--		elsif(CLK'event and CLK='1') then
--			reg_inc_x <= inc_x;
--			reg_inc_y <= inc_y;
--		end if;
--	end process;

	process(RST, CLK)
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
	
	process(RST, CLK)
	begin
		if(RST='1') then
			reg_nr_iter_y <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			if(inc_iter_y = '1') then
				reg_nr_iter_y <= reg_nr_iter_y + 1;
			else
				reg_nr_iter_y <= reg_nr_iter_y;
			end if;
		end if;
	end process;
	
	with sel_cand_inc_x select
		inc_x <= "00000000001" when "00",
					"00000000010" when "01",
					"11111111111" when "10",
					"11111111110" when OTHERS;
					
	with sel_cand_inc_y select
		inc_y <= "00000000001" when "00",
					"00000000010" when "01",
					"11111111111" when "10",
					"11111111110" when OTHERS;
	
	vec_x_req <= center_x + inc_x + reg_nr_iter_x;
	vec_y_req <= center_y + inc_y + reg_nr_iter_y;
	
	process(state)
	begin
		
		case state is
			when idle =>
				sel_cand_inc_x		<= "00";
				sel_cand_inc_y		<= "00";
				inc_iter_x			<= '0';
				inc_iter_y			<= '0';
				en_request 			<= '0';
				load_new_accum 	<= '0';
				en_next_accum		<= '0';
				update_best_sad 	<= '1';
				sel_best_sad		<= '1';
				update_center  	<= '1';
				sel_center 			<= '1';
				load_nr_accum 		<= '0';
				done 					<= '0';
				next_state 			<= first_cand_hex;
			
			when first_cand_hex =>
				sel_cand_inc_x		<= "00";
				sel_cand_inc_y		<= "00";
				inc_iter_x			<= '0';
				inc_iter_y			<= '0';
				en_request 			<= '0';
				load_new_accum 	<= '0';
				en_next_accum		<= '0';
				update_best_sad 	<= '1';
				sel_best_sad		<= '1';
				update_center  	<= '1';
				sel_center 			<= '1';
				load_nr_accum 		<= '0';
				done 					<= '0';
				next_state 			<= first_cand_hex;
			
--			when first_hex =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--			when sec_hex =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--			when third_hex =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x		<= reg_nr_iter_x;
--							nr_iter_y		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x		<= reg_nr_iter_x;
--							nr_iter_y		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--			when forth_hex =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--			when fifth_hex =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--			when sixth_hex =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--
--			when first_square =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--			when sec_square =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--
--			when third_square =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--
--			when forth_square =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--
--			when fifth_square =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--
--			when sixth_square =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--
--			when seventh_square =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;
--
--
--			when eighth_square =>
--				if(done_req = '0') then
--					inc_x 			<= inc_x;
--					inc_y 			<= inc_y;
--					nr_iter_x 		<= reg_nr_iter_x;
--					nr_iter_y 		<= reg_nr_iter_y;
--					vec_x_req		<= center_x + reg_inc_x;
--					vec_y_req		<= center_x + reg_inc_y;
--					en_request		<= '0';
--					load_new_accum	<= '0';
--					en_next_accum	<= '1';
--					update_best_sad <= '0';
--					update_center	<= '0';
--					sel_center		<= '0';
--					load_nr_accum	<= '0';
--					done 			<= '0';
--					next_state		<= first_hex;
--				else
--					if(reg_nr_iter_x = NR_ITER_X) then
--						if(reg_nr_iter_y = NR_ITER_Y) then
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						else
--							inc_x 			<= inc_x;
--							inc_y 			<= inc_y;
--							nr_iter_x 		<= reg_nr_iter_x;
--							nr_iter_y 		<= reg_nr_iter_y;
--							vec_x_req		<= center_x + reg_inc_x;
--							vec_y_req		<= center_x + reg_inc_y;
--							en_request		<= '0';
--							load_new_accum	<= '0';
--							en_next_accum	<= '1';
--							update_best_sad <= '0';
--							update_center	<= '0';
--							sel_center		<= '0';
--							load_nr_accum	<= '0';
--							done 			<= '0';
--							next_state		<= first_hex;
--						end if;
--					else
--						inc_x 			<= inc_x;
--						inc_y 			<= inc_y;
--						nr_iter_x 		<= reg_nr_iter_x;
--						nr_iter_y 		<= reg_nr_iter_y;
--						vec_x_req		<= center_x + reg_inc_x;
--						vec_y_req		<= center_x + reg_inc_y;
--						en_request		<= '0';
--						load_new_accum	<= '0';
--						en_next_accum	<= '1';
--						update_best_sad <= '0';
--						update_center	<= '0';
--						sel_center		<= '0';
--						load_nr_accum	<= '0';
--						done 			<= '0';
--						next_state		<= first_hex;
--					end if;
--
--				end if;

			
--			when state_done =>
--				inc_x 			<= inc_x;
--				inc_y 			<= inc_y;
--				nr_iter_x 		<= reg_nr_iter_x;
--				nr_iter_y 		<= reg_nr_iter_y;
--				vec_x_req		<= center_x + reg_inc_x;
--				vec_y_req		<= center_x + reg_inc_y;
--				en_request		<= '0';
--				load_new_accum	<= '0';
--				en_next_accum	<= '1';
--				update_best_sad <= '0';
--				update_center	<= '0';
--				sel_center		<= '0';
--				load_nr_accum	<= '0';
--				done 			<= '1';
--				next_state 			<= state_done;
				
		end case;
		
	end process;

end Behavioral;

