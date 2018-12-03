defmodule NervesHubCore.User do
  alias NervesHubCore.Auth

  # Certificate protected

  def me(%Auth{} = auth) do
    NervesHubCore.request(:get, "users/me", "", auth)
  end

  # Username / Password protected endpoints

  def register(username, email, password) do
    params = %{username: username, email: email, password: password}
    NervesHubCore.request(:post, "users/register", params)
  end

  def auth(email, password) do
    params = %{email: email, password: password}
    NervesHubCore.request(:post, "users/auth", params)
  end

  def sign(email, password, csr, description) do
    params = %{email: email, password: password, csr: csr, description: description}
    NervesHubCore.request(:post, "users/sign", params)
  end
end
