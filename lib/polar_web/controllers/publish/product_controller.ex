defmodule PolarWeb.Publish.ProductController do
  use PolarWeb, :controller

  alias Polar.Streams

  action_fallback PolarWeb.FallbackController

  def show(conn, %{"id" => product_key}) do
    product = Streams.get_product(product_key)

    if product do
      render(conn, :show, %{product: product})
    end
  end
end
