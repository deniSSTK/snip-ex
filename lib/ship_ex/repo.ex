defmodule ShipEx.Repo do
  use Ecto.Repo,
    otp_app: :ship_ex,
    adapter: Ecto.Adapters.Postgres
end
