defmodule Polar.Machines.Assessment.Transitions do
  @behaviour Eventful.Handler
  use Eventful.Transition, repo: Polar.Repo

  alias Polar.Machines.Assessment

  Assessment
  |> transition(
    [from: "created", to: "running", via: "run"],
    fn changes -> transit(changes) end
  )

  Assessment
  |> transition(
    [from: "failed", to: "running", via: "run"],
    fn changes -> transit(changes) end
  )

  Assessment
  |> transition(
    [from: "running", to: "running", via: "run"],
    fn changes -> transit(changes) end
  )

  Assessment
  |> transition(
    [from: "running", to: "passed", via: "pass"],
    fn changes -> transit(changes) end
  )

  Assessment
  |> transition(
    [from: "running", to: "failed", via: "fail"],
    fn changes -> transit(changes) end
  )
end
