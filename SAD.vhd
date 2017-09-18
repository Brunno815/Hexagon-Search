library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.STD_SAD.ALL;


entity SAD is

	Port(
		RST		: in STD_LOGIC;
		CLK		: in STD_LOGIC;
		in_lines_a	: in lines_sad;
		in_lines_b	: in lines_sad;
		stop_accum	: in STD_LOGIC;
		out_sad		: out STD_LOGIC_VECTOR(19 downto 0)
	);

end SAD;


architecture Behavioral of SAD is

	component genericAdd
	Generic(
		width: integer
	);
	Port(
		a: in STD_LOGIC_VECTOR(width-1 downto 0);
		b: in STD_LOGIC_VECTOR(width-1 downto 0);
		c: out STD_LOGIC_VECTOR(width downto 0)
	);

	end component;


	component abs_ver
	Port(
		RST: in STD_LOGIC;
		CLK: in STD_LOGIC;
		A: in STD_LOGIC_VECTOR(7 downto 0);
		B: in STD_LOGIC_VECTOR(7 downto 0);
		C: out STD_LOGIC_VECTOR(7 downto 0)
	);

	end component;


signal sub_values: lines_sub;
signal partial_sad: STD_LOGIC_VECTOR(10 downto 0);
signal accum_sad, reg_accum_sad, data_gating_feedback: STD_LOGIC_VECTOR(19 downto 0);
signal reg_stop_accum: STD_LOGIC;

type t_add1 is array(0 to 3) of STD_LOGIC_VECTOR(8 downto 0);
signal sig_add1	: t_add1;

type t_add2 is array(0 to 1) of STD_LOGIC_VECTOR(9 downto 0);
signal sig_add2	: t_add2;

type t_add3 is array(0 to 0) of STD_LOGIC_VECTOR(10 downto 0);
signal sig_add3	: t_add3;



begin

	process(RST,CLK)
	begin
		if(RST = '1') then
			reg_stop_accum <= '0';
		elsif(CLK'event and CLK = '1') then
			reg_stop_accum <= stop_accum;
		end if;
	end process;

	process(RST,CLK)
	begin
		if(RST = '1') then
			reg_accum_sad <= (OTHERS => '0');
		elsif(CLK'event and CLK = '1') then
			reg_accum_sad <= accum_sad;
		end if;
	end process;

	gensub_i: for i in 0 to 0 generate
		gensub_j: for j in 0 to 7 generate
			subX: abs_ver
				Port Map(RST,CLK,in_lines_a(i)(j), in_lines_b(i)(j), sub_values(8*i+j));
		end generate gensub_j;
	end generate gensub_i;

	genadd1_j: for j in 0 to 3 generate
		addX: genericAdd
			Generic Map(width => 8)
			Port Map(sub_values(j*2), sub_values(j*2+1), sig_add1(j));
	 end generate genadd1_j;

	genadd2_j: for j in 0 to 1 generate
		addX: genericAdd
			Generic Map(width => 9)
			Port Map(sig_add1(j*2), sig_add1(j*2+1), sig_add2(j));
	 end generate genadd2_j;

	genadd3_j: for j in 0 to 0 generate
		addX: genericAdd
			Generic Map(width => 10)
			Port Map(sig_add2(j*2), sig_add2(j*2+1), sig_add3(j));
	 end generate genadd3_j;

	partial_sad <= sig_add3(0);
	accum_sad <= data_gating_feedback + ("000000000" & partial_sad);

	data_gating: for i in 0 to 19 generate
		data_gating_feedback(i) <= reg_accum_sad(i) and not(reg_stop_accum);
	end generate data_gating;
	
	out_sad <= reg_accum_sad;

end Behavioral;