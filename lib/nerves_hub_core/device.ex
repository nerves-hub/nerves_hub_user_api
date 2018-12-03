defmodule NervesHubCore.Device do
  alias NervesHubCore.{Auth, Org}

  @path "devices"

  def path(org) do
    Path.join([Org.path(org), @path])
  end

  def path(org, device) do
    Path.join([path(org), device])
  end

  def cert_path(org, device) do
    Path.join(path(org, device), "certificates")
  end

  def create(org, identifier, description, tags, %Auth{} = auth) do
    params = %{identifier: identifier, description: description, tags: tags}
    NervesHubCore.request(:post, path(org), params, auth)
  end

  def update(org, identifier, data, %Auth{} = auth) do
    params = Map.merge(data, %{identifier: identifier})
    NervesHubCore.request(:put, path(org, identifier), params, auth)
  end

  def cert_list(org, identifier, %Auth{} = auth) do
    NervesHubCore.request(:get, cert_path(org, identifier), "", auth)
  end

  def cert_create(org, identifier, %Auth{} = auth) do
    params = %{}
    NervesHubCore.request(:post, cert_path(org, identifier), params, auth)
  end

  def cert_sign(org, identifier, csr, %Auth{} = auth) do
    params = %{identifier: identifier, csr: csr}
    path = Path.join(cert_path(org, identifier), "sign")
    NervesHubCore.request(:post, path, params, auth)
  end
end
