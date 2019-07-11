defmodule FootbalInterface.Formatter do
  @moduledoc """
  Contains the logic to convert messages into the various protocols supported.
  Currently supports JSON and Google's Protocol Buffer.
  """

  alias FootbalInterface.Messages

  @doc """
  Receives a list of results and converts it to either JSON or protobuf.

  Arguments:
  - `results`: the list of results from a DB query.
  - `format`: the format to convert to.

  Returns:
  - `{:ok, result}`: Tagged :ok tuple with the result in binary.
  - `{:error, :invalid_format, inv_format}`: if the requested format is not
    supported. `inv_format` is the invalid format.
  - `{:error, :json_encoding_failed, err}`: if converting the data to JSON
    failed. `err` is the error raised.
  - `{:error, :protobuff_encoding_failed, err}`: if converting the data to
    protobuff failed. `err` is the error raised.
  """
  @spec format(results :: [Map.t], format :: String.t) ::
    {:ok, String.t}
    | {:error, :invalid_format, String.t}
    | {:error, :json_encoding_failed, any}
    | {:error, :protobuff_encoding_failed, any}
  def format(results, "json") do
    {:ok, Jason.encode!(results, pretty: true)}
  rescue
    err -> {:error, :json_encoding_failed, err}
  end

  def format(results, "protobuff") do
    results
    |> Enum.map(&map_to_proto/1)
    |> build_reponse()
  end

  def format(_results, format), do: {:error, :invalid_format, format}

  defp map_to_proto(map) do
    map
    |> Enum.map(&kv_to_proto_tuple/1)
    |> Messages.Entry.new()
  end

  defp kv_to_proto_tuple({"Date", val}), do: {:Date, to_string(val)}
  defp kv_to_proto_tuple({key, val}), do: {String.to_atom(key), val}

  defp build_reponse(entries) do
    msg = Messages.Response.new(results: entries)
    encoded = Messages.Response.encode(msg)
    {:ok, encoded}
  rescue
    err -> {:error, :protobuff_encoding_failed, err}
  end
end
