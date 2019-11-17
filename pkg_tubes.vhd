library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package pkg_tubes is

	subtype board_stat is integer range 0 to 2;
	subtype board_index is integer range 0 to 9;
	
	type arr_board is array (0 to 9) of board_stat; -- range 0 hanya untuk menyatakan kotak null
	
	function win_check (a: board_index; b: board_index; c: board_index; board: arr_board) return boolean;
	function fpga_move (a: board_index; b: board_index; c: board_index; id: board_stat; board: arr_board) return board_index;
	
end pkg_tubes;

package body pkg_tubes is

	function win_check (a: board_index; b: board_index; c: board_index; board: arr_board) return boolean is
	--mengecek kemenangan, mengembalikan id pemenang atau 0 jika tidak ada yang menang
	begin
		return (board(a) = board(b)) and (board(c) = board(b)) and (board(a) /= 0);
	end win_check;
	
	function fpga_move (a: board_index; b: board_index; c: board_index; id: board_stat; board: arr_board) return board_index is
	--fpga mengecek langkahnya untuk menang / blok kemenangan lawan. langkah menang -> id = 1, blok menang id = 2
	-- mengembalikan index posisi pengisian yang benar
	begin
		if (board(a) = id) and (board(a) = board(b)) and (board(c) = 0) then
			return c;
		elsif (board(a) = id) and (board(a) = board(c)) and (board(b) = 0) then
			return b;
		elsif (board(b) = id) and (board(b) = board(c)) and (board(a) = 0) then
			return a;
		else
			return 0;
		end if;
	end fpga_move;
	
end pkg_tubes;