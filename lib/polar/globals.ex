defmodule Polar.Globals do
  alias Polar.Repo
  alias Polar.Globals.Basic
  alias Polar.Globals.Setting

  @mappings %{
    "basic" => Basic
  }

  def get(key) do
    Setting
    |> Repo.get_by(key: key)
    |> case do
      nil ->
        module = Map.fetch!(@mappings, key)

        struct(module, %{})

      %Setting{value: value} ->
        module = Map.fetch!(@mappings, key)

        module.parse!(:erlang.binary_to_term(value))
    end
  end

  def save(key, value) when is_map(value) do
    case Repo.get_by(Setting, key: key) do
      nil ->
        create(key, value)

      %Setting{} = setting ->
        update(setting, value)
    end
  end

  defp create(key, value) when is_map(value) do
    module = Map.fetch!(@mappings, key)

    case module.parse(value) do
      {:ok, params} = result ->
        value =
          Map.from_struct(params)
          |> :erlang.term_to_binary()

        Repo.insert!(%Setting{key: key, value: value})

        result

      error ->
        error
    end
  end

  defp update(setting, value) when is_map(value) do
    module = Map.fetch!(@mappings, setting.key)

    case module.parse(value) do
      {:ok, params} = result ->
        value =
          Map.from_struct(params)
          |> :erlang.term_to_binary()

        setting
        |> Setting.changeset(%{value: value})
        |> Repo.update!()

        result

      error ->
        error
    end
  end
end
