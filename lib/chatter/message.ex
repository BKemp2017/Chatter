defmodule Chatter.Message do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query

  schema "messages" do
    field :message, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :message])
    |> validate_required([:name, :message])
  end

  def recent_messages(limit \\ 10) do
    Chatter.Message
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> Chatter.Repo.all()
  end
end
