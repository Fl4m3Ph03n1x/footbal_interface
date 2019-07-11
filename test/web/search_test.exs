defmodule FootbalInterface.SearchTest do
  use ExUnit.Case

  alias FootbalInterface.Web.Controllers.Search
  alias Plug.Conn.Status
  alias Plug.Test

  test "returns results from query" do
    deps = [
      run_flow: fn _params -> {:ok, "ok"} end
    ]
    conn = Test.conn("GET", "/search")

    resp_conn = Search.process(conn, deps)

    assert resp_conn.status == Status.code(:ok)
    assert resp_conn.resp_body == "ok"
  end

  test "returns 400 when request is empty" do
    deps = [
      run_flow: fn _params -> {:error, :empty_query} end
    ]

    conn = Test.conn("GET", "/search")

    resp_conn = Search.process(conn, deps)

    assert resp_conn.status == Status.code(:bad_request)
    assert resp_conn.resp_body == "Empty Query"
  end

  test "returns 400 when request has incorrect headers" do
    deps = [
      run_flow: fn _params -> {:error, :invalid_headers, ["banana", "orange"]} end
    ]

    conn = Test.conn("GET", "/search")

    resp_conn = Search.process(conn, deps)

    assert resp_conn.status == Status.code(:bad_request)
    assert resp_conn.resp_body == "Invalid Headers: [\"banana\", \"orange\"]"
  end

  test "returns 422 when fails to convert query results to JSON" do
    deps = [
      run_flow: fn _params -> {:error, :json_encoding_failed, "err"} end
    ]

    conn = Test.conn("GET", "/search")

    resp_conn = Search.process(conn, deps)

    assert resp_conn.status == Status.code(:unprocessable_entity)
    assert resp_conn.resp_body == "Failed to JSON enconde query results: \"err\""
  end

  test "returns 422 when fails to convert query results to protobuf" do
    deps = [
      run_flow: fn _params -> {:error, :protobuff_encoding_failed, "err"} end
    ]

    conn = Test.conn("GET", "/search")

    resp_conn = Search.process(conn, deps)

    assert resp_conn.status == Status.code(:unprocessable_entity)
    assert resp_conn.resp_body == "Failed to Protobuff enconde query results: \"err\""
  end

  test "returns 400 when request has a non existent format" do
    deps = [
      run_flow: fn _params -> {:error, :invalid_format, "apple"} end
    ]

    conn = Test.conn("GET", "/search")

    resp_conn = Search.process(conn, deps)

    assert resp_conn.status == Status.code(:bad_request)
    assert resp_conn.resp_body == "Invalid format specified: \"apple\""
  end
end
