defimpl Eventful.Transit, for: Polar.Machines.Cluster do
  alias Polar.Machines.Cluster.Event

  def perform(cluster, user, event_name, options \\ []) do
    comment = Keyword.get(options, :comment)
    domain = Keyword.get(options, :domain, "transitions")
    parameters = Keyword.get(options, :parameters, %{})

    cluster
    |> Event.handle(user, %{
      domain: domain,
      name: event_name,
      comment: comment,
      parameters: parameters
    })
  end
end
