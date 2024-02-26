defimpl Eventful.Transit, for: Polar.Streams.Version do
  alias Polar.Streams.Version.Event

  def perform(version, user, event_name, options \\ []) do
    comment = Keyword.get(options, :comment)
    domain = Keyword.get(options, :domain, "transitions")
    parameters = Keyword.get(options, :parameters, %{})

    version
    |> Event.handle(user, %{
      domain: domain,
      name: event_name,
      comment: comment,
      parameters: parameters
    })
  end
end
