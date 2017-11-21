library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity abs_ver is
	Port(
			a: in std_logic_vector(7 downto 0);
			b: in std_logic_vector (7 downto 0);
			c: out std_logic_vector (7 downto 0)
	);
end abs_ver;

architecture Behavioral of abs_ver is

signal sub_AB: STD_LOGIC_VECTOR(8 downto 0);
signal sub_BA: STD_LOGIC_VECTOR(7 downto 0);
signal in_mux_A, in_mux_B, out_gate: STD_LOGIC_VECTOR(7 downto 0);
signal x_msb: STD_LOGIC;

begin

sub_AB <= ('0' & A) - ('0' & B);

sub_BA <= B - A;

x_msb <= sub_AB(8);

in_mux_A <= sub_AB(7 downto 0);
in_mux_B <= sub_BA(7 downto 0);

with x_msb select out_gate <=
                in_mux_A when '0',
                in_mux_B when OTHERS;

C <= out_gate;

end Behavioral;