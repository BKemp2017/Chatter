defmodule ChatterWeb.PageController do
  use ChatterWeb, :controller

  def home(conn, _params) do
    text(conn, "Welcome to Chatter!")
  end
end
