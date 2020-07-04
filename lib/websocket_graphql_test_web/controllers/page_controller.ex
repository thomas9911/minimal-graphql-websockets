defmodule WebsocketGraphqlTestWeb.PageController do
  use WebsocketGraphqlTestWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
