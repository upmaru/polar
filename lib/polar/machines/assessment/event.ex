defmodule Polar.Machines.Assessment.Event do
  alias Polar.Machines.Assessment
  alias Polar.Accounts.User

  use Eventful,
    parent: {:assessment, Assessment},
    actor: {:user, User}

  alias Assessment.Transitions

  handle(:transitions, using: Transitions)
end
