defmodule FootbalInterface.Web.Router do
  @moduledoc """
  Plug Router for all incoming requests. Feeds the metrics modules with data
  and dispatches the requests to the correct controllers after.
  """

  use Plug.Router

  alias FootbalInterface.Web.Plugs.{MetricsExporter, MetricsInstrumenter}
  alias FootbalInterface.Web.Controllers.{Ping, Search, NotFound}

  plug(:match)
  plug(MetricsInstrumenter)
  plug(MetricsExporter)
  plug(:dispatch)

  get "/ping",    do: Ping.process(conn)
  get "/search",  do: Search.process(conn)

  match _, do: NotFound.process(conn)
end
