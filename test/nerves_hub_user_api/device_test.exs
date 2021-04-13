defmodule NervesHubCoreTest.DeviceTest do
  use NervesHubCoreTest.Case
  doctest NervesHubUserAPI.Device

  alias NervesHubUserAPI.Device

  describe "create" do
    setup [:create_user, :create_product]

    test "valid", %{user: user, product: product, auth: auth} do
      identifier = Fixtures.device_identifier()
      description = Fixtures.device_description()
      tags = Fixtures.device_tags()

      assert {:ok, _} =
               Device.create(
                 user["username"],
                 product["name"],
                 identifier,
                 description,
                 tags,
                 auth
               )
    end
  end

  describe "update" do
    setup [:create_user, :create_product, :create_device]

    # Validation needs to return more information about the device.
    test "valid", %{user: user, product: product, device: device, auth: auth} do
      params = %{device_identifier: "device-5678"}

      assert {:ok, %{"data" => _device}} =
               Device.update(
                 user["username"],
                 product["name"],
                 device["identifier"],
                 params,
                 auth
               )
    end
  end

  describe "delete" do
    setup [:create_user, :create_product, :create_device]

    test "valid", %{user: user, product: product, device: device, auth: auth} do
      assert {:ok, _} =
               Device.delete(user["username"], product["name"], device["identifier"], auth)
    end
  end

  describe "list" do
    setup [:create_user, :create_product, :create_device]

    # Validation needs to return more information about the device.
    test "valid", %{user: user, product: product, device: device, auth: auth} do
      assert {:ok, %{"data" => [^device]}} = Device.list(user["username"], product["name"], auth)
    end
  end
end
