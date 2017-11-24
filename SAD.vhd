library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.STD_SAD.ALL;


entity SAD is

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
					 stop_ignoring	  : in STD_LOGIC;
                stop_accum      : in STD_LOGIC;
                out_sad         : out STD_LOGIC_VECTOR(19 downto 0)
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
                a: in STD_LOGIC_VECTOR(7 downto 0);
                b: in STD_LOGIC_VECTOR(7 downto 0);
                c: out STD_LOGIC_VECTOR(7 downto 0)
        );

        end component;

signal in_lines_a, in_lines_b: lines_sad;
signal sub_values: lines_sub;
signal partial_sad: STD_LOGIC_VECTOR(10 downto 0);
signal accum_sad, reg_accum_sad, data_gating_feedback: STD_LOGIC_VECTOR(19 downto 0);
signal partial_after_ignore: STD_LOGIC_VECTOR(10 downto 0);
signal reg_sub_values: lines_sub;

type t_add1 is array(0 to 3) of STD_LOGIC_VECTOR(8 downto 0);
signal sig_add1 : t_add1;
signal reg_sig_add1: t_add1;
type t_add2 is array(0 to 1) of STD_LOGIC_VECTOR(9 downto 0);
signal sig_add2 : t_add2;
signal reg_sig_add2: t_add2;
type t_add3 is array(0 to 0) of STD_LOGIC_VECTOR(10 downto 0);
signal sig_add3 : t_add3;
signal reg_sig_add3: t_add3;
signal reg_stop_accum0: STD_LOGIC;
signal reg_stop_accum1: STD_LOGIC;
signal reg_stop_accum2: STD_LOGIC;
signal reg_stop_accum3: STD_LOGIC;

begin

        in_lines_a(0)(0) <= ORG0;
        in_lines_b(0)(0) <= REF0;
        in_lines_a(0)(1) <= ORG1;
        in_lines_b(0)(1) <= REF1;
        in_lines_a(0)(2) <= ORG2;
        in_lines_b(0)(2) <= REF2;
        in_lines_a(0)(3) <= ORG3;
        in_lines_b(0)(3) <= REF3;
        in_lines_a(0)(4) <= ORG4;
        in_lines_b(0)(4) <= REF4;
        in_lines_a(0)(5) <= ORG5;
        in_lines_b(0)(5) <= REF5;
        in_lines_a(0)(6) <= ORG6;
        in_lines_b(0)(6) <= REF6;
        in_lines_a(0)(7) <= ORG7;
        in_lines_b(0)(7) <= REF7;
        reg_stop_accum0 <= stop_accum;

        reg_stop_accum1 <= reg_stop_accum0;

        reg_stop_accum2 <= reg_stop_accum1;

        reg_stop_accum3 <= reg_stop_accum2;

        reg_sub_values <= sub_values;

        reg_sig_add1 <= sig_add1;
        reg_sig_add2 <= sig_add2;
        reg_sig_add3 <= sig_add3;
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
                                Port Map(in_lines_a(i)(j), in_lines_b(i)(j), sub_values(8*i+j));
                end generate gensub_j;
        end generate gensub_i;

        genadd1_j: for j in 0 to 3 generate
                addX: genericAdd
                        Generic Map(width => 8)
                        Port Map(reg_sub_values(j*2), reg_sub_values(j*2+1), sig_add1(j));
         end generate genadd1_j;

        genadd2_j: for j in 0 to 1 generate
                addX: genericAdd
                        Generic Map(width => 9)
                        Port Map(reg_sig_add1(j*2), reg_sig_add1(j*2+1), sig_add2(j));
         end generate genadd2_j;

        genadd3_j: for j in 0 to 0 generate
                addX: genericAdd
                        Generic Map(width => 10)
                        Port Map(reg_sig_add2(j*2), reg_sig_add2(j*2+1), sig_add3(j));
         end generate genadd3_j;

        partial_sad <= reg_sig_add3(0);
		  
		  ignore_gating: for i in 0 to 10 generate
			 partial_after_ignore(i) <= partial_sad(i) and (stop_ignoring);
		  end generate ignore_gating;
		  
		  accum_sad <= data_gating_feedback + ("000000000" & partial_after_ignore);

        data_gating: for i in 0 to 19 generate
                data_gating_feedback(i) <= reg_accum_sad(i) and not(reg_stop_accum3);
        end generate data_gating;

        out_sad <= reg_accum_sad;
end Behavioral;
