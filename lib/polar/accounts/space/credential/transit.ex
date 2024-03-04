defimpl Eventful.Transit, for: Polar.Accounts.Space.Credential do
  alias Polar.Accounts.Space.Credential.Event

  def perform(credential, user, event_name, options \\ []) do
    comment = Keyword.get(options, :comment)
    domain = Keyword.get(options, :domain, "transitions")
    parameters = Keyword.get(options, :parameters, %{})

    credential
    |> Event.handle(user, %{
      domain: domain,
      name: event_name,
      comment: comment,
      parameters: parameters
    })
  end
end
