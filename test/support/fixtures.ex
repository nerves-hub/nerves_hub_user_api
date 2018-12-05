defmodule NervesHubCoreTest.Fixtures do
  @user_name "test"
  @email "test@test.com"
  @password "test1234"

  @key_name "test"
  @key_pub Path.expand("../fixtures/fwup-key.pub", __DIR__) |> File.read!()
  @key_priv Path.expand("../fixtures/fwup-key.priv", __DIR__) |> File.read!()

  @product_name "test"

  @firmware_path Path.expand("../fixtures/test-signed.fw", __DIR__)

  @device_identifier "device-1234"
  @device_tags ["test", "beta"]
  @device_description "test device"

  @deployment_name "test"
  @deployment_tags ["test"]
  @deployment_version "1.0.0"

  alias NervesHubCore.{User, Key, Product, Firmware, Device, Deployment, CACertificate}

  def user_name, do: @user_name
  def user_email, do: @email
  def user_password, do: @password

  def user(params \\ []) do
    username = params[:username] || user_name()
    email = params[:email] || user_email()
    password = params[:password] || user_password()
    {:ok, %{"data" => user}} = User.register(username, email, password)
    user
  end

  def key_name, do: @key_name
  def key_pub, do: @key_pub
  def key_priv, do: @key_priv

  def key(auth, params \\ []) do
    org_name = params[:org_name] || user_name()
    name = params[:name] || key_name()
    pub = params[:key] || key_pub()
    {:ok, %{"data" => key}} = Key.create(org_name, name, pub, auth)
    key
  end

  def product_name, do: @product_name

  def product(auth, params \\ []) do
    org_name = params[:org_name] || user_name()
    name = params[:name] || product_name()
    {:ok, %{"data" => product}} = Product.create(org_name, name, auth)
    product
  end

  def firmware_path, do: @firmware_path

  def firmware(auth, params \\ []) do
    org_name = params[:org_name] || user_name()
    product_name = params[:product_name] || product_name()
    firmware_path = params[:firmware_path] || firmware_path()
    {:ok, %{"data" => firmware}} = Firmware.create(org_name, product_name, firmware_path, auth)
    firmware
  end

  def device_identifier, do: @device_identifier
  def device_tags, do: @device_tags
  def device_description, do: @device_description

  def device(auth, params \\ []) do
    org_name = params[:org_name] || user_name()
    identifier = params[:identifier] || device_identifier()
    description = params[:description] || device_description()
    tags = params[:tags] || device_tags()
    {:ok, %{"data" => device}} = Device.create(org_name, identifier, description, tags, auth)
    device
  end

  def deployment_name, do: @deployment_name
  def deployment_tags, do: @deployment_tags
  def deployment_version, do: @deployment_version

  def deployment(auth, params \\ []) do
    org_name = params[:org_name] || user_name()
    product_name = params[:product_name] || product_name()
    firmware_uuid = params[:firmware_uuid]
    name = params[:name] || deployment_name()
    tags = params[:tags] || deployment_tags()
    version = params[:version] || deployment_version()

    {:ok, %{"data" => deployment}} =
      Deployment.create(org_name, product_name, name, firmware_uuid, version, tags, auth)

    deployment
  end

  def ca_certificate(auth, params \\ []) do
    org_name = params[:org_name] || user_name()
    key = X509.PrivateKey.new_ec(:secp256r1)
    cert = X509.Certificate.self_signed(key, "CN=My CA", template: :root_ca)
    cert_pem = X509.Certificate.to_pem(cert)

    {:ok, %{"data" => ca_certificate}} = CACertificate.create(org_name, cert_pem, auth)
    ca_certificate
  end
end
