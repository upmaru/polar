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
        bot = Polar.Accounts.Automation.get_bot!()

        basic_setting = Globals.get("basic")

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

        result

      error ->
        error
    end
  end
end
