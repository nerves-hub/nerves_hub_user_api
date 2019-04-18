defmodule NervesHubCoreTest.ProductUserTest do
  use NervesHubCoreTest.Case
  doctest NervesHubUserAPI.ProductUser

  alias NervesHubUserAPI.ProductUser

  describe "add" do
    setup [:create_users, :create_product]

    test "valid", %{user: user, user2: user2, product: product, auth: auth} do
      assert {:ok, _} =
               ProductUser.add(user["username"], product["name"], user2["username"], :read, auth)
    end
  end

  describe "update" do
    setup [:create_users, :create_product]

    test "valid", %{user: user, user2: user2, product: product, auth: auth} do
      {:ok, _} =
        ProductUser.add(user["username"], product["name"], user2["username"], :read, auth)

      assert {:ok, _} =
               ProductUser.update(
                 user["username"],
                 product["name"],
                 user2["username"],
                 :write,
                 auth
               )
    end
  end

  describe "list" do
    setup [:create_user, :create_product]

    test "valid", %{user: user, product: product, auth: auth} do
      assert {:ok, %{"data" => [user]}} =
               ProductUser.list(user["username"], product["name"], auth)

      assert user["email"] == user["email"]
      assert user["username"] == user["username"]
      assert user["role"] == "admin"
    end
  end

  describe "remove" do
    setup [:create_users, :create_product]

    test "valid", %{user: user, user2: user2, product: product, auth: auth} do
      {:ok, _} =
        ProductUser.add(user["username"], product["name"], user2["username"], :read, auth)

      assert {:ok, _} =
               ProductUser.remove(user["username"], product["name"], user2["username"], auth)
    end
  end
end
