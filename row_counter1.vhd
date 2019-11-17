LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.NUMERIC_STD.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;
 
LIBRARY WORK;
USE WORK.pkg_tubes.ALL;
 
ENTITY row_counter1 IS 
	PORT( 
	    i_down			: IN STD_LOGIC;
	    i_clk           : IN STD_LOGIC;
	    i_reset         : IN STD_LOGIC;
	    o_row			: OUT board_index;
	    o_y           	: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 ));
END row_counter1;

ARCHITECTURE behavioral OF row_counter1  IS 

SIGNAL div 		: integer := 5000000;
SIGNAL delta 	: integer := 65;
signal y 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := STD_LOGIC_VECTOR(TO_UNSIGNED(100, 10));
SIGNAL clock  	: STD_LOGIC := '0'; 
SIGNAL counter 	: integer :=0;
--CONSTANT x    : INTEGER := 245; mau bikin di tengah tapi bingung soalnya sama sama y variabelnya
--CONSTANT y    : INTEGER := 115;

BEGIN

o_y <= y;

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
		y<= STD_LOGIC_VECTOR(TO_UNSIGNED(100, 10));
		o_row <= 0;
	ELSIF i_down = '1' THEN
		IF y = 230 THEN --kotak tic tac toenya rencananya mau buat ukuran 50x50 (setiap kotaknya)
			y<=STD_LOGIC_VECTOR(TO_UNSIGNED(100, 10)); --jadi kan totalnya ada sembilan kotak, ntr bakal di tengah layar gitu
			o_row <= 0;
		ELSE
			IF y = 100 then
				o_row <= 1;
			ELSE
				o_row <= 2;
			END IF;
			y<=y+delta;
		END IF;
	END IF;
END  PROCESS; 
END behavioral; 
