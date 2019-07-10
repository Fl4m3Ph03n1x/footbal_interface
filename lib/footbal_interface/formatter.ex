defmodule FootbalInterface.Formatter do

  alias FootbalInterface.Messages

  @spec format(any, String.t) ::
          {:ok, String.t}
          | {:error, :invalid_format | :json_encoding_failed | :protobuff_encoding_failed, any}
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
