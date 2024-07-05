defmodule Polar.Streams.Version.Triggers do
  use Eventful.Trigger

  alias Polar.Streams
  alias Polar.Streams.Version

  Version
  |> trigger([currently: "active"], &Streams.deactivate_previous_versions/2)
end
