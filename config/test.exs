use Mix.Config

nerves_hub_web_path =
  Mix.Project.deps_paths()
  |> Enum.find(&(elem(&1, 0) == :nerves_hub_web))
  |> elem(1)

nerves_hub_web_config = Path.join(nerves_hub_web_path, "config/config.exs")

if File.exists?(nerves_hub_web_config) do
  import_config(nerves_hub_web_config)
end

working_dir = Path.join(nerves_hub_web_path, "test/fixtures/ssl")

config :nerves_hub_core,
  host: "0.0.0.0",
  port: 5002,
  # pass list of paths
  ca_certs: Path.expand("test/fixtures/ssl")

alias NervesHubCA.Intermediate.CA

config :nerves_hub_ca, :api,
  otp_app: :nerves_hub_ca,
  port: 8443,
  cacertfile: Path.join(working_dir, "ca.pem"),
  certfile: Path.join(working_dir, "ca.nerves-hub.org.pem"),
  keyfile: Path.join(working_dir, "ca.nerves-hub.org-key.pem")

config :nerves_hub_ca, CA.User,
  ca: Path.join(working_dir, "user-root-ca.pem"),
  ca_key: Path.join(working_dir, "user-root-ca-key.pem")

config :nerves_hub_ca, CA.Device,
  ca: Path.join(working_dir, "device-root-ca.pem"),
  ca_key: Path.join(working_dir, "device-root-ca-key.pem")

config :nerves_hub_ca,
  ecto_repos: [NervesHubCA.Repo]

config :nerves_hub_ca, NervesHubCA.Repo,
  adapter: Ecto.Adapters.Postgres,
  ssl: false,
  pool: Ecto.Adapters.SQL.Sandbox

config :nerves_hub_web_core, NervesHubWebCore.Repo,
  ssl: false,
  pool_size: 30,
  pool: Ecto.Adapters.SQL.Sandbox

config :nerves_hub_api, NervesHubAPIWeb.Endpoint,
  code_reloader: false,
  check_origin: false,
  server: true,
  watchers: [],
  pubsub: [name: NervesHubWeb.PubSub],
  https: [
    port: 5002,
    otp_app: :nerves_hub_api,
    # Enable client SSL
    verify: :verify_peer,
    keyfile: Path.join(working_dir, "api.nerves-hub.org-key.pem"),
    certfile: Path.join(working_dir, "api.nerves-hub.org.pem"),
    cacertfile: Path.join(working_dir, "ca.pem")
  ]

config :logger, level: :warn
