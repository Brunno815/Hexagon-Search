--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

package STD_SAD is

function log2_unsigned (  x :  natural ) return natural;

constant BANDWIDTH: integer := 8;
constant NR_LINES_CALC: integer := 1; -- numero de linhas de 8 que a arquitetura vai poder receber no início do processo
constant NR_BITS_VIDEO: integer := 8;
constant MAX_CTU: integer := 64;
constant MAX_BITS_SAD: integer := log2_unsigned((2**8)*(MAX_CTU**2));
constant MAX_WIDTH: integer := 1920;
constant MAX_HEIGHT: integer := 1080;

constant SEARCH_RANGE: integer := 57;

constant MAX_ITER_SEARCH: integer := 3;

type line_sad is array(0 to BANDWIDTH-1) of STD_LOGIC_VECTOR(NR_BITS_VIDEO - 1 downto 0);
type lines_sad is array(0 to NR_LINES_CALC-1) of line_sad;
type lines_sub is array(0 to (NR_LINES_CALC*BANDWIDTH)-1) of STD_LOGIC_VECTOR(NR_BITS_VIDEO - 1 downto 0);

-------- Auxiliary Stuff ----------
constant NR_LVLS_ADDER: integer := log2_unsigned(BANDWIDTH*NR_LINES_CALC);
-----------------------------------

constant NUM_CANDIDATES: integer := 4;

-------- CACHE RELATED ------------
constant NR_LINES: integer := 4096;
constant LINE_SIZE_CACHE: integer := 8; --size of the cache line in bytes
constant ASSOC: integer := 1;

subtype line_cache is STD_LOGIC_VECTOR(LINE_SIZE_CACHE*NR_BITS_VIDEO - 1 downto 0);

constant NR_BITS_ASSOC: integer := log2_unsigned(ASSOC);

constant MAX_BITS_X: integer := log2_unsigned(MAX_WIDTH)+1;
constant MAX_BITS_Y: integer := log2_unsigned(MAX_HEIGHT)+1;

constant NR_BITS_ADDR: integer := log2_unsigned(NR_LINES);

constant NR_BITS_ADDR_X: integer := NR_BITS_ADDR/2;
constant NR_BITS_ADDR_Y: integer := NR_BITS_ADDR/2;
constant NR_BITS_SLICES: integer := log2_unsigned(LINE_SIZE_CACHE-7);

constant NR_BITS_TAG: integer := MAX_BITS_Y - NR_BITS_ADDR + MAX_BITS_X + NR_BITS_ASSOC - NR_BITS_SLICES;


type m_vec is
	record
		x: STD_LOGIC_VECTOR(MAX_BITS_X-1 downto 0);
		y: STD_LOGIC_VECTOR(MAX_BITS_Y-1 downto 0);
	end record;
	
type t_adder is
	record
		first	: STD_LOGIC_VECTOR(8 downto 0);
		second: STD_LOGIC_VECTOR(9 downto 0);
		third	: STD_LOGIC_VECTOR(10 downto 0);
	end record;
	
type t_pu is
	record
		h, w: STD_LOGIC_VECTOR(6 downto 0);
	end record;
	
type t_borders is
	record
		up, down, left, right: STD_LOGIC_VECTOR(10 downto 0);
	end record;
	
type t_adders is array(0 to NR_LVLS_ADDER) of t_adder;


end STD_SAD;



package body STD_SAD is

function log2_unsigned ( x : natural ) return natural is
        variable temp : natural := x ;
        variable n : natural := 0 ;
    begin
		  if temp = 1 then
				return n;
		  else
			  while temp > 1 loop
					temp := temp / 2 ;
					n := n + 1 ;
			  end loop ;
		  end if;
        return n ;
    end function log2_unsigned ;
 
end STD_SAD;