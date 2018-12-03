defmodule NervesHubCore.Deployment do
  alias NervesHubCore.{Auth, Product}

  @path "deployments"

  def path(org, product) do
    Path.join([Product.path(org, product), @path])
  end

  def path(org, product, deployment) do
    Path.join([path(org, product), deployment])
  end

  def list(org, product, %Auth{} = auth) do
    NervesHubCore.request(:get, path(org, product), "", auth)
  end

  def create(org, product, name, firmware, version, tags, %Auth{} = auth) do
    params = %{
      name: name,
      firmware: firmware,
      conditions: %{version: version, tags: tags},
      is_active: false
    }

    NervesHubCore.request(:post, path(org, product), params, auth)
  end

  def update(org, product, deployment, params, %Auth{} = auth) do
    params = %{deployment: params}
    NervesHubCore.request(:put, path(org, product, deployment), params, auth)
  end
end
