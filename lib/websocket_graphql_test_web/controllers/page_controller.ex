defmodule WebsocketGraphqlTestWeb.PageController do
  use WebsocketGraphqlTestWeb, :controller
  use Absinthe.Phoenix.Controller, schema: MyAppWeb.Schema, action: [mode: :internal]

  def index(conn, _params) do
    # IO.inspect(conn)
    conn
    # |> put_layout(false)
    |> render("cheese.html")
    # html(conn, cheese.html)
  end
end
