defmodule NervesHubCore.Product do
  alias NervesHubCore.{Auth, Org}

  @path "products"

  def path(org) do
    Path.join([Org.path(org), @path])
  end

  def path(org, product) when is_atom(product), do: path(org, to_string(product))

  def path(org, product) do
    Path.join([path(org), product])
  end

  def list(org, %Auth{} = auth) do
    NervesHubCore.request(:get, path(org), "", auth)
  end

  def create(org, product, %Auth{} = auth) do
    params = %{name: product}
    NervesHubCore.request(:post, path(org), params, auth)
  end

  def delete(org, product, %Auth{} = auth) do
    NervesHubCore.request(:delete, path(org, product), "", auth)
  end

  def update(org, product, params, %Auth{} = auth) do
    params = %{product: params}
    NervesHubCore.request(:put, path(org, product), params, auth)
  end
end
