defmodule TicktacktoeWeb.GameLive do
  use TicktacktoeWeb, :live_view
  alias Ticktacktoe.{Game, Board, Square}

  @board_length 3

  def mount(_params, _session, socket) do
    {:ok, assign(socket, histories: [Game.new_game(@board_length)], board_length: @board_length)}
  end

  # TODO: viewどうやって切り分けるか考える
  def render(assigns) do
    ~L"""
    <div class="game">
      <% %Game{board: %Board{squares: squares, winner: winner, next_player: next_player}, step: step} = Enum.max_by(@histories, &(&1.step)) %>

      <div class="game-board">
        <%= for x <- 0..(@board_length - 1) do %>
          <div class="board-row">
            <%= for y <- 0..(@board_length - 1) do %>
              <% point = x * @board_length + y %>
              <% %Square{writer: writer} = Enum.at(squares, point) %>
              <button class="square" phx-click="select" phx-value-point="<%= point %>">
                <%= writer %>
              </button>
            <% end %>
          </div>
        <% end %>
      </div>

      <div class="game-info">
        <div class="status">
          <%= if winner == nil do %>
            Next player: <%= next_player %>
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

    case Enum.max_by(histories, &(&1.step)) |> Game.select_point(formatted_point) do
      nil ->
        {:noreply, socket}
      new_history ->
        IO.inspect new_history
        {:noreply, assign(socket, histories: [new_history | histories])}
    end
  end

  def handle_event("move", %{"step" => str_step}, %{assigns: %{histories: histories}} = socket) do
    target_step = String.to_integer(str_step)
    {:noreply, assign(socket, histories: Enum.filter(histories, fn %{step: step} -> step <= target_step end))}
  end
end
