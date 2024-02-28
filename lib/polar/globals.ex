defmodule Polar.Globals do
  alias Polar.Repo
  alias Polar.Globals.Basic
  alias Polar.Globals.Setting

  @defaults %{
    "basic" => Basic
  }

  def get(key) do
    Setting
    |> Repo.get_by(key: key)
    |> case do
      nil ->
        module = Map.fetch!(@defaults, key)

        struct(module, %{})

      %Setting{value: value} ->
        module = Map.fetch!(@defaults, key)

        module.parse!(value)
    end
  end
end
