defmodule PolarWeb.Publish.ProductJSON do
  alias Polar.Streams.Product

  def show(%{product: product}) do
    %{
      data: %{
        id: product.id,
        key: Product.key(product),
        requirements: product.requirements
      }
    }
  end
end
