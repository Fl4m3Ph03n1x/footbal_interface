defmodule FootbalInterface.Web.Controllers.Search do
  @moduledoc """
  """

  alias FootbalEngine.QuickSearch
  alias FootbalInterface.Formatter
  alias Plug.Conn
  alias Plug.Conn.Status

  @spec process(Conn.t) :: Conn.t
  def process(%Conn{} = conn) do
    all_params =
      conn
      |> Conn.fetch_query_params()
      |> Map.get(:query_params)

    query_format = Map.get(all_params, "format", "json")
    query_params = Map.delete(all_params, "format")

    with  {:ok, db_query} <- parse(query_params),
          {:ok, results}  <- QuickSearch.search(db_query),
          {:ok, answer}   <- Formatter.format(results, query_format)
    do
      Conn.send_resp(conn, Status.code(:ok), answer)
    else
      {:error, :empty_query} ->
        Conn.send_resp(conn, Status.code(:bad_request), "Empty Query")

      {:error, :invalid_headers, fails} ->
        Conn.send_resp(conn, Status.code(:bad_request), "Invalid Headers: #{inspect fails}")

      {:error, :json_encoding_failed, err} ->
        Conn.send_resp(conn, Status.code(:unprocessable_entity), "Failed to JSON enconde query results: #{inspect err}")

      {:error, :protobuff_encoding_failed, err} ->
        Conn.send_resp(conn, Status.code(:unprocessable_entity), "Failed to Protobuff enconde query results: #{inspect err}")

      {:error, :invalid_format, inv_format} ->
        Conn.send_resp(conn, Status.code(:bad_request), "Invalid format specified: #{inspect inv_format}")
    end
  end

  defp parse(params) when params === %{}, do: {:error, :empty_query}

  defp parse(params) do
    db_query =
      params
      |> Stream.map(fn {key, vals} -> {key, String.split(vals, ",")} end)
      |> Enum.to_list()

    {:ok, db_query}
  end

end
