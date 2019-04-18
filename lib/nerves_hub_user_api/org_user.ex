defmodule NervesHubUserAPI.OrgUser do
  @moduledoc """
  Manage OrgUsers on NervesHub

  Path: /orgs/:org_name/users
  """

  alias NervesHubUserAPI.{Auth, API, Org}

  @path "users"
  @roles [:admin, :delete, :write, :read]

  @doc """
  List all users for an org.

  Verb: GET
  Path: /orgs/:org_name/users
  """
  @spec list(atom() | binary(), NervesHubUserAPI.Auth.t()) :: {:error, any()} | {:ok, any()}
  def list(org_name, %Auth{} = auth) do
    API.request(:get, path(org_name), "", auth)
  end

  @doc """
  Add a user to the org with a role.

  Verb: POST
  Path: /orgs/:org_name/users
  """
  @spec add(atom() | binary(), binary(), binary(), NervesHubUserAPI.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def add(org_name, username, role, %Auth{} = auth) when role in @roles do
    params = %{username: username, role: role}
    API.request(:post, path(org_name), params, auth)
  end

  def add(_org_name, _username, _role, _auth) do
    {:error, :invalid_role}
  end

  @doc """
  Update an existing org user's role.

  Verb: PUT
  Path: /orgs/:org_name/users/:username
  """
  @spec update(atom() | binary(), atom() | binary(), binary(), NervesHubUserAPI.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def update(org_name, username, role, %Auth{} = auth) do
    params = %{role: role}
    API.request(:put, path(org_name, username), params, auth)
  end

  @doc """
  Remove a user from the org.

  Verb: DELETE
  Path: /orgs/:org_name/users/:username
  """
  @spec remove(atom() | binary(), binary(), NervesHubUserAPI.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def remove(org_name, username, %Auth{} = auth) do
    API.request(:delete, path(org_name, username), "", auth)
  end

  @spec path(atom() | binary()) :: binary()
  def path(org) when is_atom(org), do: to_string(org) |> path()

  def path(org) when is_binary(org) do
    Path.join(Org.path(org), @path)
  end

  @doc false
  @spec path(atom() | binary(), atom() | binary()) :: binary()
  def path(org_name, username) do
    Path.join(path(org_name), username)
  end
end
