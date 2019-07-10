defmodule FootbalInterface.Web.Controllers.Ping do
  @moduledoc """
  Basic ping controller which will always return 200.
  Used periodically to check if the server is alive.
  """

  alias Plug.Conn
  alias Plug.Conn.Status

  def process(%Conn{} = conn), do: Conn.send_resp(conn, Status.code(:ok), "ok")

end
