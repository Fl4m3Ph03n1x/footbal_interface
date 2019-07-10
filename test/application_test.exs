defmodule FootbalInterface.ApplicationTest do
  @moduledoc """
  This test runs the starting code of the application to cover it,
  as it is not covered by regular tests.
  It should not interfere with other testing as it will not actually start
  the application. In test env the VM will report it to be `:already_started`.
  """
  use ExUnit.Case

  alias FootbalInterface.Application

  test "start code does not crash" do
    {:error, {:already_started, _pid}} = Application.start(:normal, [])
  end
end
