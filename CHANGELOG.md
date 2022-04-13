# Changelog

## 0.9.0

This releases shifts preferance to token authentication rather than the user
client certificate that was being used. This changes is backwards compatible
and you can continue to use certificates, but a warning will be emmitted.
See [nerves-hub/nerves_hub_web#818](https://github.com/nerves-hub/nerves_hub_web/pull/818)
for more details.

* New features
  * Added `:token` to `%NervesHubUserAPI.Auth{}` struct for token based authentication
  * `NervesHubUserAPI.User.login/3` to authenticate and create a token for later use

## 0.8.0

* Breaking Changes
  * This release includes a change to how CA certificates are used in the connection
    to NervesHub. If you are connecting to the publicly hosted https://nerves-hub.org,
    then no changes are required.
    If you are manually supplying `:ca_certs` config value to connect to another instance
    of NervesHub, then you will need to update you config following the new instructions
    for [Configuration](README.md#configuration) in the README

## v0.7.1

* New features
  * Allow description when registering CA Certificate with
  `NervesHubUserAPI.CACertificate.create/4` (thanks @brianberlin !! :tada:)

## v0.7.0

* Deprecations
  * `NervesHubUserAPI.Device.cert_list/4` has been moved to
    `NervesHubUserAPI.DeviceCertificate.list/4`
  * `NervesHubUserAPI.Device.cert_sign/5` has been moved to
    `NervesHubUserAPI.DeviceCertificate.sign/5`
* New features
  * Added `NervesHubUserAPI.DeviceCertificate.create/5` for import an existing
    trusted certificate for a device.
  * Added `NervesHubUserAPI.DeviceCertificate.delete/5` for deleting certificates
    from a device.
* Bug fixes
  * URI encode all parameters being used in the URL of the API requests.

## v0.6.0

Backwards incompatible changes:

The NervesHubUserAPI.Device and NervesHubUserAPI.DeviceCertificate endpoints
have moved to include `product` as part of its path.

It used to be

```text
/orgs/:org_name/devices*
```

They have moved to:

```text
/orgs/:org_name/products/:product_name/devices*
```

## v0.5.0

* New features
  * Added support managing user roles for organizations and products.
    * `OrgUser` `add / update / remove / list`
    * `ProductUser` `add / update / remove / list`

## v0.4.1

* New features
  * Support deleting devices via the API

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
