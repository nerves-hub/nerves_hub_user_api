# NervesHubUserAPI

[![CircleCI](https://circleci.com/gh/nerves-hub/nerves_hub_user_api.svg?style=svg)](https://circleci.com/gh/nerves-hub/nerves_hub_user_api)
[![Hex version](https://img.shields.io/hexpm/v/nerves_hub_user_api.svg "Hex version")](https://hex.pm/packages/nerves_hub_user_api)

This is a library for interacting with a NervesHub website programmatically.
See [NervesHubCLI](https://github.com/nerves-hub/nerves_hub_cli) for using it
with `mix`.

Devices do not use this library to connect to a NervesHub server. See
[NervesHubLink](https://github.com/nerves-hub/nerves_hub_link) for the reference client.

## Installation

The package can be installed
by adding `nerves_hub_user_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nerves_hub_user_api, "~> 0.8.0"}
  ]
end
```

The docs can be found at [HexDocs](https://hexdocs.pm/nerves_hub_user_api).

## Environment variables

`NervesHubUserAPI` may be configured using environment variables to simplify
automation. Environment variables take precedence over configuration. The
following variables are available:

* `NERVES_HUB_HOST` - NervesHub API endpoint IP address or hostname (defaults to
  `api.nerves-hub.org`)
* `NERVES_HUB_PORT` - NervesHub API endpoint port (defaults to 443)
* `NERVES_LOG_DISABLE_PROGRESS_BAR` - Set to disable the progress bar on file
  transfers

## Configuration

`NervesHubUserAPI` may also be configured in the `config.exs`. It supports the
following keys:

* `host` - NervesHub API endpoint address (defaults to `api.nerves-hub.org`)
* `port` - NervesHub API endpoint port (defaults to 443)
* `ca_store` - A module that exposes a single function `ca_certs` that returns
  certs as a list of DER encoded binaries. (Defaults to [`NervesHubCAStore`](https://github.com/nerves-hub/nerves_hub_ca_store))
