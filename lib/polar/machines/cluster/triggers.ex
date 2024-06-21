defmodule Polar.Machines.Cluster.Triggers do
  use Eventful.Trigger

  alias Polar.Machines.Cluster

  Cluster
  |> trigger([currently: "connecting"], fn event, cluster ->
    %{user_id: event.user_id, cluster_id: cluster.id}
    |> Connect.new()
    |> Oban.insert()
  end)
end
