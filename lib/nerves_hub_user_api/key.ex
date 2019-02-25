defmodule NervesHubUserAPI.Key do
  @moduledoc """
  Manages firmware signing keys

  Path: /orgs/:org_name/keys
  """

  alias NervesHubUserAPI.{Auth, API, Org}

  @path "keys"

  @doc """
  List all keys for an org.

  Verb: GET
  Path: /orgs/:org_name/keys
  """
  @spec list(atom() | binary(), NervesHubUserAPI.Auth.t()) :: {:error, any()} | {:ok, any()}
  def list(org_name, %Auth{} = auth) do
    API.request(:get, path(org_name), "", auth)
  end

  @doc """
  Add a public firmware signing key.

  Verb: POST
  Path: /orgs/:org_name/keys
  """
  @spec create(atom() | binary(), binary(), binary(), NervesHubUserAPI.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def create(org_name, key_name, key, %Auth{} = auth) do
    params = %{name: key_name, key: key}
    API.request(:post, path(org_name), params, auth)
  end

  @doc """
  Delete a firmware signing key.

  Verb: DELETE
  Path: /orgs/:org_name/keys/:key_name
  """
  @spec delete(atom() | binary(), binary(), NervesHubUserAPI.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def delete(org_name, key_name, %Auth{} = auth) do
    API.request(:delete, path(org_name, key_name), "", auth)
  end

  @doc false
  @spec path(atom() | binary()) :: binary()
  def path(org_name) do
    Path.join(Org.path(org_name), @path)
  end

  @doc false
  @spec path(atom() | binary(), atom() | binary()) :: binary()
  def path(org_name, key_name) do
    Path.join(path(org_name), key_name)
  end
end
