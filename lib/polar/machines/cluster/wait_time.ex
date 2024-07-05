defmodule Polar.Machines.Cluster.WaitTime do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  @primary_key false
  embedded_schema do
    field :type, :string
    field :duration, :integer
  end

  def changeset(wait_time, params) do
    wait_time
    |> cast(params, [:type, :duration])
    |> validate_inclusion(:type, ["container", "vm"])
  end
end
