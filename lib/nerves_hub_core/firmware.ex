defmodule NervesHubCore.Firmware do
  alias NervesHubCore.{Auth, Product}

  @path "firmwares"

  def path(org, product) do
    Path.join([Product.path(org, product), @path])
  end

  def list(org, product, %Auth{} = auth) do
    NervesHubCore.request(:get, path(org, product), "", auth)
  end

  def create(org, product, tar, ttl, %Auth{} = auth) do
    params = %{ttl: ttl}
    NervesHubCore.file_request(:post, path(org, product), tar, params, %Auth{} = auth)
  end

  def delete(org, product, uuid, %Auth{} = auth) do
    path = Path.join(path(org, product), uuid)
    NervesHubCore.request(:delete, path, "", auth)
  end
end
