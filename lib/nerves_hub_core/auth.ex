defmodule NervesHubCore.Auth do
  defstruct cert: nil,
            key: nil

  @type t :: %__MODULE__{
          cert: X509.Certificate.t(),
          key: X509.PrivateKey.t()
        }

  @spec new(keyword() | map()) :: NervesHubCore.Auth.t()
  def new(opts) do
    %__MODULE__{
      cert: opts[:cert],
      key: opts[:key]
    }
  end
end
