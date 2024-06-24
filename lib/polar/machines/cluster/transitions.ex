defmodule Polar.Machines.Cluster.Transitions do
  @behaviour Eventful.Handler
  use Eventful.Transition, repo: Polar.Repo

  alias Polar.Machines.Cluster

  Cluster
  |> transition(
    [from: "created", to: "connecting", via: "connect"],
    fn changes -> transit(changes, Cluster.Triggers) end
  )

  Cluster
  |> transition(
    [from: "connecting", to: "healthy", via: "healthy"],
    fn changes -> transit(changes) end
  )

  Cluster
  |> transition(
    [from: "connecting", to: "created", via: "revert"],
    fn changes -> transit(changes) end
  )
end
