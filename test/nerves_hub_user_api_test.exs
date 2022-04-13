defmodule NervesHubCoreTest do
  use NervesHubCoreTest.Case
  doctest NervesHubUserAPI

  alias NervesHubUserAPI.User

  setup :create_peer_user

  test "backwards support for user client certificate auth", %{auth: auth} do
    assert auth.cert
    assert {:ok, _} = User.me(auth)
  end
end
