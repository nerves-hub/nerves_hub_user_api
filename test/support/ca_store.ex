defmodule NervesHubCoreTest.CAStore do
  alias X509.Certificate

  def ca_certs do
    ca_cert_path = File.cwd!() |> Path.join("test/tmp/ssl")

    ca_cert_path
    |> File.ls!()
    |> Enum.map(&File.read!(Path.join(ca_cert_path, &1)))
    |> Enum.reduce([], fn bin, acc ->
      case Certificate.from_pem(bin) do
        {:ok, cert} -> [cert | acc]
        {:error, _} -> acc
      end
    end)
    |> Enum.map(&Certificate.to_der/1)
  end
end
