defmodule PolarWeb.Publish.VersionJSON do
  def show(%{version: version}) do
    %{data: %{id: version.id}}
  end

  def create(%{version: version}) do
    %{data: %{id: version.id}}
  end
end
