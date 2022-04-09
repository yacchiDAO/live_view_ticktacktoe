defmodule Ticktacktoe.Repo do
  use Ecto.Repo,
    otp_app: :ticktacktoe,
    adapter: Ecto.Adapters.Postgres
end
