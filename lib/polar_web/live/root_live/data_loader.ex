defmodule PolarWeb.RootLive.DataLoader do
  alias Polar.Repo
  alias Polar.Streams.Product
  alias Polar.Streams.Version

  import Ecto.Query, only: [from: 2]

  def load_tabs do
    from(
      p in Product,
      select: %{os: p.os, count: count(p.id)},
      group_by: [:os],
      order_by: [:os]
    )
    |> Repo.all()
    |> Enum.with_index(1)
  end

  def load_versions(filter) do
    query =
      from(
        v in Version,
        join: p in assoc(v, :product),
        preload: [{:product, p}],
        where: v.current_state == ^"active",
        order_by: [asc: p.os],
        order_by: [desc: p.release],
        order_by: [desc: v.inserted_at]
      )

    Enum.reduce(filter, query, &filter/2)
    |> Repo.all()
  end

  defp filter({"os", os}, queryable) do
    from(v in queryable,
      join: p in assoc(v, :product),
      where: p.os == ^os
    )
  end

  defp filter(_, queryable), do: queryable
end
