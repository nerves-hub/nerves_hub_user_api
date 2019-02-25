defmodule NervesHubCoreTest.Case do
  use ExUnit.CaseTemplate

  alias NervesHubCoreTest.Fixtures

  using do
    quote do
      import unquote(__MODULE__)
      alias NervesHubCoreTest.{Case, Fixtures}
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(NervesHubWebCore.Repo)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(NervesHubCA.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(NervesHubWebCore.Repo, {:shared, self()})
      Ecto.Adapters.SQL.Sandbox.mode(NervesHubCA.Repo, {:shared, self()})
    end

    :ok
  end

  def create_user(context) do
    user = Fixtures.user()

    key = X509.PrivateKey.new_ec(:secp256r1)
    csr = X509.CSR.new(key, "/O=#{Fixtures.user_name()}")
    csr_pem = X509.CSR.to_pem(csr)
    csr64 = Base.encode64(csr_pem)

    {:ok, %{"data" => %{"cert" => cert}}} =
      NervesHubUserAPI.User.sign(Fixtures.user_email(), Fixtures.user_password(), csr64, "test")

    recycle_pool()

    auth = NervesHubUserAPI.Auth.new(key: key, cert: X509.Certificate.from_pem!(cert))
    {:ok, Map.merge(context, %{user: user, auth: auth})}
  end

  def create_key(%{auth: auth} = context) do
    {:ok, Map.merge(context, %{key: Fixtures.key(auth)})}
  end

  def create_product(%{auth: auth} = context) do
    {:ok, Map.merge(context, %{product: Fixtures.product(auth)})}
  end

  def create_firmware(%{auth: auth} = context) do
    {:ok, Map.merge(context, %{firmware: Fixtures.firmware(auth)})}
  end

  def create_device(%{auth: auth} = context) do
    device = Fixtures.device(auth)
    device_identifier = device["identifier"]
    key = X509.PrivateKey.new_ec(:secp256r1)

    csr = X509.CSR.new(key, "/O=#{device_identifier}")
    csr_pem = X509.CSR.to_pem(csr)
    csr64 = Base.encode64(csr_pem)

    {:ok, %{"data" => resp}} =
      NervesHubUserAPI.Device.cert_sign(context.user["username"], device_identifier, csr64, auth)

    {:ok, Map.merge(context, %{device: device, device_cert: resp["cert"]})}
  end

  def create_deployment(%{firmware: firmware, auth: auth} = context) do
    params = %{firmware_uuid: firmware["uuid"]}
    {:ok, Map.merge(context, %{deployment: Fixtures.deployment(auth, params)})}
  end

  def create_ca_certificate(%{auth: auth} = context) do
    {:ok, Map.merge(context, %{ca_certificate: Fixtures.ca_certificate(auth)})}
  end

  defp recycle_pool do
    pool_name = :nerves_hub_user_api
    :hackney_pool.stop_pool(pool_name)
    opts = [timeout: 5_000, max_connections: 5]
    :ok = :hackney_pool.start_pool(pool_name, opts)
  end
end
