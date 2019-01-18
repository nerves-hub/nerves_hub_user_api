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

## Environment variables

`NervesHubCore` may be configured using environment variables to simplify
automation. Environment variables take precedence over configuration. The
following variables are available:

* `NERVES_HUB_HOST` - NervesHub API endpoint IP address or hostname (defaults to
  `api.nerves-hub.org`)
* `NERVES_HUB_PORT` - NervesHub API endpoint port (defaults to 443)
* `NERVES_LOG_DISABLE_PROGRESS_BAR` - Set to disable the progress bar on file
  transfers
* `NERVES_HUB_CA_CERTS` - The path to a directory containing CA certificates for
  authenticating NervesHub endpoints. Defaults to `nerves-hub.org` certificates.

## Configuration

`NervesHubCore` may also be configured in the `config.exs`. It supports the
following keys:

* `api_host` - NervesHub API endpoint address (defaults to `api.nerves-hub.org`)
* `api_port` - NervesHub API endpoint port (defaults to 443)
* `ca_certs` - The path to a directory containing CA certificates for
  authenticating NervesHub endpoints. Defaults to `nerves-hub.org` certificates.

