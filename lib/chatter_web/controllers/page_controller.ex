defmodule ChatterWeb.PageController do
  use ChatterWeb, :controller
  alias Pow.Phoenix.Routes

  def home(conn, _params) do
    conn
    |> put_view(ChatterWeb.Pow.SessionHTML)
    |> render("new.html",
      changeset: Pow.Plug.change_user(conn),
      action: Routes.session_path(conn, :create)
    )
  end
end
