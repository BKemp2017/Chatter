defmodule Chatter.Repo.Migrations.AddIndexToMessages do
  use Ecto.Migration

  def change do
    create index(:messages, [:inserted_at])
  end
end
