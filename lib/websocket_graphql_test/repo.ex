defmodule WebsocketGraphqlTest.Repo do
  use Ecto.Repo,
    otp_app: :websocket_graphql_test,
    adapter: Ecto.Adapters.Postgres
end
