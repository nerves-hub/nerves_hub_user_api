defmodule NervesHubCore.Device do
  @moduledoc """
  Manage NervesHub devices

  Path: /orgs/:org_name/devices
  """

  alias NervesHubCore.{Auth, API, Org}

  @path "devices"

  @doc """
  Create a new device.

  Verb: POST
  Path: /orgs/:org_name/devices
  """
  @spec create(atom() | binary(), binary(), binary(), [binary()], NervesHubCore.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def create(org_name, identifier, description, tags, %Auth{} = auth) do
    params = %{identifier: identifier, description: description, tags: tags}
    API.request(:post, path(org_name), params, auth)
  end

  @doc """
  Update an existing device.

  Verb: PUT
  Path: /orgs/:org_name/devices/:device_identifier
  """
  @spec update(atom() | binary(), binary(), map(), NervesHubCore.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def update(org_name, device_identifier, params, %Auth{} = auth) do
    params = Map.merge(params, %{identifier: device_identifier})
    API.request(:put, path(org_name, device_identifier), params, auth)
  end

  @doc """
  Check authentication status for device certificate.

  Verb: POST
  Path: /orgs/:org_name/devices/auth
  """
  @spec auth(atom() | binary(), binary(), NervesHubCore.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def auth(org_name, cert_pem, %Auth{} = auth) do
    params = %{certificate: Base.encode64(cert_pem)}
    path = Path.join(path(org_name), "auth")
    API.request(:post, path, params, auth)
  end

  @doc """
  List certificates for a device.

  Verb: GET
  Path: /orgs/:org_name/devices/:device_identifier/certificates
  """
  @spec cert_list(atom() | binary(), binary(), NervesHubCore.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def cert_list(org_name, device_identifier, %Auth{} = auth) do
    API.request(:get, cert_path(org_name, device_identifier), "", auth)
  end

  @doc """
  Sign a new certificate signing request for a device.

  Verb: POST
  Path: /orgs/:org_name/devices/:device_identifier/certificates/sign
  """
  @spec cert_sign(atom() | binary(), binary(), binary(), NervesHubCore.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def cert_sign(org_name, device_identifier, csr, %Auth{} = auth) do
    params = %{identifier: device_identifier, csr: csr}
    path = Path.join(cert_path(org_name, device_identifier), "sign")
    API.request(:post, path, params, auth)
  end

  @doc false
  @spec path(atom() | binary()) :: binary()
  def path(org_name) do
    Path.join(Org.path(org_name), @path)
  end

  @doc false
  @spec path(atom() | binary(), atom() | binary()) :: binary()
  def path(org_name, device_identifier) do
    Path.join(path(org_name), device_identifier)
  end

  @doc false
  @spec cert_path(atom() | binary(), atom() | binary()) :: binary()
  def cert_path(org, device) do
    Path.join(path(org, device), "certificates")
  end
end
