defmodule NervesHubCoreTest.UserTest do
  use NervesHubCoreTest.Case
  doctest NervesHubUserAPI.User

  alias NervesHubUserAPI.User

  describe "register" do
    test "valid" do
      assert {:ok, _} = User.register("test", "test@test.com", "test1234")
    end

    test "invalid password" do
      assert {:error, _} = User.register("test", "test@test.com", "")
    end
  end

  describe "auth" do
    setup [:create_user]

    test "valid" do
      assert {:ok, _} = User.auth(Fixtures.user_email(), Fixtures.user_password())
    end
  end

  describe "sign" do
    setup [:create_user]

    test "valid" do
      key = X509.PrivateKey.new_ec(:secp256r1)

      csr = X509.CSR.new(key, "/O=#{Fixtures.user_name()}")
      csr_pem = X509.CSR.to_pem(csr)
      csr64 = Base.encode64(csr_pem)

      assert {:ok, _} =
               User.sign(
                 Fixtures.user_email(),
                 Fixtures.user_password(),
                 csr64,
                 "My description"
               )
    end
  end

  describe "me" do
    setup [:create_user]

    test "valid", %{auth: auth} do
      assert {:ok, _} = User.me(auth)
    end
  end
end
