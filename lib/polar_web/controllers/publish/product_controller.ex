defmodule PolarWeb.Publish.ProductController do
  use PolarWeb, :controller

  alias Polar.Streams.Product

  action_fallback PolarWeb.FallbackController

  def show(conn, %{"id" => product_key}) do
    [os, release, arch, variant] =
      product_key
      |> Base.url_decode64!()
      |> String.split(":")

    product =
      Streams.get_or_create_product!(%{
        os: os,
        release: release,
        arch: arch,
        variant: variant
      })

    render(conn, :show, %{product: product})
  end
end
