defmodule NervesHubUserAPI.ProductUser do
  @moduledoc """
  Manage ProductUsers on NervesHub

  Path: /orgs/:org_name/products/:product_name/users
  """

  alias NervesHubUserAPI.{Auth, API, Product}

  @path "users"
  @roles [:admin, :delete, :write, :read]

  @doc """
  List all users for a product.

  Verb: GET
  Path: /orgs/:org_name/product/:product_name/users
  """
  @spec list(atom() | binary(), atom() | binary(), NervesHubUserAPI.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def list(org_name, product_name, %Auth{} = auth) do
    API.request(:get, path(org_name, product_name), "", auth)
  end

  @doc """
  Add a user to the org with a role.

  Verb: POST
  Path: /orgs/:org_name/product/:product_name/users
  """
  @spec add(atom() | binary(), atom() | binary(), binary(), binary(), NervesHubUserAPI.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def add(org_name, product_name, username, role, %Auth{} = auth) when role in @roles do
    params = %{username: username, role: role}
    API.request(:post, path(org_name, product_name), params, auth)
  end

  def add(_org_name, _username, _role, _auth) do
    {:error, :invalid_role}
  end

  @doc """
  Update an existing org user's role.

  Verb: PUT
  Path: /orgs/:org_name/product/:product_name/users/:username
  """
  @spec update(
          atom() | binary(),
          atom() | binary(),
          atom() | binary(),
          binary(),
          NervesHubUserAPI.Auth.t()
        ) ::
          {:error, any()} | {:ok, any()}
  def update(org_name, product_name, username, role, %Auth{} = auth) do
    params = %{role: role}
    API.request(:put, path(org_name, product_name, username), params, auth)
  end

  @doc """
  Remove a user from the product.

  Verb: DELETE
  Path: /orgs/:org_name/product/:product_name/users/:username
  """
  @spec remove(atom() | binary(), atom() | binary(), binary(), NervesHubUserAPI.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def remove(org_name, product_name, username, %Auth{} = auth) do
    API.request(:delete, path(org_name, product_name, username), "", auth)
  end

  def path(org, product) do
    Path.join(Product.path(org, product), @path)
  end

  @doc false
  @spec path(atom() | binary(), atom() | binary()) :: binary()
  def path(org, product, username) do
    Path.join(path(org, product), username)
  end
end