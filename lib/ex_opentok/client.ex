defmodule ExOpentok.Client do
  use Tesla
  require Logger
  alias ExOpentok.Token
  alias ExOpentok.Exception

  plug Tesla.Middleware.Timeout, timeout: 2_000

  plug Tesla.Middleware.Retry,
    delay: 100,
    max_retries: 10,
    max_delay: 4_000,
    should_retry: fn
      {:ok, %{status: status}} when status >= 500 -> true
      {:ok, _} -> false
      {:error, _} -> true
    end

  @moduledoc """
  Wrapper for Tesla
  """

  @doc """
  HTTP Client's request with Tesla.
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
        {:ok, %{}}

      {:ok, %{status: 200, body: body}} ->
        {:ok, body |> Poison.decode!() |> handle_data_struct()}

      {:ok, %{status: 405, body: body}} ->
        {:ok, "405 Method not allowed"}

      {:ok, response} ->
        {:error, "Error #{response.status} -> ExOpentok query:\n #{inspect(response)}"}

      {:error, error} ->
        {:error, "Error #{inspect(error)} -> ExOpentok query:\n #{inspect(response)}"}
    end
  end

  def handle_response!(response) do
    case handle_response(response) do
      {:ok, output} -> output
      {:error, error} -> raise error
    end
  end

  defp handle_data_struct(data) do
    if is_list(data), do: List.first(data), else: data
  end
end
