defmodule NervesHubUserAPI.API do
  @moduledoc false

  @file_chunk 4096
  @progress_steps 50

  use Tesla
  adapter(Tesla.Adapter.Hackney, pool: :nerves_hub_user_api)
  if Mix.env() == :dev, do: plug(Tesla.Middleware.Logger)
  plug(Tesla.Middleware.FollowRedirects, max_redirects: 5)
  plug(Tesla.Middleware.JSON)

  alias X509.Certificate

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
    client()
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

    client()
    |> request(method: verb, url: URI.encode(path), body: mp, opts: [adapter: opts(auth)])
    |> resp()
  end

  defp resp({:ok, %{status: status_code, body: body}})
       when status_code >= 200 and status_code < 300,
       do: {:ok, body}

  defp resp({:ok, %{body: body}}), do: {:error, body}

  defp resp({:error, _reason} = err), do: err

  defp client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, endpoint()}
    ]

    Tesla.client(middleware)
  end

  defp opts(auth) do
    ssl_options =
      auth
      |> ssl_options()
      |> Keyword.put(:cacerts, ca_certs())

    [
      ssl_options: ssl_options,
      recv_timeout: 60_000
    ]
  end

  defp ssl_options(%{key: key, cert: cert}) do
    [
      verify: :verify_peer,
      server_name_indication: server_name_indication(),
      key: {:ECPrivateKey, X509.PrivateKey.to_der(key)},
      cert: X509.Certificate.to_der(cert)
    ]
  end

  defp ssl_options(_), do: []

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
      "\r|#{String.duplicate("=", completed)}#{String.duplicate(" ", unfilled)}| #{percent}% (#{
        bytes_to_mb(size)
      } / #{bytes_to_mb(max)}) MB"
    )
  end

  defp bytes_to_mb(bytes) do
    trunc(bytes / 1024 / 1024)
  end

  defp progress?() do
    System.get_env("NERVES_LOG_DISABLE_PROGRESS_BAR") == nil
  end

  defp ca_certs() do
    ca_cert_path =
      Application.get_env(:nerves_hub_user_api, :ca_certs) ||
        System.get_env("NERVES_HUB_CA_CERTS") ||
        :code.priv_dir(:nerves_hub_user_api)
        |> to_string()
        |> Path.join("ca_certs")

    ca_cert_path
    |> File.ls!()
    |> Enum.map(&File.read!(Path.join(ca_cert_path, &1)))
    |> Enum.map(&Certificate.from_pem!/1)
    |> Enum.map(&Certificate.to_der/1)
  end

  defp get_env_as_integer(str) do
    case System.get_env(str) do
      nil -> nil
      value -> String.to_integer(value)
    end
  end
end
