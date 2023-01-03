defmodule ExOpentok.Token do
  @moduledoc """
  ExOpentok Token ToolBox
  """

  @default_algos ["HS256"]
  @role_publisher "publisher"
  @token_prefix "T1=="

  @doc """
  Generate unique token to access session.
  """
  def generate(session_id), do: generate(session_id, "publisher")

  def generate(session_id, role, connection_data \\ nil)
      when role in ["subscriber", "publisher", "moderator"] do
    do_generate(session_id, role, connection_data)
  end

  defp do_generate(session_id, role, connection_data) do
    session_id
    |> data_content(role)
    |> add_connection_data(connection_data)
    |> token_process(session_id)
  end

  defp data_content(session_id, role) do
    "session_id=#{session_id}&create_time=#{:os.system_time(:seconds)}&role=#{role}&nonce=#{nonce()}"
  end

  defp add_connection_data(params, nil) do
    params
  end

  defp add_connection_data(params, data) when is_binary(data) do
    if String.length(data) < 1000 do
      params <> "&connection_data=#{data}"
    else
      raise "Connection data must be less than 1000 characters"
    end
  end

  defp token_process(data_content, session_id) do
    data_content
    |> sign_string(ExOpentok.config(:secret))
    |> token(data_content)
  end

  defp token(signature, data_string) do
    @token_prefix <>
      Base.encode64("partner_id=#{ExOpentok.config(:key)}&sig=#{signature}:#{data_string}")
  end

  defp nonce, do: Base.encode16(:crypto.strong_rand_bytes(16))

  @doc """
  Generate JWT to access ExOpentok API services.
  """
  @spec jwt() :: String.t()
  def jwt do
    import Joken

    data_from_config()
    |> token()
    |> with_signer(hs256(ExOpentok.config(:secret)))
    |> sign()
    |> get_compact()
  end

  defp data_from_config do
    %{
      iss: ExOpentok.config(:key),
      iat: :os.system_time(:seconds),
      exp: :os.system_time(:seconds) + 300,
      ist: ExOpentok.config(:iss),
      jti: UUID.uuid4()
    }
  end

  @spec sign_string(String.t(), String.t()) :: String.t()
  defp sign_string(string, secret) do
    :crypto.mac(:hmac, :sha, secret, string)
    |> Base.encode16()
  end
end
