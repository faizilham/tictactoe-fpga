LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY color_rom_vhd  IS 
	PORT( 
	    i_pixel_column  : IN STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    i_pixel_row     : IN STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    sel_x			: in STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    sel_y			: in STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    o_red           : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	    o_green         : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	    o_blue          : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 ));
	    
END color_rom_vhd; 

ARCHITECTURE behavioral OF color_rom_vhd  IS 

CONSTANT R_TF_0   : INTEGER := 100;
CONSTANT R_TF_1   : INTEGER := 150;
CONSTANT R_TF_2   : INTEGER := 165;
CONSTANT R_TF_3	  : INTEGER := 215;
CONSTANT R_TF_4	  : INTEGER := 230;
CONSTANT R_TF_5	  : INTEGER := 280;
CONSTANT R_LN_1	  : INTEGER := 155;
CONSTANT R_LN_2   : INTEGER := 160;
CONSTANT R_LN_3   : INTEGER := 220;
CONSTANT R_LN_4   : INTEGER := 225;
CONSTANT C_TF1_R  : INTEGER := 280;
CONSTANT C_TF2_R  : INTEGER := 345;
CONSTANT C_TF3_R  : INTEGER := 410;
CONSTANT C_LN1_R  : INTEGER := 290;
CONSTANT C_LN2_R  : INTEGER := 355;
CONSTANT C_TF1_L  : INTEGER := 230;
CONSTANT C_TF2_L  : INTEGER := 295;
CONSTANT C_TF3_L  : INTEGER := 360;
CONSTANT C_LN1_L  : INTEGER := 285;
CONSTANT C_LN2_L  : INTEGER := 350;

SIGNAL TF       :  STD_LOGIC;
SIGNAL LN		:  STD_LOGIC; 

BEGIN 
PROCESS(i_pixel_row,i_pixel_column, TF, LN)
BEGIN

  IF ((i_pixel_row >= sel_y)  AND (i_pixel_row < sel_y + 50)) AND ((i_pixel_column >= sel_x)  AND (i_pixel_column < sel_x + 50)  ) THEN 
	TF <=  '1';
  ELSE  
	TF <=  '0';
  END IF;
  
  IF ((i_pixel_column > C_LN1_L) AND (i_pixel_column < C_LN1_R) AND (i_pixel_row > R_TF_0)  AND (i_pixel_row < R_TF_5)) OR ((i_pixel_column >= C_LN2_L) AND (i_pixel_column < C_LN2_R) AND (i_pixel_row > R_TF_0)  AND (i_pixel_row < R_TF_5)) OR ((i_pixel_row > R_LN_1)  AND (i_pixel_row < R_LN_2) AND (i_pixel_column >= C_TF1_L)  AND (i_pixel_column < C_TF3_R)) OR ((i_pixel_row > R_LN_3)  AND (i_pixel_row < R_LN_4) AND (i_pixel_column >= C_TF1_L)  AND (i_pixel_column < C_TF3_R)) THEN 
	LN <=  '1';
  ELSE 
	LN <=  '0';
  END IF;
  

  IF    (TF = '1') 		THEN  o_red <= X"FF"; o_green <= X"00"; o_blue <= X"00";
  ELSIF (LN = '1')	 	THEN  o_red <= X"00"; o_green <= X"00"; o_blue <= X"00";
  ELSE 					 	  o_red <= X"FF"; o_green <= X"FF"; o_blue <= X"FF";
  END IF;
  
  
  
END PROCESS;


END behavioral; 