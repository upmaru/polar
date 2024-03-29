defmodule Polar.Accounts.Space.Credential.Event do
  alias Polar.Accounts.Space
  alias Polar.Accounts.User

  use Eventful,
    parent: {:space_credential, Space.Credential},
    actor: {:user, User}

  alias Space.Credential.Transitions

  handle(:transitions, using: Transitions)
end
