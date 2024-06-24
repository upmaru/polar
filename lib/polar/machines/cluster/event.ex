defmodule Polar.Machines.Cluster.Event do
  alias Polar.Machines.Cluster
  alias Polar.Accounts.User

  use Eventful,
    parent: {:cluster, Cluster},
    actor: {:user, User}

  alias Cluster.Transitions

  handle(:transitions, using: Transitions)
end
