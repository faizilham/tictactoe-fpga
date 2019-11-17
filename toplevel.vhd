library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.pkg_tubes.all;

entity toplevel is
	port(
		clk : in std_logic;
		i_right			: IN STD_LOGIC;
	    i_down			: IN STD_LOGIC;
	    i_reset			: IN STD_LOGIC;
	    i_ok			: IN STD_LOGIC;
	    xout : out board_index;
	    pout : out board_index;
	    o_turn : out board_index;
		movement : out board_index;
		playing : out boolean;
		o_board : out arr_board
		);
end toplevel;

architecture behavioral of toplevel is

component Gameloop is
	port(
		clk : in std_logic;
		player : in board_index;
		movement : out board_index;
		playing : out boolean;
		o_turn : out board_index;
		xout : out board_index;
		o_board : out arr_board
		);
end component;

component input_handler is
	PORT( 
	    i_right			: IN STD_LOGIC;
	    i_down			: IN STD_LOGIC;
	    i_clk           : IN STD_LOGIC;
	    i_reset			: IN STD_LOGIC;
	    i_ok			: IN STD_LOGIC;
	    o_x           	: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    o_col			: OUT board_index;
	    o_row			: OUT board_index;
	    o_idx			: OUT board_index;
	    o_y           	: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 )
	    );
end component;

signal reset : std_logic :='0';
signal o_x : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
signal o_y : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
signal o_col : board_index;
signal o_row : board_index;
signal o_idx : board_index;



begin
	ih : input_handler port map 
		(i_right => i_right, i_down=>i_down, i_clk => clk,
	    i_reset	=> i_reset, i_ok=>i_ok,
	    o_x => o_x,  o_col => o_col, o_row=> o_row, o_idx => o_idx, o_y => o_y);
	    
	pout <= o_idx;
	    
	gl : Gameloop	port map(
		clk => clk,
		player => o_idx,
		movement => movement,
		playing => playing,
		xout => xout,
		o_board => o_board,
		o_turn => o_turn
		);

end behavioral;