defmodule WebsocketGraphqlTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      WebsocketGraphqlTest.Repo,
      # Start the Telemetry supervisor
      WebsocketGraphqlTestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: WebsocketGraphqlTest.PubSub},
      # Start the Endpoint (http/https)
      WebsocketGraphqlTestWeb.Endpoint,
      {Absinthe.Subscription, WebsocketGraphqlTestWeb.Endpoint}
      # Start a worker by calling: WebsocketGraphqlTest.Worker.start_link(arg)
      # {WebsocketGraphqlTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebsocketGraphqlTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WebsocketGraphqlTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
