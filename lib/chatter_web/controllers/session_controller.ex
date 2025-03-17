defmodule ChatterWeb.SessionController do
  use ChatterWeb, :controller

  def create(conn, %{"user" => user_params}) do
    case Pow.Plug.authenticate_user(conn, user_params) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: ~p"/chat")

      {:error, conn} ->
        conn
        |> put_flash(:error, "Invalid email or password.")
        |> redirect(to: ~p"/session/new")
    end
  end
end
