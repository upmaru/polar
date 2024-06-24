defimpl Eventful.Transit, for: Polar.Machines.Assessment do
  alias Polar.Machines.Assessment.Event

  def perform(assessment, user, event_name, options \\ []) do
    comment = Keyword.get(options, :comment)
    domain = Keyword.get(options, :domain, "transitions")
    parameters = Keyword.get(options, :parameters, %{})

    assessment
    |> Event.handle(user, %{
      domain: domain,
      name: event_name,
      comment: comment,
      parameters: parameters
    })
  end
end
