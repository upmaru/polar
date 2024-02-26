defmodule Polar.Streams.Version.Transitions do
  @behaviour Eventful.Handler
  use Eventful.Transition, repo: Polar.Repo

  alias Polar.Streams.Version

  Version
  |> transition(
    [from: "active", to: "inactive", via: "deactivate"],
    fn changes -> transit(changes) end
  )
end
