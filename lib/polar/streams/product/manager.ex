defmodule Polar.Streams.Product.Manager do
  alias Polar.Repo
  alias Polar.Streams.Product

  def get_or_create!(attrs) do
    Product
    |> Repo.get_by(
      arch: attrs.arch,
      os: attrs.os,
      release: attrs.release,
      variant: attrs.variant
    )
    |> case do
      nil ->
        %Product{}
        |> Product.changeset(attrs)
        |> Repo.insert!()

      %Product{} = product ->
        product
    end
  end
end
