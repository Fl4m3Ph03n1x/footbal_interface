defmodule FootbalInterface.Application do
  @moduledoc false

  use Application

  alias FootbalEngine.QuickSearch
  alias FootbalInterface.Web.Router
  alias FootbalInterface.Web.Plugs.{MetricsExporter, MetricsInstrumenter}
  alias Plug.Cowboy

  require Logger

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
      cowboy_pool
    ]
    opts = [strategy: :one_for_one, name: FootbalInterface.Supervisor]

    case QuickSearch.new(file_path) do
      {:ok, :indexation_successful} ->
        Logger.info("""
        Application launched successfully.
        Waiting for requests.
        """)
        Supervisor.start_link(children, opts)

      {:ok, :partial_indexation_successful, fails} ->
        Logger.warn("""
        Application launched with errors. Check the CSV file for:
        #{inspect fails}
        Waiting for requests.
        """)
        Supervisor.start_link(children, opts)

      {:error, :no_valid_data_to_save} ->
        Logger.error("""
        Failed to launch application. CSV file has no valid data.
        Shutting down.
        """)
        {:error, :invalid_csv}

      {:error, reason} ->
        Logger.error("""
        Failed to launch application. An unknown error occurred:
        #{inspect reason}
        Shutting down.
        """)
        {:error, reason}
    end

  end
end
