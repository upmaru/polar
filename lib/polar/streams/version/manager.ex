defmodule Polar.Streams.Version.Manager do
  alias Polar.Repo
  alias Polar.Globals
  alias Polar.Streams.Version

  import Ecto.Query, only: [from: 2]

  def create(product, attrs) do
    %Version{product_id: product.id}
    |> Version.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, version} = result ->
        deactivate_previous(version)

        result

      error ->
        error
    end
  end

  def deactivate_previous(version) do
    basic_setting = Globals.get("basic")
    bot = Polar.Accounts.Automation.get_bot!()

    from(
      v in Version,
      where:
        v.product_id == ^version.product_id and
          v.current_state == ^"active",
      offset: ^basic_setting.versions_per_product,
      order_by: [desc: :inserted_at]
    )
    |> Repo.all()
    |> Enum.each(fn v ->
      Eventful.Transit.perform(v, bot, "deactivate")
    end)
  end
end
