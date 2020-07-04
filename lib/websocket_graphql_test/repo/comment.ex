defmodule WebsocketGraphqlTest.Repo.Comment do
  use Ecto.Schema
  import Ecto.Changeset
#   import Ecto.Query, only: [from: 2]
  alias WebsocketGraphqlTest.Repo


  schema "comments" do
    field :title, :string
    field :content, :string
    field :repo_name, :string
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:title, :content, :repo_name])
  end

  def list() do
    {:ok, __MODULE__
    |> Repo.all()}
  end

  def create(args) do
    %__MODULE__{} |> changeset(args) |> Repo.insert()
  end
end
