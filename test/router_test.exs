defmodule FootbalInterface.RouterTest do
  use ExUnit.Case, async: false
  use Plug.Test

  alias FootbalInterface.Web.Router
  alias Plug.Conn.Status

  @opts Router.init([])

  describe "/ping" do
    test "returns ok" do
      connection = Router.call(
        conn(:get, "/ping"),
        @opts
      )

      assert connection.state == :sent
      assert connection.status == Status.code(:ok)
      assert connection.resp_body == "ok"
    end
  end

  describe "/" do
    test "returns 404 by default" do
      connection = Router.call(
        conn(:get, "/somethingfailing?signature=Mandala"),
        @opts
      )

      assert connection.state == :sent
      assert connection.status == Status.code(:not_found)
      assert connection.resp_body == "Page Not Found"
    end
  end

  describe "/search" do
    test "returns results from query" do
      connection = Router.call(
        conn(:get, "/search?Div=SP1,SP2&Season=201617"),
        @opts
      )

      assert connection.state == :sent
      assert connection.status == Status.code(:ok)
    end

    test "returns 400 when request is empty" do
      connection = Router.call(
        conn(:get, "/search"),
        @opts
      )

      assert connection.state == :sent
      assert connection.status == Status.code(:bad_request)
      assert connection.resp_body == "Empty Query"
    end

    test "returns 400 when request has incorrect headers" do
      connection = Router.call(
        conn(:get, "/search?Bananas=fruit"),
        @opts
      )

      assert connection.state == :sent
      assert connection.status == Status.code(:bad_request)
    end

    test "returns 400 when request has a non existent format" do
      connection = Router.call(
        conn(:get, "/search?Div=E0&format=bananas"),
        @opts
      )

      assert connection.state == :sent
      assert connection.status == Status.code(:bad_request)
    end
  end

end
