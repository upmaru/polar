defmodule Polar.Streams.Version.Manager do
  alias Polar.Repo
  alias Polar.Streams.Version

  def create(product, attrs) do
    %Version{product_id: product.id}
    |> Version.changeset(attrs)
    |> Repo.insert()
  end
end
