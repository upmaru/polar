defmodule Polar.Streams.Version.Event do
  alias Polar.Streams.Version
  alias Polar.Accounts.User

  use Eventful,
    parent: {:version, Version},
    actor: {:user, User}

  alias Version.Transitions

  handle(:transitions, using: Transitions)
end
