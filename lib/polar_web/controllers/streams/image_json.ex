defmodule PolarWeb.Streams.ImageJSON do
  @doc """
  Renders product listing
  """
  def index(%{}) do
    %{content_id: "images", datatype: "image-downloads", format: "products:1.0"}
  end
end
