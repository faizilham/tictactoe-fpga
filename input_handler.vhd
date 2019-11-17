LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.NUMERIC_STD.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;
 
LIBRARY WORK;
USE WORK.pkg_tubes.ALL;

entity input_handler is
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
end input_handler;

architecture behavioral of input_handler is
	component col_counter1 IS 
	PORT( 
	    i_right			: IN STD_LOGIC;
	    i_reset			: IN STD_LOGIC;
	    i_clk           : IN STD_LOGIC;
	    o_col			: OUT board_index;
	    o_x           	: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 ));
	END component;
	
	component row_counter1 IS 
	PORT( 
	    i_down			: IN STD_LOGIC;
	    i_clk           : IN STD_LOGIC;
	    i_reset         : IN STD_LOGIC;
	    o_row			: OUT board_index;
	    o_y           	: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 ));
	END component;
	
	signal col : board_index;
	signal row : board_index;
	
begin
	cc : col_counter1 port map(i_right => i_right, i_clk=>i_clk, i_reset=>i_reset, o_col=>col, o_x=>o_x);	
	rc : row_counter1 port map(i_down => i_down, i_clk=>i_clk, i_reset=>i_reset,o_row=>row, o_y=>o_y);	
	o_col <= col;
	o_row <= row;
	
	process (i_ok) begin
		if (i_ok'event and i_ok = '1') then
			o_idx <= 3 * row + col + 1;
		end if;
	end process;
	
	
end behavioral;