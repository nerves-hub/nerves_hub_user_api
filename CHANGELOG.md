# Changelog

## v0.4.0

Backwards incompatible changes:

Renamed the project `nerves_hub_user_api`
Changed configuration settings from `api_host` and `api_port` back to `host` and
`port`. You will need to update these your settings and the application name
in your`config.exs` file.

## v0.3.0

Backwards incompatible changes:

For clarity, the application config settings `host` and `port` were renamed to
`api_host` and `api_port`. If you're using your own NervesHub instance, you will
need to update your `config.exs`.

## v0.2.0

* Enhancements
  * Added `NervesHubCore.Device.list/2`

## v0.1.0

Initial release
