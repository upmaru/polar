defmodule Polar.Streams.ReleaseChannel do
  def entries,
    do: %{
      "active" => %{
        scope: [:active],
        preload: [active_versions: [:items]]
      },
      "testing" => %{
        scope: [:testing],
        preload: [testing_versions: [:items]]
      }
    }

  def valid_names do
    Map.keys(entries())
  end
end
