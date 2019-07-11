defmodule FootbalInterface.Workflow do
  @moduledoc """
  Worflows represent the logic that controllers use. They implement the steps
  that requests need to take to be completed and return answer ready for the
  controllers to decode.

  This approach means all controllers will be very skim and easy to follow.
  Controllers are a detail, the logic should be independent from them. Workflows
  ensure that happens.
  """

  @doc """
  Executes the workflow logic. Returns an tagged :ok tupple, or any, where
  any takes the form of an :error tagged tuple of arbitrary size.
  For the possible return values each implementation, see the specs docs of said
  implementation.

  Arguments:
  - `query`: a Map.t containing the query arguments.
  - `injected_deps`: optional keyword list with dependencies.
  """
  @callback run(query :: Map.t, injected_deps :: keyword) ::
    {:ok, String.t}
    | any
end
