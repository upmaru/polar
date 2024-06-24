defmodule PolarWeb.Publish.Testing.CheckJSON do
  alias Polar.Machines.Check

  def index(%{checks: checks}) do
    %{data: Enum.map(checks, &data/1)}
  end

  def data(%Check{} = check) do
    %{id: check.id, slug: check.slug}
  end
end
