defmodule NervesHubCore.Firmware do
  @moduledoc """
  Manage Firmware on NervesHub

  Path: /orgs/:org_name/products/:product_name/firmwares
  """

  alias NervesHubCore.{Auth, API, Product}

  @path "firmwares"

  @doc """
  List firmware for a product.

  Verb: GET
  Path: /orgs/:org_name/products/:product_name/firmwares
  """
  @spec list(atom() | binary(), atom() | binary(), NervesHubCore.Auth.t()) ::
          {:error, any()} | {:ok, any()}
  def list(org_name, product_name, %Auth{} = auth) do
    API.request(:get, path(org_name, product_name), "", auth)
  end

  @doc """
  Add signed firmware NervesHub.

  Verb: POST
  Path: /orgs/:org_name/products/:product_name/firmwares
  """
  @spec create(
          atom() | binary(),
          atom() | binary(),
          atom() | binary(),
          non_neg_integer() | nil,
          NervesHubCore.Auth.t()
        ) :: {:error, any()} | {:ok, any()}
  def create(org_name, product_name, tar, ttl \\ nil, %Auth{} = auth) do
    params = if ttl != nil, do: %{ttl: ttl}, else: %{}
    API.file_request(:post, path(org_name, product_name), tar, params, %Auth{} = auth)
  end

  @doc """
  Delete existing firmware by uuid.

  Verb: DELETE
  Path: /orgs/:org_name/products/:product_name/firmwares/:uuid
  """
  @spec delete(
          atom() | binary(),
          atom() | binary(),
          binary(),
          NervesHubCore.Auth.t()
        ) :: {:error, any()} | {:ok, any()}
  def delete(org_name, product_name, uuid, %Auth{} = auth) do
    path = Path.join(path(org_name, product_name), uuid)
    API.request(:delete, path, "", auth)
  end

  @doc false
  @spec path(atom() | binary(), atom() | binary()) :: binary()
  def path(org_name, product_name) do
    Path.join(Product.path(org_name, product_name), @path)
  end
end
