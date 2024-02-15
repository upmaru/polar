defmodule Polar.Streams.Product.Manager do
  alias Polar.Repo
  alias Polar.Streams.Product

  def list(scopes) do
    scopes
    |> Enum.reduce(Product, &Product.filter/2)
    |> Repo.all()
  end

  def get(attrs) do
    Repo.get_by(Product, attrs)
  end

  def create(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end
end
