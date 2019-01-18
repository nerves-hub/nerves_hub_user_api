# NervesHubCore

[![CircleCI](https://circleci.com/gh/nerves-hub/nerves_hub_core.svg?style=svg)](https://circleci.com/gh/nerves-hub/nerves_hub_core)
[![Hex version](https://img.shields.io/hexpm/v/nerves_hub_core.svg "Hex version")](https://hex.pm/packages/nerves_hub_core)

This is a library for interacting with a NervesHub website programmatically.
See [NervesHubCLI](https://github.com/nerves-hub/nerves_hub_cli) for using it
with `mix`.

Devices do not use this library to connect to a NervesHub server. See
[NervesHub](https://github.com/nerves-hub/nerves_hub) for the reference client.

## Installation

The package can be installed
by adding `nerves_hub_core` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nerves_hub_core, "~> 0.1.0"}
  ]
end
```

The docs can be found at [HexDocs](https://hexdocs.pm/nerves_hub_core).
