defmodule WebsocketGraphqlTest.Repo.Migrations.AddComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :title, :string
      add :content, :string
      add :repo_name, :string
    end
  end
end
