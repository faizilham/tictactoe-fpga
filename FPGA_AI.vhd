library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library work;
--use work.pkg_tubes.all;

entity FPGA_AI is
	port(clk : in std_logic;
		start : in std_logic;
		board : in arr_board;
		turn : in board_index;
		xout : out board_index;
		movement : out board_index
		
		);
end FPGA_AI;

architecture behavioral of FPGA_AI is

--signal board : arr_board := (1 => 0, 2=>0, 3=>2, 4 => 0, 5 => 2, 6 => 0, 7 =>0, 8 => 0, 9=>0, others=>0);
signal x : board_index :=1; --incremental
signal y : board_index := 0; --output
signal y1 : board_index := 0; --temp output handler

type movestate is (idle_state, win_state, block_state, trick_state, mid_state, free_state);
signal currState : movestate := idle_state;

type checkarea is (horizontal, vertical, diagonal1, diagonal2);
signal check : checkarea := horizontal;

begin
	movement <= y;
	xout <= x;
		
	process (clk) begin
		if (clk'event and clk = '1') then
		case currState is
			when idle_state =>
				--nunggu giliran
				x <= 1;
				check <= horizontal;
				if(start = '0') then
					currState <= idle_state;
				elsif(start ='1') then
					y <= 0;
					currState <= win_state;
				end if;
			when win_state =>
				--pengecekan langkah menuju kemenangan
				if check = horizontal then
					y1 <= fpga_move(x, x + 1, x + 2, 1, board);
					x <= x + 3;
				elsif check = vertical then
					y1 <= fpga_move(x, x + 3, x + 6, 1, board);
					x <= x + 1;
				elsif check = diagonal1 then 
					y1 <= fpga_move(1, 5, 9, 1, board);
					x <= x + 1;
				elsif check = diagonal2 then
					y1 <= fpga_move(3, 5, 7, 1, board);
					x <= x + 1;
				end if;
				
				if (y1 /= 0) then
					y <= y1;
					currState <= idle_state; -- sukses
				else
					if (x > 9 and check = horizontal) then 
						x <= 1;
						check <= vertical;
						currState <= win_state;
					elsif (x > 3 and check = vertical) then
						x <= 1;
						check <= diagonal1;
						currState <= win_state;
					elsif (x > 1 and check = diagonal1) then
						x <= 1;
						check <= diagonal2;
						currState <= win_state;
					elsif (x > 1 and check = diagonal2) then
						x <= 1;
						check <= horizontal;
						currState <= block_state; -- next
					else
						currState <= win_state;
					end if;
				end if;
			when block_state =>
				--pengecekan langkah blok kemenangan lawan
				if check = horizontal then
					y1 <= fpga_move(x, x + 1, x + 2, 2, board);
					x <= x + 3;
				elsif check = vertical then
					y1 <= fpga_move(x, x + 3, x + 6, 2, board);
					x <= x + 1;
				elsif check = diagonal1 then 
					y1 <= fpga_move(1, 5, 9, 2, board);
					x <= x + 1;
				elsif check = diagonal2 then
					y1 <= fpga_move(3, 5, 7, 2, board);
					x <= x + 1;
				end if;
				
				if (y1 /= 0) then
					y <= y1;
					currState <= idle_state; -- sukses
				else
					if (x > 9 and check = horizontal) then 
						x <= 1;
						check <= vertical;
						currState <= block_state;
					elsif (x > 3 and check = vertical) then
						x <= 1;
						check <= diagonal1;
						currState <= block_state;
					elsif (x > 1 and check = diagonal1) then
						x <= 1;
						check <= diagonal2;
						currState <= block_state;
					elsif (x > 1 and check = diagonal2) then
						x <= 1;
						check <= horizontal;
						currState <= trick_state; -- next
					else
						currState <= block_state;
					end if;
				end if;
			when trick_state =>
				--langkah trik
				if (turn = 1) then
					y <= 1;
					currState <= idle_state;
				elsif (turn = 3) then
					if board(2) = 2 then
						y<=7;
						currState <= idle_state;
					elsif board(4) = 2 then
						y<=3;
						currState <= idle_state;
					elsif board(6) = 2 then
						y<=7;
						currState <= idle_state;
					elsif board(8) = 2 then
						y<=3;
						currState <= idle_state;
					elsif board(3) = 2 then
						y<=9;
						currState <= idle_state;
					elsif board(5) = 2 then
						y<=9;
						currState <= idle_state;
					elsif board(7) = 2 then
						y<=9;
						currState <= idle_state;
					elsif board(9) = 2 then
						y<=3;
						currState <= idle_state;
					else
						currState <= mid_state; -- next
					end if;
				elsif (turn = 5) then
					if board(9) = 2 then
						y<=7;
						currState <= idle_state;
					else
						currState <= mid_state; -- next
					end if;
				else
					currState <= mid_state; -- next
				end if;
			when mid_state =>
				-- isi kotak tengah
				if board(5) = 0 then
					y<=5;
					currState <= idle_state;
				else
					x <= 1;
					currState <= free_state; --next
				end if;
			when free_state =>
				-- isi kotak yang tersisa
				if board(x) = 0 then
					y<= x;
					currState <= idle_state;
				elsif board(x) /= 0 and x = 9 then
					y<=0;
					currState <= idle_state;
				else
					x <= x+1;
					currState <= free_state;
				end if;
			end case;
		end if;
		
	end process;	
end behavioral;