defmodule NervesHubCoreTest.DeviceTest do
  use NervesHubCoreTest.Case
  doctest NervesHubCore.Device

  alias NervesHubCore.Device

  describe "create" do
    setup [:create_user]

    test "valid", %{user: user, auth: auth} do
      identifier = Fixtures.device_identifier()
      description = Fixtures.device_description()
      tags = Fixtures.device_tags()
      assert {:ok, _} = Device.create(user["username"], identifier, description, tags, auth)
    end
  end

  describe "update" do
    setup [:create_user, :create_device]

    # Validation needs to return more information about the device.
    test "valid", %{user: user, device: device, auth: auth} do
      params = %{device_identifier: "device-5678"}

      assert {:ok, %{"data" => device}} =
               Device.update(user["username"], device["identifier"], params, auth)
    end
  end

  describe "list" do
    setup [:create_user, :create_device]

    # Validation needs to return more information about the device.
    test "valid", %{user: user, device: device, auth: auth} do
      assert {:ok, %{"data" => [^device]}} = Device.list(user["username"], auth)
    end
  end

  describe "cert sign" do
    setup [:create_user, :create_device]

    test "valid", %{user: user, device: device, auth: auth} do
      device_identifier = device["identifier"]
      key = X509.PrivateKey.new_ec(:secp256r1)

      csr = X509.CSR.new(key, "/O=#{device_identifier}")
      csr_pem = X509.CSR.to_pem(csr)
      csr64 = Base.encode64(csr_pem)

      assert {:ok, %{"data" => _cert}} =
               Device.cert_sign(user["username"], device_identifier, csr64, auth)
    end
  end

  describe "cert list" do
    setup [:create_user, :create_device]

    test "valid", %{user: user, device: device, device_cert: device_cert, auth: auth} do
      serial =
        device_cert
        |> X509.Certificate.from_pem!()
        |> X509.Certificate.serial()
        |> to_string()

      assert {:ok, %{"data" => [%{"serial" => ^serial}]}} =
               Device.cert_list(user["username"], device["identifier"], auth)
    end
  end
end
