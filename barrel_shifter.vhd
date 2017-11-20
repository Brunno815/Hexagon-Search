----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:26 03/21/2017 
-- Design Name: 
-- Module Name:    barrel_shifter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity barrel_shifter is

	Port(
		RST	: in STD_LOGIC;
		CLK	: in STD_LOGIC;
		A		: in STD_LOGIC_VECTOR(9*8-1 downto 0);
		sel	: in STD_LOGIC_VECTOR(0 downto 0);
		output: out STD_LOGIC_VECTOR(8*8-1 downto 0)
	);

end barrel_shifter;

architecture Behavioral of barrel_shifter is

--type t_ints is array(0 downto 0) of STD_LOGIC_VECTOR(9*8-1 downto 0);
--signal int: t_ints;
signal reg_A: STD_LOGIC_VECTOR(9*8-1 downto 0);
signal reg_output, output_aux: STD_LOGIC_VECTOR(8*8-1 downto 0);
signal reg_sel: STD_LOGIC_VECTOR(0 downto 0);

begin

--with reg_sel(1) select
--	int(0) <= reg_A(11*8-1 downto 11*8 - 9*8) when '0',
--				reg_A(9*8-1 downto 0) when OTHERS;

with reg_sel(0) select
	output_aux <= reg_A(9*8-1 downto 9*8 - 8*8) when '0',
			 reg_A(8*8-1 downto 0) when OTHERS;

process(RST, CLK)
begin
	if(RST = '1') then
		reg_A <= (OTHERS=>'0');
		reg_sel <= (OTHERS=>'0');
		reg_output <= (OTHERS=>'0');
	elsif(CLK'event and CLK='1') then
		reg_A <= A;
		reg_sel <= sel;
		reg_output <= output_aux;
	end if;
end process;

output <= reg_output;

end Behavioral;

