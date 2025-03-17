import Config

config :chatter,
  ecto_repos: [Chatter.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :chatter, ChatterWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ChatterWeb.ErrorHTML, json: ChatterWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Chatter.PubSub,
  live_view: [signing_salt: "LDSpC4M0"]

config :chatter, Chatter.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  chatter: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  chatter: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :chatter, :pow,
  web_module: ChatterWeb,
  user: Chatter.Users.User,
  repo: Chatter.Repo,
  routes_backend: ChatterWeb.PowRoutes,
  routes_after_sign_in: &ChatterWeb.PowRoutes.after_sign_in_path/1,
  extensions: [PowResetPassword, PowEmailConfirmation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: ChatterWeb.Pow.Mailer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
