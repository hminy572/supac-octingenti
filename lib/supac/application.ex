defmodule Supac.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Supac.Repo,
      # Start the Telemetry supervisor
      SupacWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Supac.PubSub},
      # Start the Endpoint (http/https)
      SupacWeb.Endpoint
      # Start a worker by calling: Supac.Worker.start_link(arg)
      # {Supac.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Supac.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SupacWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
