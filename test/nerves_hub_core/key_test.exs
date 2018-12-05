defmodule NervesHubCoreTest.KeyTest do
  use NervesHubCoreTest.Case
  doctest NervesHubCore.Key

  alias NervesHubCore.Key

  describe "create" do
    setup [:create_user]

    test "valid", %{user: user, auth: auth} do
      name = Fixtures.key_name()
      pub = Fixtures.key_pub()
      assert {:ok, _} = Key.create(user["username"], name, pub, auth)
    end
  end

  describe "list" do
    setup [:create_user, :create_key]

    test "valid", %{user: user, key: key, auth: auth} do
      assert {:ok, %{"data" => [^key]}} = Key.list(user["username"], auth)
    end
  end

  describe "delete" do
    setup [:create_user, :create_key]

    test "valid", %{user: user, key: key, auth: auth} do
      assert {:ok, _} = Key.delete(user["username"], key["name"], auth)
    end
  end
end
