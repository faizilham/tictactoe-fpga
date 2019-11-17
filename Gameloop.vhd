library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.pkg_tubes.all;

entity Gameloop is
	port(
		clk : in std_logic;
		player : in board_index;
		movement : out board_index;
		playing : out boolean;
		xout : out board_index;
		o_turn : out board_index;
		o_board : out arr_board
		);
end Gameloop;

architecture behavioral of Gameloop is

component FPGA_AI is 
	port(clk : in std_logic;
		start : in std_logic;
		board : in arr_board;
		turn : in board_index;
		xout : out board_index;
		movement : out board_index
		);
end component;	

signal board : arr_board := (others => 0);
signal fpga_mov : board_index := 0;
signal player_mov : board_index;
signal fpga_start : std_logic := '1';
signal turn : board_index := 1;
signal winnerId : board_index := 0;
signal counter : integer := 0;
--signal xout : board_index;

type gamephase is (fpga_turn, cek_fpga, player_turn, cek_player, end_phase);
signal phase : gamephase := fpga_turn;

begin
	fp : FPGA_AI port map (clk => clk, start=>fpga_start, board=>board, turn=>turn, xout=>xout, movement=>fpga_mov);
	movement <= fpga_mov;
	player_mov<=player;
	o_board <= board;
	o_turn <= turn;
	process (clk) begin
		if (clk'event and clk = '1') then
			case phase is
			when fpga_turn =>
				playing <= true;
				if (counter > 3) then 
					fpga_start <= '0';
				else
					counter<=counter + 1;
				end if;
				if (fpga_mov /= 0 and board(fpga_mov) = 0) then
					board(fpga_mov) <= 1;
					phase <= cek_fpga;
				else
					phase <= fpga_turn;
				end if;
			when cek_fpga =>
				playing <= false;
				if win_check(1,2,3, board) then
					winnerId <= board(1);
					phase <= end_phase;
				elsif win_check(4,5,6, board) then
					winnerId <= board(4);
					phase <= end_phase;
				elsif win_check(7,8,9, board) then
					winnerId <= board(7);
					phase <= end_phase;
				elsif win_check(1,4,7, board) then
					winnerId <= board(1);
					phase <= end_phase;
				elsif win_check(2,5,8, board) then
					winnerId <= board(2);
					phase <= end_phase;
				elsif win_check(3,6,9, board) then
					winnerId <= board(3);
					phase <= end_phase;
				elsif win_check(1,5,9, board) then
					winnerId <= board(1);
					phase <= end_phase;
				elsif win_check(3,5,7, board) then
					winnerId <= board(3);
					phase <= end_phase;
				elsif turn = 9 then
					winnerId <= 0;
					phase <= end_phase;
				else
					turn <= turn + 1;
					counter <= 0;
					phase <= player_turn;
				end if;
			when player_turn=>
				playing <= true;
				if (player_mov /= 0 and player_mov /= 1 and counter = 0 and board(player_mov) = 0) then
					board(player_mov) <= 2;
					counter <= 1;
					phase<=player_turn;
				elsif counter = 0 then
					phase<=player_turn;
				else
					phase<=cek_player;
				end if;
			when cek_player =>
				playing <= false;
				if win_check(1,2,3, board) then
					winnerId <= board(1);
					phase <= end_phase;
				elsif win_check(4,5,6, board) then
					winnerId <= board(4);
					phase <= end_phase;
				elsif win_check(7,8,9, board) then
					winnerId <= board(7);
					phase <= end_phase;
				elsif win_check(1,4,7, board) then
					winnerId <= board(1);
					phase <= end_phase;
				elsif win_check(2,5,8, board) then
					winnerId <= board(2);
					phase <= end_phase;
				elsif win_check(3,6,9, board) then
					winnerId <= board(3);
					phase <= end_phase;
				elsif win_check(1,5,9, board) then
					winnerId <= board(1);
					phase <= end_phase;
				elsif win_check(3,5,7, board) then
					winnerId <= board(3);
					phase <= end_phase;
				elsif turn = 9 then
					winnerId <= 0;
					phase <= end_phase;
				else
					turn <= turn + 1;
					fpga_start <= '1';
					counter <= 0;
					phase <= fpga_turn;
				end if;
			when end_phase =>
				playing <= true;
				turn <= 0;
				board <= (others => 0);
				phase <= end_phase;
			end case;
			
		end if;
	end process;
	
end behavioral;