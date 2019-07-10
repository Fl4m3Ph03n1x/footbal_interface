defmodule FootbalInterface.Web.Router do
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
