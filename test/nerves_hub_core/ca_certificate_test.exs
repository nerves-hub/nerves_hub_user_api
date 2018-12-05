defmodule NervesHubCoreTest.CACertificateTest do
  use NervesHubCoreTest.Case
  doctest NervesHubCore.CACertificate

  alias NervesHubCore.CACertificate

  describe "create" do
    setup [:create_user]

    test "valid", %{user: user, auth: auth} do
      key = X509.PrivateKey.new_ec(:secp256r1)
      cert = X509.Certificate.self_signed(key, "CN=My CA", template: :root_ca)
      cert_pem = X509.Certificate.to_pem(cert)

      assert {:ok, _} = CACertificate.create(user["username"], cert_pem, auth)
    end
  end

  describe "list" do
    setup [:create_user, :create_ca_certificate]

    test "valid", %{user: user, auth: auth, ca_certificate: ca_certificate} do
      assert {:ok, %{"data" => [^ca_certificate]}} = CACertificate.list(user["username"], auth)
    end
  end

  describe "delete" do
    setup [:create_user, :create_ca_certificate]

    test "valid", %{user: user, auth: auth, ca_certificate: ca_certificate} do
      assert {:ok, _} = CACertificate.delete(user["username"], ca_certificate["serial"], auth)
    end
  end
end
