LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.NUMERIC_STD.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;
 
LIBRARY WORK;
USE WORK.pkg_tubes.ALL;

ENTITY col_counter1 IS 
	PORT( 
	    i_right			: IN STD_LOGIC;
	    i_reset			: IN STD_LOGIC;
	    i_clk           : IN STD_LOGIC;
	    o_col			: OUT board_index;
	    o_x           	: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 ));
	    
END col_counter1;

ARCHITECTURE behavioral OF col_counter1  IS 

SIGNAL div 		: integer := 5000000;
SIGNAL delta 	: integer := 65;
signal x 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 ):= STD_LOGIC_VECTOR(TO_UNSIGNED(230, 10));
SIGNAL clock  	: STD_LOGIC := '0'; 
SIGNAL counter 	: integer :=0;
--CONSTANT x    : INTEGER := 245; buat awalnya mau bikin di tengah tapi bingung soalnya sama sama x variabelnya
--CONSTANT y    : INTEGER := 115;


BEGIN

o_x <= x;

PROCESS (i_clk)
	BEGIN
		IF i_clk'EVENT AND i_clk='1' THEN
			IF (counter < div) THEN
				counter <= counter + 1;
			ELSE
				counter <= 0;
				clock <= not clock;
			END IF;
		END IF;
END PROCESS;

PROCESS 
	BEGIN 
	WAIT UNTIL(  clock'EVENT  ) AND ( clock  = '1'  );
	IF i_reset = '1' THEN
		x<= STD_LOGIC_VECTOR(TO_UNSIGNED(230, 10));
		o_col <= 0;
	ELSIF i_right = '1' THEN
		IF x = 360 THEN --kotak tic tac toenya rencananya mau buat ukuran 50x50 (setiap kotaknya)
			x<= STD_LOGIC_VECTOR(TO_UNSIGNED(230, 10));  --jadi kan totalnya ada sembilan kotak, ntr bakal di tengah layar gitu
			o_col <= 0;
		ELSE
			IF x = 230 then
				o_col <= 1;
			ELSE
				o_col <= 2;
			END IF;
			x<=x+delta;
		END IF;
		
	END IF;
END  PROCESS; 
END behavioral; 