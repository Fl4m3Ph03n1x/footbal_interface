defmodule FootbalInterface.Workflow.Search do
  @moduledoc """
  Flow of a search request. Parses the request and queries the DB.
  """

  @behaviour FootbalInterface.Workflow

  alias FootbalEngine
  alias FootbalInterface.Formatter
  alias FootbalInterface.Workflow

  @default_deps [
    search: &FootbalEngine.search/1,
    format: &Formatter.format/2
  ]

  @doc """
  Parses the given map, and queries the DB. For the arguments see
  c:FootbalInterface.Workflow.run/2

  Returns:
  - `{:error, :empty_query}`: if the request is empty
  - `{:error, :invalid_headers, inv_headers}`: if the request has invalid
    headers, such as "Banana" when the CSV does not have a "Banana" column.
    `inv_headers` are the headers marked as invalid.
  - `{:error, :json_encoding_failed, err}`: if enconding the result into JSON
    failed. `err` is the error that was raised.
  - `{:error, :protobuff_encoding_failed, err}`: if enconding the result into
    protobuff failed. `err` is the error that was raised.
  - `{:error, :invalid_format, inv_format}`: if the request asks for an invalid
    format, such as "oranges". `inv_format` is the format requested that cannot
    be used.
  """
  @spec run(map, keyword) ::
    {:ok, String.t}
    | {:error, :empty_query}
    | {:error, :invalid_headers, [String.t]}
    | {:error, :json_encoding_failed, any}
    | {:error, :protobuff_encoding_failed, any}
    | {:error, :invalid_format, String.t}
  @impl Workflow
  def run(query, injected_deps \\ []) do
    deps = Keyword.merge(@default_deps, injected_deps)

    all_params = Map.get(query, :query_params)
    query_format = Map.get(all_params, "format", "json")
    query_params = Map.delete(all_params, "format")

    with  {:ok, db_query} <- parse(query_params),
          {:ok, results}  <- deps[:search].(db_query),
          {:ok, answer}   <- deps[:format].(results, query_format)
    do
      {:ok, answer}
    end
  end

  @spec parse(Map.t) ::
    {:ok, [{String.t, [String.t]}]}
    | {:error, :empty_query}
  defp parse(params) when params === %{}, do: {:error, :empty_query}

  defp parse(params) do
    db_query =
      params
      |> Stream.map(fn
        {key, ""} -> {key, []}
        {key, nil} -> {key, []}
        {key, vals} -> {key, String.split(vals, ",")}
      end)
      |> Enum.to_list()

    {:ok, db_query}
  end

end
