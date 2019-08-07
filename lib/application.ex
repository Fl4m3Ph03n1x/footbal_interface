defmodule FootbalInterface.Application do
  @moduledoc false

  use Application

  alias FootbalEngine
  alias FootbalInterface.Web.Router
  alias FootbalInterface.Web.Plugs.{MetricsExporter, MetricsInstrumenter}
  alias Plug.Cowboy

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do

    MetricsExporter.setup()
    MetricsInstrumenter.setup()

    http_port = Application.fetch_env!(:footbal_interface, :http_port)
    file_path = Application.fetch_env!(:footbal_interface, :path)

    cowboy_pool =
      Cowboy.child_spec(
        scheme: :http,
        plug: Router,
        options: [port: http_port]
    )

    children = [
      cowboy_pool,
      {FootbalEngine.Populator.Server, file_path}
    ]
    opts = [strategy: :one_for_one, name: FootbalInterface.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
