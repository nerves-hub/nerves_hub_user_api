defmodule NervesHubCoreTest.ProductTest do
  use NervesHubCoreTest.Case
  doctest NervesHubCore.Product

  alias NervesHubCore.Product

  describe "create" do
    setup [:create_user]

    test "valid", %{user: user, auth: auth} do
      name = Fixtures.product_name()
      assert {:ok, _} = Product.create(user["username"], name, auth)
    end
  end

  describe "list" do
    setup [:create_user, :create_product]

    test "valid", %{user: user, product: product, auth: auth} do
      assert {:ok, %{"data" => [^product]}} = Product.list(user["username"], auth)
    end
  end

  describe "delete" do
    setup [:create_user, :create_product]

    test "valid", %{user: user, product: product, auth: auth} do
      assert {:ok, _} = Product.delete(user["username"], product["name"], auth)
    end
  end

  describe "update" do
    setup [:create_user, :create_product]

    test "valid", %{user: user, product: product, auth: auth} do
      assert {:ok, %{"data" => product}} =
               Product.update(user["username"], product["name"], %{name: "new_name"}, auth)

      assert {:ok, %{"data" => [^product]}} = Product.list(user["username"], auth)
    end
  end
end
