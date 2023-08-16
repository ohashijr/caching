defmodule Caching.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CachingWeb.Telemetry,
      # Start the Ecto repository
      Caching.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Caching.PubSub},
      # Start Finch
      {Finch, name: Caching.Finch},
      # Start the Endpoint (http/https)
      CachingWeb.Endpoint
      # Start a worker by calling: Caching.Worker.start_link(arg)
      # {Caching.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Caching.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CachingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
