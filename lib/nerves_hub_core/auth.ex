defmodule NervesHubCore.Auth do
  defstruct cert: nil,
            key: nil

  @type t :: %__MODULE__{
          cert: X509.Certificate.t(),
          key: X509.PrivateKey.t()
        }
end
