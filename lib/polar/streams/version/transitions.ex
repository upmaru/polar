defmodule Polar.Streams.Version.Transitions do
  @behaviour Eventful.Handler
  use Eventful.Transition, repo: Polar.Repo

  alias Polar.Streams.Version

  Version
  |> transition(
    [from: "created", to: "testing", via: "test"],
    fn changes -> transit(changes) end
  )

  Version
  |> transition(
    [from: "testing", to: "inactive", via: "deactivate"],
    fn changes -> transit(changes) end
  )

  Version
  |> transition(
    [from: "testing", to: "active", via: "activate"],
    fn changes -> transit(changes, Version.Triggers) end
  )

  Version
  |> transition(
    [from: "active", to: "inactive", via: "deactivate"],
    fn changes -> transit(changes) end
  )
end
