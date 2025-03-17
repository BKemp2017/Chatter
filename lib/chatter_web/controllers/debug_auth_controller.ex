defmodule ChatterWeb.DebugAuthController do
  use ChatterWeb, :controller

  def show(conn, _params) do
    user = Pow.Plug.current_user(conn)

    message =
      if user do
        "User logged in: #{user.email}"
      else
        "User not logged in"
      end

    send_resp(conn, 200, message)
  end
end
