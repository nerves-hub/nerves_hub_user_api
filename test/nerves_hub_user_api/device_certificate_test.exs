defmodule NervesHubCoreTest.DeviceCertificateTest do
  use NervesHubCoreTest.Case
  doctest NervesHubUserAPI.DeviceCertificate

  alias NervesHubUserAPI.DeviceCertificate

  describe "sign" do
    setup [:create_user, :create_product, :create_device]

    test "valid", %{user: user, product: product, device: device, auth: auth} do
      device_identifier = device["identifier"]
      key = X509.PrivateKey.new_ec(:secp256r1)

      csr = X509.CSR.new(key, "/O=#{device_identifier}")
      csr_pem = X509.CSR.to_pem(csr)
      csr64 = Base.encode64(csr_pem)

      assert {:ok, %{"data" => _cert}} =
               DeviceCertificate.sign(
                 user["username"],
                 product["name"],
                 device_identifier,
                 csr64,
                 auth
               )
    end
  end

  describe "list" do
    setup [:create_user, :create_product, :create_device]

    test "valid", %{
      user: user,
      product: product,
      device: device,
      device_cert: device_cert,
      auth: auth
    } do
      serial =
        device_cert
        |> X509.Certificate.from_pem!()
        |> X509.Certificate.serial()
        |> to_string()

      assert {:ok, %{"data" => [%{"serial" => ^serial}]}} =
               DeviceCertificate.list(
                 user["username"],
                 product["name"],
                 device["identifier"],
                 auth
               )
    end
  end

  describe "create" do
    setup [:create_user, :create_product, :create_device]

    test "valid", %{
      user: user,
      product: product,
      device: device,
      auth: auth
    } do
      key = X509.PrivateKey.new_ec(:secp256r1)
      cert = X509.Certificate.self_signed(key, "CN=My Device", template: :root_ca)
      cert_pem = X509.Certificate.to_pem(cert)

      assert {:ok, _} =
               DeviceCertificate.create(
                 user["username"],
                 product["name"],
                 device["identifier"],
                 cert_pem,
                 auth
               )
    end
  end

  describe "delete" do
    setup [:create_user, :create_product, :create_device]

    test "valid", %{
      user: user,
      auth: auth,
      product: product,
      device: device,
      device_cert: device_cert
    } do
      serial = X509.Certificate.from_pem!(device_cert) |> X509.Certificate.serial() |> to_string()

      assert {:ok, _} =
               DeviceCertificate.delete(
                 user["username"],
                 product["name"],
                 device["identifier"],
                 serial,
                 auth
               )
    end
  end
end
