defmodule ChatterWeb.ChatController do
  use ChatterWeb, :controller

  def index(conn, _params) do
    conn
    |> put_view(ChatterWeb.ChatHTML)
    |> render(:index)
  end
end
