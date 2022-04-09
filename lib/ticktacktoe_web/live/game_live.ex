defmodule TicktacktoeWeb.GameLive do
  use TicktacktoeWeb, :live_view

  @board_length 3

  def mount(_params, _session, socket) do
    {:ok, reset_game(socket)}
  end

  def render(assigns) do
    ~L"""
    <div class="game">
      <% %{board: board, is_next_x: is_next_x, winner: winner} = Enum.max_by(@histories, &(&1[:step])) %>

      <div class="game-board">
        <%= for x <- 0..(@board_length - 1) do %>
          <div class="board-row">
            <%= for y <- 0..(@board_length - 1) do %>
              <% point = x * @board_length + y %>
              <button class="square" phx-click="select" phx-value-point="<%= point %>">
                <%= Enum.at(board, point) %>
              </button>
            <% end %>
          </div>
        <% end %>
      </div>

      <div class="game-info">
        <div class="status">
          <%= if winner == nil do %>
            Next player: <%= if is_next_x, do: "X", else: "O" %>
          <% else %>
            Winner: <%= winner %>
          <% end %>
        </div>
        <ol>
          <%= for %{step: step} <- Enum.reverse(@histories) do %>
            <% desc = if step == 1, do: "Go to game start", else: "Go to move ##{step - 1}" %>
            <li>
              <button phx-click="move" phx-value-step="<%= step %>"><%= desc %></button>
            </li>
          <% end %>
        </ol>
      </div>
    </div>
    """
  end

  def handle_event("select", %{"point" => point}, %{assigns: %{histories: histories}} = socket) do
    formatted_point = String.to_integer(point)
    %{board: board, is_next_x: is_next_x, winner: winner, step: step} = Enum.max_by(histories, &(&1[:step]))

    # 多分関数にしたほうが良さそう
    cond do
      winner == nil and Enum.at(board, formatted_point) == nil ->
        %{is_next_x: next_is_next_x, board: next_board} = select_point(board, is_next_x, formatted_point)
        next_histories = [%{board: next_board, is_next_x: next_is_next_x, winner: calc_winner(next_board), step: step + 1} | histories]

        {:noreply, assign(socket, histories: next_histories)}
      true ->
        {:noreply, socket}
      end
  end

  def handle_event("move", %{"step" => str_step}, %{assigns: %{histories: histories}} = socket) do
    target_step = String.to_integer(str_step)
    {:noreply, assign(socket, histories: Enum.filter(histories, fn %{step: step} = history -> step <= target_step end))}
  end

  defp reset_game(socket) do
    assign(socket, histories: [new_game()], board_length: @board_length)
  end

  defp new_game do
    %{board: empty_board(@board_length), is_next_x: true, winner: nil, step: 1}
  end

  defp empty_board(length) do
    List.duplicate(nil, length * length)
  end

  defp select_point(board, is_next_x, point) do
    %{is_next_x: !is_next_x, board: List.replace_at(board, point, (if is_next_x, do: "X", else: "O"))}
  end

  defp calc_winner(board) do
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
        if Enum.at(board, a) != nil && Enum.at(board, a) == Enum.at(board, b) && Enum.at(board, a) == Enum.at(board, c) do
          Enum.at(board, a)
        else
          nil
        end
      end)
    |> Enum.filter(&(&1 != nil))
    |> List.first
  end
end
