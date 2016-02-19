use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mu_response, MuResponse.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :mu_response, MuResponse.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "kantox_demo_20160118"
