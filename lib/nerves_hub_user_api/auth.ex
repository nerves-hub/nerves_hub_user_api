defmodule NervesHubUserAPI.Auth do
  defstruct cert: nil,
            key: nil,
            token: nil

  @type t ::
          %__MODULE__{cert: X509.Certificate.t(), key: X509.PrivateKey.t(), token: nil}
          | %__MODULE__{cert: nil, key: nil, token: <<_::40>>}

  @spec new(keyword() | map()) :: NervesHubUserAPI.Auth.t()
  def new(opts) do
    %__MODULE__{
      cert: opts[:cert],
      key: opts[:key],
      token: opts[:token]
    }
  end
end
