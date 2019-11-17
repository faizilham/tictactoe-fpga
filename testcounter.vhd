LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.NUMERIC_STD.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity testcounter is
	PORT( 
	    i_right			: IN STD_LOGIC;
	    i_down			: IN STD_LOGIC;
	    i_clk           : IN STD_LOGIC;
	    i_reset			: IN STD_LOGIC;
	    o_x           	: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    o_y           	: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 )
	    
	    );
end testcounter;

architecture behavioral of testcounter is
	component col_counter1 IS 
	PORT( 
	    i_right			: IN STD_LOGIC;
	    i_reset			: IN STD_LOGIC;
	    i_clk           : IN STD_LOGIC;
	    o_x           	: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 ));
	END component;
	
	component row_counter1 IS 
	PORT( 
	    i_down			: IN STD_LOGIC;
	    i_clk           : IN STD_LOGIC;
	    i_reset         : IN STD_LOGIC;
	    o_y           	: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 ));
	END component;
	
	--signal i_col 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := STD_LOGIC_VECTOR(TO_UNSIGNED(245, 10));
	--signal i_col1		: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := STD_LOGIC_VECTOR(TO_UNSIGNED(245, 10));
begin
	cc : col_counter1 port map(i_right => i_right, i_clk=>i_clk, i_reset=>i_reset, o_x=>o_x);	
	rc : row_counter1 port map(i_down => i_down, i_clk=>i_clk, i_reset=>i_reset, o_y=>o_y);	
end behavioral;