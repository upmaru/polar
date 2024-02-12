defmodule PolarWeb.StreamJSON do
  alias Polar.Streams.Product

  @doc """
  Renders streams index
  """
  def index(%{products: products}) do
    %{
      index: %{
        images: %{
          datatype: "image-downloads",
          path: "streams/v1/images.json",
          format: "product:1.0",
          products: Enum.map(products, &Product.key/1)
        }
      },
      format: "index:1.0"
    }
  end
end
