defmodule NervesHubCoreTest.FirmwareTest do
  use NervesHubCoreTest.Case
  doctest NervesHubCore.Firmware

  alias NervesHubCore.Firmware

  describe "create" do
    setup [:create_user, :create_key, :create_product]

    test "valid", %{user: user, product: product, auth: auth} do
      fw_path = Fixtures.firmware_path()
      assert {:ok, _} = Firmware.create(user["username"], product["name"], fw_path, auth)
    end
  end

  describe "list" do
    setup [:create_user, :create_key, :create_product, :create_firmware]

    test "valid", %{user: user, product: product, auth: auth, firmware: firmware} do
      assert {:ok, %{"data" => [^firmware]}} =
               Firmware.list(user["username"], product["name"], auth)
    end
  end

  describe "delete" do
    setup [:create_user, :create_key, :create_product, :create_firmware]

    test "valid", %{user: user, product: product, firmware: firmware, auth: auth} do
      assert {:ok, _} = Firmware.delete(user["username"], product["name"], firmware["uuid"], auth)
    end
  end
end
