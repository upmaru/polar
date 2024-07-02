defmodule PolarWeb.Publish.VersionJSON do
  def show(%{version: version}) do
    %{data: %{id: version.id, serial: version.serial}}
  end

  def create(%{version: version}) do
    %{data: %{id: version.id, serial: version.serial}}
  end
end
