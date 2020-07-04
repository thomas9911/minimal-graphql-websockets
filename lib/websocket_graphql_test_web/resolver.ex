defmodule WebsocketGraphqlTestWeb.Resolver do
  alias WebsocketGraphqlTest.Repo.Comment

  def submit_comment(_parent, args, _resolution) do
    Comment.create(args)
  end

  def list_comment(_parent, _args, _resolution) do
    Comment.list()
  end
end
