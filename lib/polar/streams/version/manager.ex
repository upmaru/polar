defmodule Polar.Streams.Version.Manager do
  alias Polar.Repo
  alias Polar.Globals
  alias Polar.Streams.Version

  import Ecto.Query, only: [from: 2]

  def create(product, attrs) do
    %Version{product_id: product.id}
    |> Version.changeset(attrs)
    |> Repo.insert()
  end

  def deactivate_previous(event, version) do
    basic_setting = Globals.get("basic")
    bot = Polar.Accounts.Automation.get_bot!()

    results =
      from(
        v in Version,
        where:
          v.product_id == ^version.product_id and
            v.current_state == ^"active",
        offset: ^basic_setting.versions_per_product,
        order_by: [desc: :inserted_at]
      )
      |> Repo.all()
      |> Enum.map(fn v ->
        Eventful.Transit.perform(v, bot, "deactivate",
          comment: "New version activated.",
          parameters: %{"event_id" => event.id}
        )
      end)

    {:ok, results}
  end
end
