defmodule NervesHubCoreTest.DeploymentTest do
  use NervesHubCoreTest.Case
  doctest NervesHubUserAPI.Deployment

  alias NervesHubUserAPI.Deployment

  describe "create" do
    setup [:create_user, :create_key, :create_product, :create_firmware]

    test "valid", %{user: user, auth: auth, product: product, firmware: firmware} do
      assert {:ok, _} =
               Deployment.create(
                 user["username"],
                 product["name"],
                 "test deployment",
                 firmware["uuid"],
                 "",
                 ["test"],
                 auth
               )
    end
  end

  describe "list" do
    setup [:create_user, :create_key, :create_product, :create_firmware, :create_deployment]

    test "valid", %{user: user, auth: auth, product: product, deployment: deployment} do
      assert {:ok, %{"data" => [^deployment]}} =
               Deployment.list(user["username"], product["name"], auth)
    end
  end

  describe "update" do
    setup [:create_user, :create_key, :create_product, :create_firmware, :create_deployment]

    test "valid", %{user: user, auth: auth, product: product, deployment: deployment} do
      assert {:ok, %{"data" => deployment}} =
               Deployment.update(
                 user["username"],
                 product["name"],
                 deployment["name"],
                 %{is_active: true},
                 auth
               )

      assert {:ok, %{"data" => [^deployment]}} =
               Deployment.list(user["username"], product["name"], auth)
    end
  end
end
