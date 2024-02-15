defmodule PolarWeb.Publish.VersionJSON do
  def create(%{version: version}) do
    %{data: %{id: version.id}}
  end
end
