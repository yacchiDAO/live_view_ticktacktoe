defmodule Ticktacktoe.Game do
  alias Ticktacktoe.Board
  alias __MODULE__

  @enforce_keys [:board]
  defstruct board: %Board{}, step: 1

  def new_game(board_length) do
    %Game{board: Board.empty_board(board_length), step: 1}
  end

  def select_point(%Game{board: board, step: step}, point) do
    case Board.select_point(board, point) do
      nil -> nil
      board -> %Game{board: board, step: step + 1}
    end
  end
end
