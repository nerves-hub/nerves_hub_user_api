defmodule NervesHubCore.CACertificate do
  alias NervesHubCore.{Auth, Org}

  @path "ca_certificates"

  def path(org) do
    Path.join([Org.path(org), @path])
  end

  def path(org, serial) do
    Path.join([path(org), serial])
  end

  def list(org, %Auth{} = auth) do
    NervesHubCore.request(:get, path(org), "", auth)
  end

  def create(org, cert_pem, auth) do
    params = %{cert: Base.encode64(cert_pem)}
    NervesHubCore.request(:post, path(org), params, auth)
  end

  def delete(org, serial, auth) do
    NervesHubCore.request(:delete, path(org, serial), "", auth)
  end
end
