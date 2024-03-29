defmodule FootbalInterface.Web.Controllers.NotFound do
  @moduledoc """
  Runs when no URL matches.
  """

  alias Plug.Conn
  alias Plug.Conn.Status

  @spec process(Conn.t) :: Conn.t
  def process(%Conn{} = conn), do:
    Conn.send_resp(conn, Status.code(:not_found), "Page Not Found")

end
