defmodule PolarWeb.Publish.VersionController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Streams
  alias Polar.Streams.Product
  alias Polar.Streams.Version

  action_fallback PolarWeb.FallbackController

  def show(conn, %{"product_id" => product_id, "id" => serial}) do
    version = Repo.get_by(Version, product_id: product_id, serial: serial)

    if version do
      render(conn, :show, %{version: version})
    end
  end

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
