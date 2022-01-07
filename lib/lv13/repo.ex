defmodule Supac.Repo do
  use Ecto.Repo,
    otp_app: :supac,
    adapter: Ecto.Adapters.Postgres
end
