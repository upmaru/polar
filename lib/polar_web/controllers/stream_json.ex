defmodule PolarWeb.StreamJSON do
  @doc """
  Renders streams index
  """
  def index(%{}) do
    %{
      index: %{
        images: %{
          datatype: "image-downloads",
          path: "streams/v1/images.json",
          format: "product:1.0",
          products: []
        }
      },
      format: "index:1.0"
    }
  end
end
