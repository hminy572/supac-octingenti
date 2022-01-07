defmodule Supac.Repo do
  use Ecto.Repo,
    otp_app: :Supac,
    adapter: Ecto.Adapters.Postgres
end
