defmodule ExOpentok.Client do
  use Tesla
  require Logger
  alias ExOpentok.Token
  alias ExOpentok.Exception

  plug(Tesla.Middleware.Timeout, timeout: 2_000)

  @moduledoc """
  Wrapper for HTTPotion
  """

  @doc """
  HTTP Client's request with HTTPotion.
  """
  def http_request(url, type \\ :get, body \\ nil) do
    do_http_request(url, type, body)
  end

  defp do_http_request(url, :post, body) when is_map(body) do
    post(url, Jason.encode!(body),
      headers: [
        "X-OPENTOK-AUTH": Token.jwt(),
        Accept: "application/json",
        "Content-Type": "application/json"
      ]
    )
  end

  defp do_http_request(url, type \\ :get, body \\ nil) do
    case type do
      :get ->
        get(url,
          headers: ["X-OPENTOK-AUTH": Token.jwt(), "Content-Type": "application/json"]
        )

      :post ->
        if body do
          post(url, body,
            headers: [
              "X-OPENTOK-AUTH": Token.jwt(),
              Accept: "application/json",
              "Content-Type": "application/x-www-form-urlencoded"
            ]
          )
        else
          post(url, "",
            headers: ["X-OPENTOK-AUTH": Token.jwt(), "Content-Type": "application/json"]
          )
        end

      :delete ->
        delete(url,
          headers: ["X-OPENTOK-AUTH": Token.jwt(), "Content-Type": "application/json"]
        )
    end
  end

  @doc """
  Handle response 200 and parse body to JSON.
  """
  def handle_response(response) do
    case response do
      {:ok, %{status: 200, body: ""}} ->
        %{}

      {:ok, %{status: 200, body: body}} ->
        body |> Poison.decode!() |> handle_data_struct()

      {:ok, %{status: 405, body: body}} ->
        raise "405 Method not allowed"

      {:ok, response} ->
        raise "Error #{response.status} -> ExOpentok query:\n #{inspect(response)}"

      {:error, error} ->
        raise "Error #{inspect(error)} -> ExOpentok query:\n #{inspect(response)}"
    end
  end

  defp handle_data_struct(data) do
    if is_list(data), do: List.first(data), else: data
  end
end
