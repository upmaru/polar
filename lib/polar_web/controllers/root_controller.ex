defmodule PolarWeb.RootController do
  use PolarWeb, :controller

  alias Polar.Streams

  def show(conn, _params) do
    products =
      Streams.list_products([:active, :with_latest_version])
      |> Enum.group_by(fn p -> {p.os, p.release} end)

    render(conn, :show, layout: false, grouped_products: products)
  end
end
