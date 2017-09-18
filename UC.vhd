library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.STD_SAD;


entity UC_Hexagon is
	Port(
		RST					: in STD_LOGIC;
		CLK					: in STD_LOGIC;
		sub_nr_accum		: out STD_LOGIC;
		update_best_sad	: out STD_LOGIC;
		update_center		: out STD_LOGIC;
		inc_nr_iter			: out STD_LOGIC;
		sel_pred_mov		: out STD_LOGIC;
		update_first_vec	: out STD_LOGIC;
		dec_lines			: out STD_LOGIC;
		dec_columns			: out STD_LOGIC;
		load_partial_accum: out STD_LOGIC;
		load_pu				: out STD_LOGIC;
		const_add_x			: out STD_LOGIC_VECTOR(2 downto 0);
		const_add_y			: out STD_LOGIC_VECTOR(2 downto 0);
		done					: out STD_LOGIC
	);
end UC_Hexagon;

architecture Behavioral of UC_Hexagon is

type t_state is (idle, start, start_pred_mov, state_done);
signal state, next_state: t_state;

begin

	process(RST, CLK)
	begin
		if(RST='1') then
			state <= idle;
		elsif(CLK'event and CLK='1') then
			state <= next_state;
		end if;
	end process;
	
	
	process(state)
	begin
		
		case state is
			when idle =>
				next_state 			<= start;
				
			when start =>
				next_state 			<= start_pred_mov;	
			
			when start_pred_mov =>
				next_state 			<= state_done;
			
			when state_done =>
				next_state 			<= state_done;
				
		end case;
		
	end process;
	
	
	process(state)
	begin
		
		case state is
			when idle =>
				load_partial_accum<= '0';
				sub_nr_accum 		<= '0';
				update_best_sad 	<= '0';
				update_center		<= '0';
				const_add_x			<= "000";
				const_add_y			<= "000";
				sel_pred_mov		<= '0';
				update_first_vec	<= '0';
				dec_lines			<= '0';
				dec_columns			<= '0';
				load_pu				<= '0';
				done					<= '0';
				
			when start =>
				load_partial_accum<= '0';
				sub_nr_accum 		<= '0';
				update_best_sad 	<= '0';
				update_center		<= '0';
				const_add_x			<= "000";
				const_add_y			<= "000";
				sel_pred_mov		<= '0';
				update_first_vec	<= '0';
				dec_lines			<= '0';
				dec_columns			<= '0';
				load_pu				<= '1';
				done					<= '0';
				
			when start_pred_mov =>
				load_partial_accum<= '1';
				sub_nr_accum 		<= '0';
				update_best_sad 	<= '0';
				update_center		<= '0';
				const_add_x			<= "000";
				const_add_y			<= "000";
				sel_pred_mov		<= '0';
				update_first_vec	<= '0';
				dec_lines			<= '0';
				dec_columns			<= '0';
				load_pu				<= '0';
				done					<= '0';
			
			when state_done =>
				load_partial_accum<= '1';
				sub_nr_accum 		<= '1';
				update_best_sad 	<= '0';
				update_center		<= '0';
				const_add_x			<= "000";
				const_add_y			<= "000";
				sel_pred_mov		<= '0';
				update_first_vec	<= '0';
				dec_lines			<= '0';
				dec_columns			<= '0';
				load_pu				<= '0';
				done					<= '1';
				
		end case;
		
	end process;

end Behavioral;

