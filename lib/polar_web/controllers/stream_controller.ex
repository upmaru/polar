defmodule PolarWeb.StreamController do
  use PolarWeb, :controller

  alias Polar.Accounts
  alias Polar.Streams

  alias Polar.Streams.ReleaseChannel

  action_fallback PolarWeb.FallbackController

  def index(conn, %{"space_token" => space_token}) do
    credential = Accounts.get_space_credential(token: space_token)

    if credential do
      release_channel =
        ReleaseChannel.entries()
        |> Map.fetch!(credential.release_channel)

      products = Streams.list_products(release_channel.scope)

      render(conn, :index, %{products: products})
    end
  end
end
