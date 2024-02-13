defmodule PolarWeb.StreamController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Accounts
  alias Polar.Streams

  action_fallback PolarWeb.FallbackController

  import Ecto.Query, only: [from: 2]

  def index(conn, %{"space_token" => space_token}) do
    credential = Accounts.get_space_credential(token: space_token)

    if credential do
      from(c in Accounts.Space.Credential, where: c.id == ^credential.id)
      |> Repo.update_all(inc: [access_count: 1])

      products = Streams.list_products([:active])

      render(conn, :index, %{products: products})
    end
  end
end
