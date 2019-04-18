defmodule NervesHubCoreTest.OrgUserTest do
  use NervesHubCoreTest.Case
  doctest NervesHubUserAPI.OrgUser

  alias NervesHubUserAPI.OrgUser

  describe "add" do
    setup [:create_users]

    test "valid", %{user: user, user2: user2, auth: auth} do
      assert {:ok, _} = OrgUser.add(user["username"], user2["username"], :read, auth)
    end
  end

  describe "update" do
    setup [:create_users]

    test "valid", %{user: user, user2: user2, auth: auth} do
      {:ok, _} = OrgUser.add(user["username"], user2["username"], :read, auth)
      assert {:ok, _} = OrgUser.update(user["username"], user2["username"], :write, auth)
    end
  end

  describe "list" do
    setup [:create_user]

    test "valid", %{user: user, auth: auth} do
      assert {:ok, %{"data" => [user]}} = OrgUser.list(user["username"], auth)
      assert user["email"] == user["email"]
      assert user["username"] == user["username"]
      assert user["role"] == "admin"
    end
  end

  describe "remove" do
    setup [:create_users]

    test "valid", %{user: user, user2: user2, auth: auth} do
      {:ok, _} = OrgUser.add(user["username"], user2["username"], :read, auth)
      assert {:ok, _} = OrgUser.remove(user["username"], user2["username"], auth)
    end
  end
end
