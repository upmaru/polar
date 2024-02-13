defmodule Polar.Accounts.Space.Credential.Transitions do
  @behaviour Eventful.Handler
  use Eventful.Transition, repo: Polar.Repo

  alias Polar.Accounts.Space.Credential

  Credential
  |> transition(
    [from: "active", to: "inactive", via: "deactivate"],
    fn changes -> transit(changes) end
  )
end
