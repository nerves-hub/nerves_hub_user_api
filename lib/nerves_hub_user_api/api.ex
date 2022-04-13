defmodule NervesHubUserAPI.API do
  @moduledoc false
  require Logger

  @file_chunk 4096
  @progress_steps 50

  use Tesla
  adapter(Tesla.Adapter.Hackney, pool: :nerves_hub_user_api)
  if Mix.env() == :dev, do: plug(Tesla.Middleware.Logger)
  plug(Tesla.Middleware.FollowRedirects, max_redirects: 5)
  plug(Tesla.Middleware.JSON)

  @doc """
  Return the URL that's used for connecting to NervesHub
  """
  @spec endpoint() :: String.t()
  def endpoint() do
    opts = Application.get_all_env(:nerves_hub_user_api)
    host = System.get_env("NERVES_HUB_HOST") || opts[:host]
    port = get_env_as_integer("NERVES_HUB_PORT") || opts[:port]

    %URI{scheme: "https", host: host, port: port, path: "/"} |> URI.to_string()
  end

  def request(:get, path, params) when is_map(params) do
    client()
    |> request(
      method: :get,
      url: URI.encode(path),
      query: Map.to_list(params),
      opts: [adapter: opts(%{})]
    )
    |> resp()
  end

  def request(verb, path, params, auth \\ %{}) do
    client(auth)
    |> request(method: verb, url: URI.encode(path), body: params, opts: [adapter: opts(auth)])
    |> resp()
  end

  def file_request(verb, path, file, params, auth) do
    content_length = :filelib.file_size(file)
    {:ok, pid} = Agent.start_link(fn -> 0 end)

    stream =
      file
      |> File.stream!([], @file_chunk)
      |> Stream.each(fn chunk ->
        Agent.update(pid, fn sent ->
          size = sent + byte_size(chunk)
          if progress?(), do: put_progress(size, content_length)
          size
        end)
      end)

    mp =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_file_content(stream, Path.basename(file), name: "firmware")
      |> (fn mp ->
            Enum.reduce(params, mp, fn {k, v}, mp ->
              Tesla.Multipart.add_field(mp, to_string(k), to_string(v))
            end)
          end).()

    client(auth)
    |> request(method: verb, url: URI.encode(path), body: mp, opts: [adapter: opts(auth)])
    |> resp()
  end

  defp resp({:ok, %{status: status_code, body: body}})
       when status_code >= 200 and status_code < 300,
       do: {:ok, body}

  defp resp({:ok, %{body: body}}), do: {:error, body}

  defp resp({:error, _reason} = err), do: err

  defp client(auth \\ %{}) do
    middleware = [
      {Tesla.Middleware.BaseUrl, endpoint()},
      {Tesla.Middleware.Headers, headers(auth)}
    ]

    Tesla.client(middleware)
  end

  defp headers(%{token: "nh" <> _ = token}) do
    [{"Authorization", "token #{token}"}]
  end

  defp headers(_), do: []

  defp opts(auth) do
    ssl_options =
      [
        verify: :verify_peer,
        server_name_indication: server_name_indication(),
        cacerts: ca_certs()
      ] ++ peer_options(auth)

    [
      ssl_options: ssl_options,
      recv_timeout: 60_000
    ]
  end

  defp peer_options(%{key: key, cert: cert, token: nil}) do
    Logger.warn("""
    User client certificate authentication is being deprecated.

    Please use a generated access token from:

      #{endpoint()}{username}/tokens

    Or if you are using NervesHubCLI, you can generate a token with:

      mix nerves_hub.user auth
    """)

    [
      key: {:ECPrivateKey, X509.PrivateKey.to_der(key)},
      cert: X509.Certificate.to_der(cert)
    ]
  end

  defp peer_options(_), do: []

  defp server_name_indication do
    Application.get_env(:nerves_hub_user_api, :server_name_indication) ||
      Application.get_env(:nerves_hub_user_api, :host) |> to_charlist()
  end

  def put_progress(size, max) do
    fraction = size / max
    completed = trunc(fraction * @progress_steps)
    percent = trunc(fraction * 100)
    unfilled = @progress_steps - completed

    IO.write(
      :stderr,
      "\r|#{String.duplicate("=", completed)}#{String.duplicate(" ", unfilled)}| #{percent}% (#{bytes_to_mb(size)} / #{bytes_to_mb(max)}) MB"
    )
  end

  defp bytes_to_mb(bytes) do
    trunc(bytes / 1024 / 1024)
  end

  defp progress?() do
    System.get_env("NERVES_LOG_DISABLE_PROGRESS_BAR") == nil
  end

  # TODO: remove this in a later version
  if System.get_env("NERVES_HUB_CA_CERTS") || Application.get_env(:nerves_hub_link, :ca_certs) do
    raise("""
    Specifying `NERVES_HUB_CA_CERTS` environment variable or `config :nerves_hub_user_api, ca_certs: path`
    that is compiled into the module is no longer supported.

    If you are connecting to the public https://nerves-hub.org instance, simply remove env or config variable
    and the certificates from NervesHubCAStore will be used by default.

    If you are connecting to your own instance with custom CA certificates, use the `:ca_store` config
    option to specify a module with a `ca_certs/0` function that returns a list
    of DER encoded certificates:

      config :nerves_hub_user_api, ca_store: MyModule

    If you have the certificates in DER format, you can also explicitly set them in the `:ssl` option:

      config :nerves_hub_user_api, ssl: [cacerts: my_der_list]
    """)
  end

  @doc "Returns a list of der encoded CA certs"
  @spec ca_certs() :: [binary()]
  def ca_certs do
    ssl = Application.get_env(:nerves_hub_user_api, :ssl, [])
    ca_store = Application.get_env(:nerves_hub_user_api, :ca_store, NervesHubCAStore)

    cond do
      # prefer explicit SSL setting if available
      is_list(ssl[:cacerts]) ->
        ssl[:cacerts]

      is_atom(ca_store) ->
        ca_store.ca_certs()

      true ->
        Logger.warn(
          "[NervesHubLink] No CA store or :cacerts have been specified. Request will fail"
        )

        []
    end
  end

  defp get_env_as_integer(str) do
    case System.get_env(str) do
      nil -> nil
      value -> String.to_integer(value)
    end
  end
end
