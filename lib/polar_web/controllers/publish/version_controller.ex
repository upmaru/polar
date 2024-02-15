defmodule PolarWeb.Publish.VersionController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Streams
  alias Polar.Streams.Product

  action_fallback PolarWeb.FallbackController

  def create(conn, %{"product_id" => product_id, "version" => version_params}) do
    product = Repo.get(Product, product_id)

    if product do
      {:ok, version} = Streams.create_version(product, version_params)

      conn
      |> put_status(:created)
      |> render(:create, %{version: version})
    end
  end
end
