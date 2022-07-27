defmodule NervesHubUserAPI.MixProject do
  use Mix.Project

  @version "0.9.1"
  @source_url "https://github.com/nerves-hub/nerves_hub_user_api"

  def project do
    [
      app: :nerves_hub_user_api,
      version: @version,
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
      dialyzer: dialyzer(),
      preferred_cli_env: %{
        docs: :docs,
        "hex.publish": :docs,
        "hex.build": :docs
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      env: [host: "api.nerves-hub.org", port: 443],
      extra_applications: [:logger] ++ extra_applications(Mix.env())
    ]
  end

  def extra_applications(:test),
    do: [
      :phoenix,
      :ecto_sql
    ]

  def extra_applications(_), do: []

  defp description do
    "NervesHub Management API client"
  end

  defp dialyzer do
    [
      flags: [:missing_return, :extra_return, :unmatched_returns, :error_handling, :underspecs],
      ignore_warnings: "dialyzer.ignore-warnings"
    ]
  end

  defp docs do
    [
      extras: ["README.md", "CHANGELOG.md"],
      main: "readme",
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"],
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.0"},
      {:tesla, "~> 1.2.1 or ~> 1.3"},
      {:hackney, "~> 1.9"},
      {:x509, "~> 0.3"},
      {:nerves_hub_ca_store, "~> 1.0.0"},
      {:ex_doc, "~> 0.23", only: [:docs], runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false},

      # test deps for integration test w/ nerves_hub_web
      {:phoenix, "~> 1.4", only: :test, override: true},
      {:nerves_hub_web,
       github: "nerves-hub/nerves_hub_web", branch: "main", only: :test, runtime: false},
      {:nerves_hub_ca,
       github: "nerves-hub/nerves_hub_ca", branch: "main", only: :test, runtime: false}
    ]
  end
end
