defmodule Ticktacktoe.Square do
  alias __MODULE__
  defstruct writer: "", checked: false

  def new_square do
    %Square{}
  end

  def write(player) do
    %Square{writer: player, checked: true}
  end
end
