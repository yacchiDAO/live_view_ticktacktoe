defmodule Ticktacktoe.Board do
  alias Ticktacktoe.Square
  alias __MODULE__

  defstruct squares: [%Square{}], next_player: "X", winner: nil

  def empty_board(length) do
    %Board{squares: List.duplicate(Square.new_square(), length * length)}
  end

  def select_point(%Board{squares: squares, next_player: player, winner: winner}, point) do
    cond do
      winner == nil ->
        case Enum.at(squares, point) do
          %Square{checked: false} ->
            next_squares = List.replace_at(squares, point, Square.write(player))
            next_board = %Board{squares: next_squares, next_player: calc_next_player(player)}

            %Board{next_board | winner: calc_winner(next_board)}
          _ -> nil
        end
      true ->
        nil
    end
  end

  def square_write(%Board{squares: squares}, point) do
    case Enum.at(squares, point) do
      nil -> nil
      square -> square.writer
    end
  end

  defp calc_next_player("X"), do: "O"
  defp calc_next_player("O"), do: "X"
  # 3人などの拡張もできる
  # defp calc_next_player("T"), do: "X"

  defp calc_winner(%Board{squares: squares}) do
    lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ]

    lines
    |> Enum.map(fn [a, b, c] ->
        if Enum.at(squares, a).checked && Enum.at(squares, a).writer == Enum.at(squares, b).writer && Enum.at(squares, a).writer == Enum.at(squares, c).writer do
          Enum.at(squares, a).writer
        else
          nil
        end
      end)
    |> Enum.filter(&(&1 != nil))
    |> List.first
  end
end
