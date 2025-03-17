defmodule ChatterWeb.Router do
  use ChatterWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation]

  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ChatterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    # ✅ Custom Session Handling
    post "/session", ChatterWeb.SessionController, :create
    delete "/session", Pow.Phoenix.SessionController, :delete

    # ✅ Pow Authentication Routes (AFTER custom session handling)
    pow_routes()
    pow_extension_routes()
  end

  scope "/", ChatterWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/chat", ChatController, :index
    get "/debug-auth", DebugAuthController, :show
  end

  if Application.compile_env(:chatter, :dev_routes) do
    scope "/dev" do
      pipe_through :browser
      get "/", PageController, :home
      get "/chat", ChatterWeb.ChatController, :index

      live_dashboard "/dashboard", metrics: ChatterWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
