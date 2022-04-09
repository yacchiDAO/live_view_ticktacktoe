defmodule Ticktacktoe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Ticktacktoe.Repo,
      # Start the Telemetry supervisor
      TicktacktoeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ticktacktoe.PubSub},
      # Start the Endpoint (http/https)
      TicktacktoeWeb.Endpoint
      # Start a worker by calling: Ticktacktoe.Worker.start_link(arg)
      # {Ticktacktoe.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ticktacktoe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TicktacktoeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
