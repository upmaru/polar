defmodule Polar.Streams.Product.Manager do
  alias Polar.Repo
  alias Polar.Streams.Product

  def list(scopes) do
    scopes
    |> Enum.reduce(Product, &Product.scope/2)
    |> Repo.all()
  end

  def get(key) when is_binary(key) do
    key
    |> Base.url_decode64()
    |> case do
      {:ok, decoded} ->
        String.split(decoded, ":")

      :error ->
        String.split(key, ":")
    end
    |> case do
      [os, release, arch, variant] ->
        attrs = %{
          os: os,
          release: release,
          arch: arch,
          variant: variant
        }

        get(attrs)

      _ ->
        nil
    end
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
