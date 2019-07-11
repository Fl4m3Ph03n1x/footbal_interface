defmodule FootbalInterface.Web.Controllers.Search do
  @moduledoc """
  Maps the results of the search query made to HTTP and sends the response
  to the client.
  """

  alias FootbalInterface.Workflow.Search, as: Flow
  alias Plug.Conn
  alias Plug.Conn.Status

  @default_deps [
    run_flow: &Flow.run/1
  ]

  @spec process(Conn.t, keyword) :: Conn.t
  def process(%Conn{} = conn, injected_deps \\ []) do
    deps = Keyword.merge(@default_deps, injected_deps)

    case deps[:run_flow].(Conn.fetch_query_params(conn)) do
      {:ok, answer} ->
        Conn.send_resp(conn, Status.code(:ok), answer)

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

end
