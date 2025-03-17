defmodule ChatterWeb.RegistrationController do
  use ChatterWeb, :controller
  alias Chatter.Repo
  alias Chatter.Users.User
  alias Pow.Plug

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Repo.insert(User.changeset(%User{}, user_params)) do
      {:ok, user} ->
        conn
        |> Plug.create(user)
        |> put_flash(:info, "Account created successfully")
        |> redirect(to: "/chat")

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
