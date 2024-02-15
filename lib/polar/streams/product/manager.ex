defmodule Polar.Streams.Product.Manager do
  alias Polar.Repo
  alias Polar.Streams.Product

  def list(scopes) do
    scopes
    |> Enum.reduce(Product, &Product.filter/2)
    |> Repo.all()
  end

  def get(key) when is_binary(key) do
    [os, release, arch, variant] =
      case Base.url_decode64(key) do
        {:ok, decoded} ->
          String.split(decoded, ":")

        :error ->
          String.split(key, ":")
      end

    attrs = %{
      os: os,
      release: release,
      arch: arch,
      variant: variant
    }

    get(attrs)
  end

  def get(attrs) when is_map(attrs) do
    Repo.get_by(Product, attrs)
  end

  def create(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def update(product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end
end
