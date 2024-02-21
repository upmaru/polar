defmodule Polar.Accounts.Space.Credential.Transitions do
  @behaviour Eventful.Handler
  use Eventful.Transition, repo: Polar.Repo

  alias Polar.Accounts.Space.Credential

  Credential
  |> transition(
    [from: "created", to: "active", via: "activate"],
    fn changes -> transit(changes) end
  )

  Credential
  |> transition(
    [from: "active", to: "expired", via: "expire"],
    fn changes -> transit(changes) end
  )

  Credential
  |> transition(
    [from: "active", to: "deleted", via: "delete"],
    fn changes -> transit(changes) end
  )
end
