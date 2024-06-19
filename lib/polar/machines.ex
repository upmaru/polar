defmodule Polar.Machines do
  alias __MODULE__.Manager

  defdelegate create_cluster(params),
    to: Manager,
    as: :create
end
