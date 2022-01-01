defmodule Lv13.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Lv13.Repo,
      # Start the Telemetry supervisor
      Lv13Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Lv13.PubSub},
      # Start the Endpoint (http/https)
      Lv13Web.Endpoint
      # Start a worker by calling: Lv13.Worker.start_link(arg)
      # {Lv13.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lv13.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Lv13Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
