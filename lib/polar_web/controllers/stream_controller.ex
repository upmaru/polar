defmodule PolarWeb.StreamController do
  use PolarWeb, :controller

  alias Polar.Accounts
  alias Polar.Streams

  action_fallback PolarWeb.FallbackController

  def index(conn, %{"space_token" => space_token}) do
    credential = Accounts.get_space_credential(token: space_token)

    if credential do
      Accounts.increment_space_credential_access(credential)

      products = Streams.list_products([:active])

      render(conn, :index, %{products: products})
    end
  end
end
