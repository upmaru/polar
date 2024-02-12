defmodule PolarWeb.StreamController do
  use PolarWeb, :controller

  alias Polar.Streams

  def index(conn, _params) do
    products = Streams.list_products([:active])
    render(conn, :index, %{products: products})
  end
end
