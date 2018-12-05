defmodule NervesHubCore.MixProject do
  use Mix.Project

  def project do
    [
      app: :nerves_hub_core,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [main: "readme", extras: ["README.md"]],
      description: description(),
      package: package(),
      dialyzer: [ignore_warnings: "dialyzer.ignore-warnings"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    "NervesHub API client"
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/nerves-hub/nerves_hub_core"}
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
      {:ex_doc, "~> 0.19", only: [:dev, :test], runtime: false},
      {:dialyxir, "1.0.0-rc.4", only: [:dev, :test], runtime: false},
      {:nerves_hub_web, github: "nerves-hub/nerves_hub_web", only: :test, runtime: false},
      {:nerves_hub_ca, github: "nerves-hub/nerves_hub_ca", only: :test, runtime: false}
    ]
  end
end
