defmodule PolarWeb.Streams.ImageController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Accounts
  alias Polar.Streams

  action_fallback PolarWeb.FallbackController

  def index(conn, %{"space_token" => space_token}) do
    credential = Accounts.get_space_credential(token: space_token)

    if credential do
      products =
        Streams.list_products([:active])
        |> Repo.preload(active_versions: [:items])

      render(conn, :index, %{products: products, credential: credential})
    end
  end

  def index(_conn, _), do: {:error, :not_found}
end
