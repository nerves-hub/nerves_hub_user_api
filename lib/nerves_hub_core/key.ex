defmodule NervesHubCore.Key do
  alias NervesHubCore.{Auth, Org}

  @path "keys"

  def path(org) do
    Path.join([Org.path(org), @path])
  end

  def path(org, key) do
    Path.join([path(org), key])
  end

  def list(org, %Auth{} = auth) do
    NervesHubCore.request(:get, path(org), "", auth)
  end

  def create(org, name, key, %Auth{} = auth) do
    params = %{name: name, key: key}
    NervesHubCore.request(:post, path(org), params, auth)
  end

  def delete(org, name, %Auth{} = auth) do
    NervesHubCore.request(:delete, path(org, name), "", auth)
  end
end
